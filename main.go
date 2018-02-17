// Main package ...
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
package main

import (
	"log"	// log	package
	"time"	// time package
	"net/http"	// http for http server handling
	"github.com/urfave/negroni"	// negroni HTTP Middleware
	"github.com/gorilla/mux"	// gorilla router handler
	"simple_stockapps/controllers"	// custom controllers
)


// main function
func main() {
	// router variable initialiation using mux gorilla package
	router := mux.NewRouter()
	// defining main controller object
	main_ctrl := new(controllers.MainController)

	// defining router handler function
	router.HandleFunc("/", main_ctrl.AppMainPage) // routing for "/" (root) handler
	router.HandleFunc("/login", main_ctrl.AppLogin) // routing for "/login" handler
	router.HandleFunc("/logout", main_ctrl.AppLogout) // routing for "/logout" handler

	// ajax handler routers
	router.HandleFunc("/navbar", main_ctrl.AppNavbarMainPage)

	// ajax sub-url routers
	router.HandleFunc("/items", main_ctrl.AppItems)
	router.HandleFunc("/reports", main_ctrl.AppReports)
	router.HandleFunc("/users", main_ctrl.AppUsers)

	// JSON
	router.HandleFunc("/json_get_items", main_ctrl.AppJSONOurItemsData)
	router.HandleFunc("/json_get_all_items", main_ctrl.AppJSONGetAllItems)
	router.HandleFunc("/json_get_other_items", main_ctrl.AppJSONGetOtherItems)
	router.HandleFunc("/json_search_items", main_ctrl.AppJSONSearchData)
	router.HandleFunc("/json_get_empty_items", main_ctrl.AppJSONGetEmptyItems)
	router.HandleFunc("/json_get_side_notification", main_ctrl.AppJSONGetSideNotificaton)
	// remove item url
	router.HandleFunc("/json_remove_item", main_ctrl.AppJSONRemoveItem)
	// update item url
	router.HandleFunc("/json_update_item", main_ctrl.AppJSONUpdateItem)
	// Pickup item url
	router.HandleFunc("/json_pickup_item", main_ctrl.AppPickupItem)

	// add user url
	router.HandleFunc("/add_user", main_ctrl.AppAddUser)
	router.HandleFunc("/json_new_users", main_ctrl.AppJSONGetNewUsers)
	router.HandleFunc("/json_reg_users", main_ctrl.AppJSONGetRegUsers)
	router.HandleFunc("/remove_user", main_ctrl.AppRemoveUser)

	// defining http middleware using negroni method
	middleware := negroni.Classic()
	middleware.Use(negroni.NewStatic(http.Dir("static"))) // initialization static file
	middleware.UseHandler(router) // using gorilla mux router inside negroni middleware

	// initialization http server
	HttpServer := &http.Server{
		Addr:			":80", // http port that used by web server
		Handler:		middleware, // using handler as http middleware
		ReadTimeout:	time.Second * 10,
		WriteTimeout:	time.Second * 10,
	}

	// log will tell web server has already opening on port :8080
	log.Println("[*] Web server is running on port :80")
	HttpError := HttpServer.ListenAndServe()

	// catch the error log if any error outhere
	if HttpError != nil {
		log.Println("HttpError:", HttpError)
	}
}