package main

import (
	"log"
	"time"
	"net/http"
	"github.com/urfave/negroni"
	"github.com/gorilla/mux"
	"_apps_/controllers"
)

func main() {
	router := mux.NewRouter()
	main_ctrl := new(controllers.MainController)
	router.HandleFunc("/", main_ctrl.AppMainPage)
	middleware := negroni.Classic()
	middleware.Use(negroni.NewStatic(http.Dir("static")))
	middleware.UseHandler(router)

	HttpServer := &http.Server{
		Addr:			":8080",
		Handler:		middleware,
		ReadTimeout:	time.Second * 10,
		WriteTimeout:	time.Second * 10,
	}
	log.Println("[*] Web server is running on port :8080")
	HttpError := HttpServer.ListenAndServe()

	if HttpError != nil {
		log.Println("HttpError:", HttpError)
	}
}