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
)

type MainController struct {
}

var (
	session = sessions.New(sessions.Config{
		Cookie: "simple_stockapps_session",
		Expires: time.Hour * 2,
		DisableSubdomainPersistence: false,
	})
)


// Main page controller
func (this *MainController) AppMainPage(w http.ResponseWriter, r *http.Request) {
	sess := session.Start(w, r)
	// get the sessions
	username_session := sess.GetString("user_name")	// get username session
	fmt.Println("Session:", username_session)

	html_data := struct{
		HtmlTitle             	string
		HtmlSignButton        	string
		HtmlTableHeaderAction 	template.HTML
		HtmlTableValueFromItems	[]models.Items_Columns
	}{}

	html_data.HtmlTitle = "Simple StockApps"
	html_data.HtmlTableValueFromItems = models.ModelsSelectFromItems()

	//items := models.ModelsSelectFromItems()
	//log.Println(items[0].Item_name)
	//log.Println(reflect.TypeOf(items))

	if len(username_session) != 0 {
		html_data.HtmlSignButton = "Logout"
		html_data.HtmlTableHeaderAction = template.HTML(`<th>Action</th>`)
	} else {
		html_data.HtmlSignButton = "Login"
	}

	tpl_filename := "views/main.tpl"
	tpl, err := template.New("").Delims("[[", "]]").ParseFiles(tpl_filename)
	if err != nil {
		log.Println("[!] ERROR:", err)
	}

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
	log.Println(r.Form["username"])
	log.Println(r.Form["password"])
	username := r.Form["username"][0]
	password := r.Form["password"][0]

	// check username and password in table
	// if exists then return true,
	// else, return false
	user_isExists := models.ModelsReadLogin(username, password) // print true / false
	// print testing
	log.Println(user_isExists)

	// outgoingJSON for outgoing JSON data that send to web client
	// errJSON error
	var outgoingJSON []byte
	var errJSON error
	// for send JSON data as authentication message
	json_login_auth := struct {
		AuthLoginMessage    bool	`json:"Message"`
		AuthRedirectUrl     string	`json:"Redirect_Url"`
	}{}

	// authentication
	if user_isExists {
		json_login_auth.AuthLoginMessage = true
		json_login_auth.AuthRedirectUrl = "/"
		outgoingJSON, errJSON = json.Marshal(json_login_auth)
		sess.Set("user_name", username)
	} else {
		json_login_auth.AuthLoginMessage = false
		json_login_auth.AuthRedirectUrl = ""
		outgoingJSON, errJSON = json.Marshal(json_login_auth)
	}

	if errJSON != nil {
		log.Println(errJSON)
	}
	fmt.Println(string(outgoingJSON))
	fmt.Fprint(w, string(outgoingJSON))	
}

// AppLogout for destroy all sessions
// User will logout
func (this *MainController) AppLogout(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	sess := session.Start(w, r)
	sess.Delete("user_name")
	session.Destroy(w, r)
	http.Redirect(w, r, "/", 302)
}