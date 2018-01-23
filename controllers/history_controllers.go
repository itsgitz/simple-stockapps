package controllers

import (
	"log"
	"time"
	"fmt"
	"encoding/json"
	"net/http"
	"strconv"
	"simple_stockapps/generator"
	"simple_stockapps/models"
)

func UpdateHistory(history_code, history_by, history_notes, item_unit, item_quantity, item_name, item_id string) {
	waktu := time.Now()
	// generate history id
	history_id := generator.GenerateID()

	// create history date, now!
	history_date := waktu.Format("2006-01-02 15:04")

	// create history content accroding to history code
	var history_content string
	var item_unit_str string // i put this variable just want to make sure that if quantity more than 1, it will concantinating "s" char

	// convert to integer
	item_quantity_int, _ := strconv.Atoi(item_quantity)
	if item_quantity_int > 1 {
		item_unit_str = item_unit + "s"
	} else {
		item_unit_str = item_unit
	}

	// from JavaScript
	/*
	const pickupRequest = "#001-pick-up";
	const editRequest = "#002-edit-item";
	const addRequest = "#003-add-item";
	const removeRequest = "#004-remove-item";
	const updateRequest = "#005-update-item";
	*/

	switch(history_code) {
	case "#001-pick-up":
		// example:
		// Anggit Muhamad Ginanjar has picked up 2 cable roll of Cat-6 UTP Cable
		history_content = history_by + " has picked up " + item_quantity + " " + item_unit_str + " of " + item_name + " ID: " + item_id
		break
	case "#002-edit-item":
		history_content = history_by + " has edited item, item name: " + item_name + " ID: " + item_id
		break
	case "#003-add-item":
		history_content = history_by + " has added item, item name: " + item_name + " ID: " + item_id
		break
	case "#004-remove-item":
		history_content = history_by + " has removed item, item name: " + item_name + " ID: " + item_id
	case "#005-update-item":
		history_content = history_by + " has updated item, item name: " + item_name + " ID: " + item_id
		break
	}

	// inserting history into database
	err := models.ModelsUpdateHistory(history_id, history_date, history_code, history_by, history_content, history_notes)
	// as always i use this error handler
	if err != nil {
		log.Println(err)
	}
}

// history table in database
type History struct{
	History_id       string	`json:"history_id"`
	History_date     string `json:"history_date"`
	History_code     string `json:"history_code"`
	History_by       string `json:"history_by"`
	History_content  string `json:"history_content"`
	History_notes    string `json:"history_notes"`
}

// get history 
func (this *MainController) AppJSONGetSideNotificaton(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	values, err := models.ModelsGetHistory()
	if err != nil {
		errMsg := "[!] ERROR: in ModelsGetHistory, Database Server: " + err.Error() + " Please contact the Administrator: anggit.ginanjar@lintasarta.co.id a.k.a AQX Tamvan :)"
		http.Error(w, errMsg, http.StatusInternalServerError)
	}

	allValues := make([]History, len(values))

	for i:=0; i<len(values); i++ {
		allValues[i].History_id = values[i].History_id
		allValues[i].History_date = values[i].History_date
		allValues[i].History_code = values[i].History_code
		allValues[i].History_by = values[i].History_by
		allValues[i].History_content = values[i].History_content
		allValues[i].History_notes = values[i].History_notes
	}
	outgoingJSON, err := json.Marshal(allValues)
	if err != nil {
		log.Println(err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	fmt.Fprintf(w, string(outgoingJSON))
}