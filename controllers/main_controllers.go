// Controller package for Main Controller object
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
package controllers

import (
	"fmt"
	"log"
	"time"
	//"reflect"
	"net/http"
	"encoding/json"
	"html/template"
	"simple_stockapps/models"

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
	footer_tpl_filename = "views/footer.tpl"
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
		HtmlTableValueFromItems		[]models.Items_Columns
		HtmlUserIsLoggedIn			bool
		HtmlUserFullName			string
	}{}

	html_data.HtmlTitle = "Simple StockApps"
	html_data.HtmlTableValueFromItems = models.ModelsSelectFromItems()

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
	tpl, err := template.New("").Funcs(funcMap).Delims("[[", "]]").ParseFiles(tpl_filename, nav_tpl_filename, footer_tpl_filename)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
	// execute template with the given value from html_data struct 
	err = tpl.ExecuteTemplate(w, "main_layout", html_data)
	if err != nil {
		log.Println("[!] ERROR:", err)
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
	tpl, err := template.New("").Delims("[[", "]]").ParseFiles(tpl_filename, nav_tpl_filename, footer_tpl_filename)
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
		// print the request
		//log.Println(r.Form)
		form_request := r.Form["form_request"][0]

		switch(form_request) {
		case "ADD":
			// Add items request
			// handling the values and inserting it to database
			item_name := r.Form["item_name"][0]
			item_model := r.Form["item_model"][0]
			item_quantity := r.Form["item_quantity"][0]
			item_limitation := r.Form["item_limitation"][0]
			item_unit := r.Form["item_unit"][0]
			date_of_entry := r.Form["date_of_entry"][0]
			time_period := r.Form["time_period"][0]
			typeof_time_period := r.Form["typeof_time_period"][0]
			item_owner := r.Form["item_owner"][0]

			log.Println(item_name, item_model, item_quantity, item_limitation, item_unit, date_of_entry, time_period, typeof_time_period, item_owner)
		break
		case "REMOVE":
			log.Println("REMOVE GOBLOG!")
		break
		case "REQUEST":
			log.Println("REQUEST GOBLOG!")
		break
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