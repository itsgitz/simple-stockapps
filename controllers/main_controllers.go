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

// Main page controller
func (this *MainController) AppMainPage(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	// get the sessions
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session
	privilege := sess.GetString("user_privilege") // get user privilege
	//log.Println("Session:", username_session)
	//log.Println("Session:", user_fullname_session)

	// html template data
	html_data := struct{
		HtmlTitle             	string
		HtmlUserIsLoggedIn		bool
		HtmlUserIsAdmin     bool // check for privilege
		HtmlUserFullName		string
		HtmlScriptVersion       string
	}{}

	html_data.HtmlTitle = "Simple StockApps"

	// css and javascript versioning
	html_data.HtmlScriptVersion = generator.GenerateID()
	log.Println("Script: ", html_data.HtmlScriptVersion)

	// if username session is not null or user has already logged in into system
	if len(username_session) != 0 {
		html_data.HtmlUserIsLoggedIn = true
		html_data.HtmlUserFullName = user_fullname_session
		if privilege == "Administrator" {
			html_data.HtmlUserIsAdmin = true
		} else {
			html_data.HtmlUserIsAdmin = false
		}
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
	Added_by			string  `json:"added_by"`
	Redirect 			bool    `json:"redirect"`
}

// only lintasarta's items will be showed
func (this *MainController) AppJSONOurItemsData(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	values, err := models.ModelsSelectFromOurItems()

	if err != nil {
		errMsg := "[!] ERROR: in ModelsSelectFromOurItems, Database Server: " + err.Error() + " Please contact the Administrator: anggit.ginanjar@lintasarta.co.id a.k.a AQX Tamvan :)"
		http.Error(w, errMsg, http.StatusInternalServerError)

	}

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
		x[i].Added_by = values[i].Added_by
	}

	outgoingJSON, err := json.Marshal(x)
	if err != nil {
		log.Println(err)
	}
	fmt.Fprintf(w, string(outgoingJSON))
}

// showing all items
func (this *MainController) AppJSONGetAllItems(w http.ResponseWriter, r *http.Request) {
	// session start
	sess := session.Start(w, r)
	privilege := sess.GetString("user_privilege")

	w.Header().Set("Content-Type", "application/json")
	values, err := models.ModelsSelectAllItems(privilege)

	if err != nil {
		errMsg := "[!] ERROR: in ModelsSelectAllItems(), Database Server: " + err.Error() + " Please contact the Administrator: anggit.ginanjar@lintasarta.co.id a.k.a AQX Tamvan :)"
		http.Error(w, errMsg, http.StatusInternalServerError)
	}

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
		x[i].Added_by = values[i].Added_by
	}

	outgoingJSON, err := json.Marshal(x)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	fmt.Fprintf(w, string(outgoingJSON))
}

// get other items means except lintasarta's items
func (this *MainController) AppJSONGetOtherItems(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	values, err := models.ModelsSelectOtherItems()
	if err != nil {
		errMsg := "[!] ERROR: in ModelsSelectOtherItems(), Database Server: " + err.Error() + " Please contact the Administrator: anggit.ginanjar@lintasarta.co.id a.k.a AQX Tamvan :)"
		http.Error(w, errMsg, http.StatusInternalServerError)
	}

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
		x[i].Added_by = values[i].Added_by
	}

	outgoingJSON, err := json.Marshal(x)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	fmt.Fprintf(w, string(outgoingJSON))
}

// get empty items from table
func (this *MainController) AppJSONGetEmptyItems(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	values, err := models.ModelsSelectEmptyItems()
	if err != nil {
		errMsg := "[!] ERROR: in ModelsSelectEmptyItems(), Database Server: " + err.Error() + " Please contact the Administrator: anggit.ginanjar@lintasarta.co.id a.k.a AQX Tamvan :)"
		http.Error(w, errMsg, http.StatusInternalServerError)
	}

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
		x[i].Added_by = values[i].Added_by
	}

	outgoingJSON, err := json.Marshal(x)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	fmt.Fprintf(w, string(outgoingJSON))
}

