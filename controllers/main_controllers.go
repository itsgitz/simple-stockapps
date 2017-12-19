// Controller package for Main Controller object
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
package controllers

import (
	"fmt"
	"log"
	"time"
	"strconv"
	//"reflect"
	"net/http"
	"encoding/json"
	"html/template"
	"simple_stockapps/models"
	"simple_stockapps/generator"

	// http session using kataras
	"github.com/kataras/go-sessions"
	"github.com/gorilla/websocket"
)

type MainController struct {
}

// Kataras session config
var (
	session = sessions.New(sessions.Config{
		Cookie: "simple_stockapps_session",
		Expires: time.Hour * 2,
		DisableSubdomainPersistence: false,
	})
	nav_tpl_filename = "views/navigation.tpl"
)

//////////////////////////////////////////////////////////////////////////////////
// Web Socket
var upgrader = websocket.Upgrader{
	ReadBufferSize:		1024,
	WriteBufferSize:	1024,
}
type Message struct {
	Pesan	string 	`json:"Pesan"`
}
var clients = make(map[*websocket.Conn]bool)
var broadcast = make(chan Message)

// handling message as concurrency
func init() {
	go handleMessage()
}

// AppWebSocket function handling incoming message and request using websocket connection
func (this *MainController) AppWebSocket(w http.ResponseWriter, r *http.Request) {
	// we want to using websocket communication, not http
	// so upgrade connection to WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	defer conn.Close()
	if err != nil {
		log.Println(err)
	}

	// Register new connected client
	clients[conn] = true
	
	for {
		var msg Message
		// Read JSON Messages
		err := conn.ReadJSON(&msg)
		if err != nil {
			log.Println(err)
			delete(clients, conn)
			break
		}
		// send message broadcast
		broadcast <- msg
	}
}
// handle incoming message
func handleMessage() {
	for {
		// get message from broadcast channel
		msg := <-broadcast

		// send these messages to all connected clients
		for client := range clients {
			// Write JSON Message
			err := client.WriteJSON(msg)
			if err != nil {
				log.Println(err)
				delete(clients, client)
			}
		}
	}
}

// end of Web Socket
//////////////////////////////////////////////////////////////////////////////////

// Main page controller
func (this *MainController) AppMainPage(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	// get the sessions
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session
	//log.Println("Session:", username_session)
	//log.Println("Session:", user_fullname_session)

	// html template data
	html_data := struct{
		HtmlTitle             		string
		HtmlUserIsLoggedIn			bool
		HtmlUserFullName			string
	}{}

	html_data.HtmlTitle = "Simple StockApps"

	// if username session is not null or user has already logged in into system
	if len(username_session) != 0 {
		html_data.HtmlUserIsLoggedIn = true
		html_data.HtmlUserFullName = user_fullname_session
	} else {
		html_data.HtmlUserIsLoggedIn = false
	}

	// create function map for template
	// add `tambah` function for adding number (arithmetic)
	funcMap := template.FuncMap{
		"tambah": func(i int) int {
			return i + 1
		},
	}

	// template file
	tpl_filename := "views/main.tpl"
	tpl, err := template.New("").Funcs(funcMap).Delims("[[", "]]").ParseFiles(tpl_filename, nav_tpl_filename)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
	// execute template with the given value from html_data struct 
	err = tpl.ExecuteTemplate(w, "main_layout", html_data)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
}

// get the json data from items table in database
// response = application/json
type Items struct {
	Item_id				string  `json:"item_id"`
	Item_name			string  `json:"item_name"`
	Item_model			string  `json:"item_model"`
	Item_limitation		int     `json:"item_limitation"`
	Item_quantity		int     `json:"item_quantity"`
	Item_unit 			string  `json:"item_unit"`
	Date_of_entry		string  `json:"date_of_entry"`
	Item_time_period	string  `json:"item_time_period"`
	Item_expired		string  `json:"item_expired"`
	Item_owner			string  `json:"item_owner"`
	Owner_id			string  `json:"owner_id"`
	Item_location		string  `json:"item_location"`
	Item_status			string  `json:"item_status"`
}

