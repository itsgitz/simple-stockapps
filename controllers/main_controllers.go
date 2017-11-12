// Controller package for Main Controller object
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
package controllers

import (
	"log"
	"net/http"
	"html/template"
	"simple_stockapps/models"
)

type MainController struct {
	AuthLoginMessage	string	`json:""`
}

// Main page controller
func (this MainController) AppMainPage(w http.ResponseWriter, r *http.Request) {
	html_data := struct{
		Title string
	}{
		Title: "Simple StockApps",
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
func (this MainController) AppLogin(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()	// parsing form (data input)
	log.Println(r.Form["username"])
	log.Println(r.Form["password"])
	username := r.Form["username"][0]
	password := r.Form["password"][0]

	// check username and password in table
	// if exists then return true,
	// else, return false
	user_isExists := models.ModelsReadLogin(username, password) // print true / false
	log.Println(user_isExists)
}