package main

import (
	"log"
	"time"
	"simple_stockapps/models"
)

func  main() {
	ch := make(chan int, 1)

	log.Println("[*] Part of push notification server by AQX")
	log.Println("[*] Realtime counting number of rows from table in database")

	for {
		go func() {
			num_of_rows := models.ModelsPrintItemsTableRows()
			time.Sleep(time.Second * 3)
			ch <- num_of_rows
		}()

		select {
		case res := <-ch:
			log.Println("[i] Number of rows (currently):", res)
		case <-time.After(time.Second * 1):
			log.Println("[!] Just timeout, wait a second ...")
		}
	}
}