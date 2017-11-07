package controllers

import (
	"log"
	"net/http"
	"html/template"
)

type MainController struct {}

func (this MainController) AppMainPage(w http.ResponseWriter, r *http.Request) {
	tpl, err := template.New("").Delims("[[", "]]").ParseFiles("views/main.tpl")
	if err != nil {
		log.Println(err)
	}
	err = tpl.ExecuteTemplate(w, "main_layout", nil)
	if err != nil {
		log.Println(err)
	}
}