// Searching item in database then create JSON datatype from item_results
func (this *MainController) AppJSONSearchData(w http.ResponseWriter, r *http.Request) {
	// get session
	sess := session.Start(w, r)
	username_session := sess.GetString("user_name")

	r.ParseForm()
	if r.Method == "POST" {
		var item_to_json []Items
		// check if user session not terminate
		// if user has terminate their session, send json messagea redirect
		if len(username_session) > 0 {
			w.Header().Set("Content-Type", "application/json")
			search := r.Form["search_value"][0]
			category := r.Form["category"][0]

			// search items from models
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
					item_to_json[i].Added_by = item_results[i].Added_by
				}
			} else if len(item_results) == 0 {
				item_to_json[0].Item_name = "Not found"
			}
		} else if len(username_session) == 0 {
			http.Error(w, "Session has timed out :(", http.StatusBadRequest)
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
		HtmlUserIsAdmin     bool // check for privilege
		HtmlScriptVersion   string
	}{}

	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session
	privilege := sess.GetString("user_privilege") // get user privilege (Administrator/Operator)

	// if username session is not null or user has already logged in into system
	if len(username_session) != 0 {
		html_data.HtmlUserIsLoggedIn = true
		html_data.HtmlUserFullName = user_fullname_session
		if privilege == "Administrator" {
			html_data.HtmlUserIsAdmin = true
		} else {
			html_data.HtmlUserIsAdmin = false
		}
	} else {
		html_data.HtmlUserIsLoggedIn = false
		http.Redirect(w, r, "/", 302)
	}

	html_data.HtmlScriptVersion = generator.GenerateID()

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
			// print user fullname
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

				// inserting all of data
				errModels := models.ModelsInsertDataItems(item_id, item_name, item_model, item_limitation, item_quantity, item_unit, date_of_entry, str_time_prd, item_expired, item_owner, owner_id, item_location, item_status, user_fullname_session)
				if errModels != nil {
					log.Println(errModels)
				}
				//log.Println(item_id, item_name, item_model, item_limitation, item_quantity, item_unit, date_of_entry, str_time_prd, item_expired, item_owner, owner_id, item_location, item_status, user_fullname_session)
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

// pickup item function
func (this *MainController) AppPickupItem(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	// start session
	sess := session.Start(w, r)

	// get session
	username_session := sess.GetString("user_name")	// get username session
	user_fullname_session := sess.GetString("user_fullname") // get username full session

	// GET method
	if r.Method == "GET" {
		http.Error(w, "NOT FOUND :(", http.StatusNotFound)
	} else if r.Method == "POST" {
		if len(username_session) > 0 && len(user_fullname_session) > 0 {
			var item_status string;
			item_id := r.Form["item_id"][0]
			item_quantity_picked := r.Form["item_quantity_picked"][0]
			item_howmuch := r.Form["item_howmuch"][0]
			item_limitation := r.Form["item_limitation"][0]
			item_name := r.Form["item_name"][0]
			item_unit := r.Form["item_unit"][0] // item unit
			itsRequest := r.Form["request"][0] // websocket code
			itsNotes := r.Form["notes"][0] // websocket notes

			// convert it to integer
			item_quantity_picked_int, _ := strconv.Atoi(item_quantity_picked)
			item_limitation_int, _ := strconv.Atoi(item_limitation)

			// determine item status
			// if item quantity that has picked up by user more than item limitation, then
			// item_status is "Available"
			if item_quantity_picked_int > item_limitation_int {
				item_status = "Available"
			// else if item qty that has picked up by user is equal with limitation, then
			// item_status is "Limited"
			} else if item_quantity_picked_int == item_limitation_int || item_quantity_picked_int < item_limitation_int {
				item_status = "Limited"
			// else if item qty that has picked up by user is less than limitation, then
			// item_status is "Not Available"
			} 

			if item_quantity_picked_int == 0 {
				item_status = "Not Available"
			}

			// pickup / update table
			// UpdateHistory(history_code, history_by, history_notes, item_unit, item_quantity, item_name string)
			// note: history_code = itsRequest variable
			//       history_by = user_fullname_session
			//       history_notes = itsNotes
			UpdateHistory(itsRequest, user_fullname_session, itsNotes, item_unit, item_howmuch, item_name, item_id)
			errPickup := models.ModelsPickupItem(item_id, item_quantity_picked, item_status)
			if errPickup != nil {
				http.Error(w, errPickup.Error(), http.StatusInternalServerError)
			} else {
				w.Header().Set("Content-Type", "application/json")
				dataJson := struct{
					Redirect  bool  `json:"Redirect"`
					Message   string  `json:"Message"`
				}{
					Redirect: true,
					Message: "Successful Picking Up item!",
				}
				sendJson, err := json.Marshal(dataJson)
				if err != nil {
					log.Println(err)
				}
				fmt.Fprintf(w, string(sendJson))
			}
		} else {
			w.Header().Set("Content-Type", "application/json")
			responseMessageSessionTimedOut := struct{
				Message 	bool	`json:"Message_Timeout"`
			}{
				Message:	true,
			}
			json_message_session_timedout, err := json.Marshal(responseMessageSessionTimedOut)
			if err != nil { log.Println(err) }
			fmt.Fprintf(w, string(json_message_session_timedout))
		}
	}
}

