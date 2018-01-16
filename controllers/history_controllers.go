package controllers

import (
	"time"
	"simple_stockapps/generator"
)

func UpdateHistory(history_code, history_by, history_notes) {
	waktu := time.Now()
	// generate history id
	history_id := generator.GenerateID()

	// create history date, now!
	history_date := waktu.Format("2006-01-02 15:04")
}