func (this *MainController) AppJSONItemsData(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	values := models.ModelsSelectFromItems()
	x := make([]Items, len(values))

	for i:=0; i<len(values); i++ {
		x[i].Item_id = values[i].Item_id
		x[i].Item_name = values[i].Item_name
		x[i].Item_model = values[i].Item_model
		x[i].Item_quantity = values[i].Item_quantity
		x[i].Item_limitation = values[i].Item_limitation
		x[i].Item_unit = values[i].Item_unit
		x[i].Date_of_entry = values[i].Date_of_entry
		x[i].Item_time_period = values[i].Item_time_period
		x[i].Item_expired = values[i].Item_expired
		x[i].Item_owner = values[i].Item_owner
		x[i].Owner_id = values[i].Owner_id
		x[i].Item_location = values[i].Item_location
		x[i].Item_status = values[i].Item_status
	}

	outgoingJSON, err := json.Marshal(x)
	if err != nil {
		log.Println(err)
	}
	log.Println(len(values))
	fmt.Fprintf(w, string(outgoingJSON))
}

// Searching item in database then create JSON datatype from item_results
func (this *MainController) AppJSONSearchData(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	if r.Method == "POST" {
		w.Header().Set("Content-Type", "application/json")
		search := r.Form["search_value"][0]
		category := r.Form["category"][0]
		var item_to_json []Items

		item_results := models.ModelsSearchForItems(search, category)

		if len(item_results) > 0 {
			item_to_json = make([]Items, len(item_results))
		} else {
			item_to_json = make([]Items, 1)
		}

		if len(item_results) > 0 {
			// fill the json value from item_results (search query)
			for i:=0; i<len(item_results); i++ {
				item_to_json[i].Item_id = item_results[i].Item_id
				item_to_json[i].Item_name = item_results[i].Item_name
				item_to_json[i].Item_model = item_results[i].Item_model
				item_to_json[i].Item_limitation = item_results[i].Item_limitation
				item_to_json[i].Item_quantity = item_results[i].Item_quantity
				item_to_json[i].Item_unit = item_results[i].Item_unit
				item_to_json[i].Date_of_entry = item_results[i].Date_of_entry
				item_to_json[i].Item_time_period = item_results[i].Item_time_period
				item_to_json[i].Item_expired = item_results[i].Item_expired
				item_to_json[i].Item_owner = item_results[i].Item_owner
				item_to_json[i].Owner_id = item_results[i].Owner_id
				item_to_json[i].Item_location = item_results[i].Item_location
				item_to_json[i].Item_status = item_results[i].Item_status
			}
		} else if len(item_results) == 0 {
			item_to_json[0].Item_name = "Not found"
		}

		outgoingJSON, err := json.Marshal(item_to_json)
		if err != nil {
			log.Println(err)
		}
		fmt.Fprintf(w, string(outgoingJSON))
	} else {
		fmt.Fprintf(w, "NOT FOUND BRAY!!")
	}
}

// AppNavbarMainPage function used as AJAX handler and will parsing url by JavaScript
// example:
// /navbar?navigate_link=/items --> load "/items" as AJAX request
// /navbar?navigate_link=/lol --> load "/lol" as AJAX request
// ... and so on
func (this *MainController) AppNavbarMainPage(w http.ResponseWriter, r *http.Request) {
	// session start
	sess := session.Start(w, r)

	// 
	html_data := struct{
		HtmlUserFullName	string
		HtmlUserIsLoggedIn	bool
	}{}

	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session

	// if username session is not null or user has already logged in into system
	if len(username_session) != 0 {
		html_data.HtmlUserIsLoggedIn = true
		html_data.HtmlUserFullName = user_fullname_session
	} else {
		html_data.HtmlUserIsLoggedIn = false
		http.Redirect(w, r, "/", 302)
	}

	// template
	tpl_filename := "views/ajax/ajax_navbar.tpl"
	tpl, err := template.New("").Delims("[[", "]]").ParseFiles(tpl_filename, nav_tpl_filename)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}

	err = tpl.ExecuteTemplate(w, "ajax_navbar_layout", html_data)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
}