// update data item
func (this *MainController) AppJSONUpdateItem(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	if r.Method == "GET" {
		http.Error(w, "NOT FOUND :(", http.StatusNotFound)
	} else if r.Method == "POST" {
		// get all data
		item_id := r.Form["item_id"][0]
		item_name := r.Form["item_name"][0]
		item_model := r.Form["item_model"][0]
		item_quantity := r.Form["item_quantity"][0]
		item_limitation := r.Form["item_limitation"][0]
		item_unit := r.Form["item_unit"][0]
		time_period := r.Form["time_period"][0]
		type_period := r.Form["type_period"][0]
		item_owner := r.Form["item_owner"][0]
		item_location := r.Form["item_location"][0]
		date_of_entry := r.Form["date_of_entry"][0]

		//log.Println(item_id, item_name, item_model, item_quantity, item_limitation, item_unit, time_period, type_period, item_owner, item_location)
		// convert to integer datatype
		item_quantity_int, _ := strconv.Atoi(item_quantity)
		item_limitation_int, _ := strconv.Atoi(item_limitation)
		var item_status string
		var number_of_days int
		var str_time_prd string
		var item_expired string

		// determine item status according to item quantity and item limitation comparison
		if item_quantity_int > item_limitation_int {
			item_status = "Available"
		} else {
			item_status = "Limited"
		}

		// select days according to type of time period
		number_of_days, _ = strconv.Atoi(time_period)

		if time_period == "0" && type_period == "0" {
			str_time_prd = "None"
			item_expired = "0000-00-00 00:00:00"
		// else, it will create item_expired
		} else {
			switch(type_period) {
			case "Day(s)": number_of_days = number_of_days
			break
			case "Week(s)": number_of_days = number_of_days * 7
			break
			case "Month(s)": number_of_days = number_of_days * 30
			break
			}

			// Create date time expired .......
			// time now initial
			dateSplitSpace := generator.GenerateDateSplit(date_of_entry)
			tahun, bulan, tanggal := generator.GenerateDateSplitByDash(dateSplitSpace)

			date_entry := time.Date(tahun, time.Month(bulan), tanggal, 0, 0, 0, 0, time.UTC)
			time_duration := time.Duration(number_of_days)	// convert integer to time.Duration datatype
			time_to_add := time.Hour * 24 * (time_duration) // add time to create date expired / determine range of days
			adding_time := date_entry.Add(time_to_add)
			// split string, thus we could only put one value (time)
			time_split := generator.GenerateTimeSplit(date_of_entry)
			item_expired = fmt.Sprintf("%s %s", adding_time.Format("2006-01-02"), time_split)
			str_time_prd = time_period + " " + type_period // Ex: 2 Day(s)
		}

		// update data
		errUpdate := models.ModelsUpdateDataItem(item_id, item_name, item_model, item_quantity, item_limitation, item_unit, str_time_prd, item_expired, item_owner, item_location, item_status)
		if errUpdate != nil {
			http.Error(w, errUpdate.Error(), http.StatusInternalServerError)
		} else {
			w.Header().Set("Content-Type", "application/json")
			dataJson := struct{
				Redirect  bool  `json:"redirect"`
				Message   string  `json:"message"`
			}{
				Redirect: true,
				Message: "Successful updating item!",
			}
			sendJson, err := json.Marshal(dataJson)
			if err != nil {
				log.Println(err)
			}
			fmt.Fprintf(w, string(sendJson))
		}
	}
}

