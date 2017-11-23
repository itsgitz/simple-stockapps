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
	tpl, err := template.New("").Funcs(funcMap).Delims("[[", "]]").ParseFiles(tpl_filename)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
	// execute template with the given value from html_data struct 
	err = tpl.ExecuteTemplate(w, "main_layout", html_data)
	if err != nil {
		log.Println("[!] ERROR:", err)
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