// /items handler
// load using ajax
// Handling Add, remove, or request Controllers
func (this *MainController) AppItems(w http.ResponseWriter, r *http.Request) {
	// start session
	sess := session.Start(w, r)

	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session

	// get request method
	//log.Println(r.Method)	// print GET, POST, etc.

	// if http request method is "GET", then display the page
	if r.Method == "GET" {
		if len(username_session) <= 0 && len(user_fullname_session) <= 0 {
			w.Header().Set("Content-Type", "application/json")
			redirectMessage := struct{
				Message 	bool 	`json:"Message"`
			}{}

			redirectMessage.Message = true
			outgoingJSON, err := json.Marshal(redirectMessage)
			if err != nil { log.Println("[!] ERROR:", err) }
			fmt.Fprint(w, string(outgoingJSON))
		} else {

			// template file
			ajax_items_filename := "views/ajax/ajax_items.tpl"
			tpl, err := template.New("").Delims("[[", "]]").ParseFiles(ajax_items_filename)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}
			// execute template
			err = tpl.ExecuteTemplate(w, "items_layout", nil)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}
		}
	// else ("POST"), porcess reqeust as ajax request and parsing data
	} else if r.Method == "POST" {
		r.ParseForm()
		if len(username_session) > 0 && len(user_fullname_session) > 0 {
			// print the request
			//log.Println(r.Form)
			form_request := r.Form["form_request"][0]

			switch(form_request) {
			case "ADD":
				// Add items request
				// handling the values and inserting it to database
				item_name := r.Form["item_name"][0]		// item name to insert (varchar)
				item_model := r.Form["item_model"][0]	// item model to insert (varchar)
				item_quantity := r.Form["item_quantity"][0]	// item quantity to insert (integer)
				item_limitation := r.Form["item_limitation"][0]	// item limitation to insert (integer)
				item_unit := r.Form["item_unit"][0]	// item unit to insert (integer)
				date_of_entry := r.Form["date_of_entry"][0]	// date of entry to insert (datetime)
				time_period := r.Form["time_period"][0]	// time period to insert (integer)
				typeof_time_period := r.Form["typeof_time_period"][0]	// days, week, month (varchar)
				item_owner := r.Form["item_owner"][0] // item owner to insert (varchar)
				item_location := r.Form["item_location"][0] //

				item_quantity_int, _ := strconv.Atoi(item_quantity)
				item_limitation_int, _ := strconv.Atoi(item_limitation)

				// if time period is null or it's zero value,
				// it will create new variable called str_time_prd that contains string value as "NONE"
				var number_of_days int
				var str_time_prd string
				var item_expired string
				var item_status string

				if item_quantity_int > item_limitation_int {
					item_status = "Available"
				} else {
					item_status = "Limited"
				}

				// select days according to type of time period
				number_of_days, _ = strconv.Atoi(time_period)

				if time_period == "0" && typeof_time_period == "0" {
					str_time_prd = "None"
					item_expired = "0000-00-00 00:00:00"
				// else, it will create item_expired
				} else {
					switch(typeof_time_period) {
						case "Day(s)": number_of_days = number_of_days
						break
						case "Week(s)": number_of_days = number_of_days * 7
						break
						case "Month(s)": number_of_days = number_of_days * 30
						break
					}
					// time now initial
					now := time.Now()
					time_duration := time.Duration(number_of_days)	// convert integer to time.Duration datatype
					time_to_add := time.Hour * 24 * (time_duration) // add time to create date expired / determine range of days
					adding_time := now.Add(time_to_add)
					// split string, thus we could only put one value (time)
					time_split := generator.GenerateTimeSplit(date_of_entry)
					item_expired = fmt.Sprintf("%s %s", adding_time.Format("2006-01-02"), time_split)
					str_time_prd = time_period + " " + typeof_time_period // Ex: 2 Day(s)
				}

				// create item_id using generator package
				// DOOOONNNNNNEEEEE
				var owner_id string
				item_id := generator.GenerateID()
				//owner_id := generator.GenerateOwnerID()

				// first is check that item_owner has their owner_id
				//log.Println(models.ModelsReadOwnerID(item_owner)) // true/false
				//log.Println(models.ModelsGetOwnerID(item_owner)) // existing owner id
				//models.ModelsInsertDataTest(item_id, item_name, item_model, item_limitation, item_quantity, item_unit, date_of_entry, str_time_prd, item_expired, item_owner, owner_id, item_location, item_status)

				ownerIdIsExists := models.ModelsReadOwnerID(item_owner)
				if ownerIdIsExists {
					owner_id = models.ModelsGetOwnerID(item_owner) 
				} else {
					owner_id = generator.GenerateOwnerID()
				}

				errModels := models.ModelsInsertDataItems(item_id, item_name, item_model, item_limitation, item_quantity, item_unit, date_of_entry, str_time_prd, item_expired, item_owner, owner_id, item_location, item_status)
				if errModels != nil {
					log.Println(errModels)
				}
			break
			case "REMOVE":
				log.Println("REMOVE GOBLOG!")
			break
			}
		} else {
			w.Header().Set("Content-Type", "application/json")
			responseMessageSessionTimedOut := struct{
				Message 	bool	`json:"Message"`
			}{
				Message:	true,
			}
			json_message_session_timedout, err := json.Marshal(responseMessageSessionTimedOut)
			if err != nil { log.Println(err) }
			fmt.Fprintf(w, string(json_message_session_timedout))
		}
	}
}