// Remove data from item table in database
func (this *MainController) AppJSONRemoveItem(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	if r.Method == "GET" {
		http.Error(w, "NOT FOUND BRAAY", http.StatusNotFound)
	} else if r.Method == "POST" {
		// get the item_id that will be removed by Administrator
		get_item_id := r.Form["item_id"][0]
		//log.Println(get_item_id) // item_id
		// remove item using ModelsRemoveDataItem()
		err := models.ModelsRemoveDataItem(get_item_id)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		} else {
			w.Header().Set("Content-Type", "application/json")
			dataJson := struct{
				Redirect  bool  `json:"redirect"`
				Message   string  `json:"message"`
			}{
				Redirect: true,
				Message: "Successful removing item!",
			}
			sendJson, err := json.Marshal(dataJson)
			if err != nil {
				log.Println(err)
			}
			fmt.Fprintf(w, string(sendJson))
		}
	} else {
		http.Error(w, "BAD REQUEST COYY", http.StatusBadRequest)
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

// users handling request
func (this *MainController) AppUsers(w http.ResponseWriter, r *http.Request) {
	// start session
	sess := session.Start(w, r)

	html_data := struct{
		HtmlGenerateDefaultPassword   string
		HtmlCurrentDate               string
	}{}

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

			// generate password string when administrator want to add users
			// it will give a random password
			html_data.HtmlGenerateDefaultPassword = "P4ssword" + generator.GenerateID()

			// generate current date and time
			waktu := time.Now()
			html_data.HtmlCurrentDate = fmt.Sprintf(waktu.Format("2006-01-02 15:04:05"))

			tpl, err := template.New("").Delims("[[", "]]").ParseFiles(ajax_items_filename)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}

			err = tpl.ExecuteTemplate(w, "users_layout", html_data)
			if err != nil {
				log.Println("[!] ERROR:", err)
			}
		}
	}
}

// add user function (only administrator)
func (this *MainController) AppAddUser(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	username_session := sess.GetString("user_name")	// get username session

	if len(username_session) == 0 {
		w.Header().Set("Content-Type", "application/json")
		redirectMessage := struct{
			Message  bool  `json:"Message"`
		}{}

		redirectMessage.Message = true
		outgoingJSON, err := json.Marshal(redirectMessage)
		if err != nil {
			log.Println("[!] ERROR:", err)
		}
		fmt.Fprintf(w, string(outgoingJSON))
	} else {
		r.ParseForm()
		user_name := r.Form["user_name"][0]
		user_full_name := r.Form["user_full_name"][0]
		user_password := r.Form["user_password"][0]
		user_email := r.Form["user_email"][0]
		user_role := r.Form["user_role"][0]
		date_created := r.Form["date_created"][0]

		// create user id and user key
		user_id :=  generator.GenerateID()
		status := "New"

		// func ModelsAddUser(user_id, user_name, user_full_name, user_privilege, user_password, user_email, user_key, date_created string) error
		//err := models.ModelsAddUser(user_id, user_name, user_full_name, user_role, user_password, user_email, user_key, date_created)

		err := models.ModelsAddUser(user_id, user_name, user_full_name, user_role, user_password, user_email, date_created, status)

		if err != nil {
			errMsg := "[!] ERROR: Contact Administrator (AQX)"
			http.Error(w, errMsg, http.StatusInternalServerError)
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
		privilege := data_user[0].User_privilege

		// create JSON data for web services
		json_login_auth.AuthLoginMessage = true
		json_login_auth.AuthRedirectUrl = "/"
		outgoingJSON, errJSON = json.Marshal(json_login_auth)

		sess.Set("user_name", username)
		sess.Set("user_fullname", fullname)
		sess.Set("user_privilege", privilege)
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

// user_login table in database
type User_Login struct{
	User_id				string  `json:"user_id"`
	User_login_name 	string  `json:"user_login_name"`
	User_name 			string	`json:"user_name"` // fullname of user
	User_privilege		string  `json:"user_privilege"`
	Password            string  `json:"password"`
	User_email			string  `json:"user_email"`
	Date_created		string  `json:"date_created"`
	Status              string  `json:"status"`
}

// Get / Show all new users
func (this *MainController) AppJSONGetNewUsers(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	username_session := sess.GetString("user_name")

	if len(username_session) == 0 {
		w.Header().Set("Content-Type", "application/json")
		redirectMessage := struct{
			Message  bool  `json:"Message"`
		}{}

		redirectMessage.Message = true
		json_val, err := json.Marshal(redirectMessage)
		if err != nil {
			log.Println("[!] ERROR", err)
		}

		fmt.Fprintf(w, string(json_val))
	} else {
		w.Header().Set("Content-Type", "application/json")
		new_users_result := models.ModelsShowNewUsers()
		x := make([]User_Login, len(new_users_result))

		for i:=0; i<len(new_users_result); i++ {
			x[i].User_id = new_users_result[i].User_id
			x[i].User_login_name = new_users_result[i].User_login_name
			x[i].User_name = new_users_result[i].User_name
			x[i].User_privilege = new_users_result[i].User_privilege
			x[i].Password = new_users_result[i].Password
			x[i].User_email = new_users_result[i].User_email
			x[i].Date_created = new_users_result[i].Date_created
			x[i].Status = new_users_result[i].Status
		}

		json_val, err := json.Marshal(x)
		if err != nil {
			log.Println("[!] ERROR:", err)
		}
		fmt.Fprintf(w, string(json_val))
	}
}