/// Reportr handler
func (this *MainController) AppReports(w http.ResponseWriter, r *http.Request) {
	// start session
	sess := session.Start(w, r)
	
	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session

	if r.Method == "GET" {
		if len(username_session) <= 0 && len(user_fullname_session) <= 0 {
			w.Header().Set("Content-Type", "application/json")
			redirectMessage := struct{
				Message 	bool 	`json:"Message"`
			}{}

			redirectMessage.Message = true
			outgoingJSON, err := json.Marshal(redirectMessage)
			if err != nil { log.Println("[!] ERROR:", err) }
			fmt.Fprint(w, string(outgoingJSON))
		} else {
			ajax_items_filename := "views/ajax/ajax_reports.tpl"
			tpl, err := template.New("").Delims("[[", "]]").ParseFiles(ajax_items_filename)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}

			err = tpl.ExecuteTemplate(w, "reports_layout", nil)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}
		}
	}
}

func (this *MainController) AppUsers(w http.ResponseWriter, r *http.Request) {
	// start session
	sess := session.Start(w, r)

	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session

	if r.Method == "GET" {
		if len(username_session) <= 0 && len(user_fullname_session) <= 0 {
			w.Header().Set("Content-Type", "application/json")
			redirectMessage := struct{
				Message 	bool 	`json:"Message"`
			}{}

			redirectMessage.Message = true
			outgoingJSON, err := json.Marshal(redirectMessage)
			if err != nil { log.Println("[!] ERROR:", err) }
			fmt.Fprint(w, string(outgoingJSON))
		} else {
			ajax_items_filename := "views/ajax/ajax_users.tpl"
			tpl, err := template.New("").Delims("[[", "]]").ParseFiles(ajax_items_filename)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}

			err = tpl.ExecuteTemplate(w, "users_layout", nil)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}
		}
	}
}

// login process handler
// custom login authentication
// checking if username and password is exists (matching)
func (this *MainController) AppLogin(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	// set header as "application/json"
	w.Header().Set("Content-Type", "application/json")

	r.ParseForm()	// parsing form (data input)
	//log.Println(r.Form["username"])
	//log.Println(r.Form["password"])
	username := r.Form["username"][0]
	password := r.Form["password"][0]

	// check username and password in table
	// if exists then return true,
	// else, return false
	user_isExists := models.ModelsReadLogin(username, password) // print true / false
	// print testing
	//log.Println(user_isExists)

	// outgoingJSON for outgoing JSON data that send to web client
	// errJSON error
	var outgoingJSON []byte
	var errJSON error
	// for send JSON data as authentication message
	// this is web service API
	json_login_auth := struct {
		AuthLoginMessage    	bool	`json:"Message"`
		AuthRedirectUrl     	string	`json:"Redirect_Url"`
	}{}

	// authentication
	if user_isExists {
		// get value from user_login table where username=x?
		data_user := models.ModelsSelectFromUserLogin(username)
		//log.Println(data_user[0].User_name) // print user_name (isn't login name but fullname)
		// fullname user
		fullname := data_user[0].User_name

		// create JSON data for web services
		json_login_auth.AuthLoginMessage = true
		json_login_auth.AuthRedirectUrl = "/"
		outgoingJSON, errJSON = json.Marshal(json_login_auth)

		sess.Set("user_name", username)
		sess.Set("user_fullname", fullname)
	} else {
		// create json data for web service
		json_login_auth.AuthLoginMessage = false
		json_login_auth.AuthRedirectUrl = "none"
		outgoingJSON, errJSON = json.Marshal(json_login_auth)
	}

	if errJSON != nil {
		log.Println(errJSON)
	}
	//fmt.Println(string(outgoingJSON))
	fmt.Fprint(w, string(outgoingJSON))	
}

// AppLogout for destroy all user login sessions
// User will logout
func (this *MainController) AppLogout(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	sess := session.Start(w, r)
	sess.Delete("user_name")
	session.Destroy(w, r)
	http.Redirect(w, r, "/", 302)
}