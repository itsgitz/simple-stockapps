// WebSocket Server
// I write this code for broadcasting message to all connected client, so that
// My application could realtime recording all activity that users does, such as
// Picking Up Item, Adding, Removing or Editing data items. Simple Stockapps will realtime refresh all modification
// data on webpage monitoring, it method using WebSocket.
// I love Golang WebSocket :)
// websocket.go:
// by: Anggit Muhamad Ginanjar
//   : STM Negeri Pembangunan Bandung
package main

import (
	"log"
	"net/http"
	"github.com/gorilla/websocket"
)
//////////////////////////////////////////////////////////////////////////////////
// Web Socket
/// Ugrader websocket...
/// WebSocket connection is establish if we ugrade connection to websocket
var upgrader = websocket.Upgrader{
	CheckOrigin: func (r *http.Request) bool { return true },	// origin
	ReadBufferSize:		1024,
	WriteBufferSize:	1024,
	EnableCompression: true,
}
// Message struct datatype that we have to broadcast to all connected client
type Message struct {
	Pesan	string 	`json:"Pesan"`
	Kode	string  `json:"Kode"`
}

// client and broadcasr channel
var clients = make(map[*websocket.Conn]bool)
var broadcast = make(chan Message)

func main() {
	// handling message as concurrency
	go HandleMessage()

	// websocket mux router
	http.HandleFunc("/ws", AppWebSocket)
	log.Println("[*] Open WebSocket Server on port :8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Println(err)
	}
}

// AppWebSocket function handling incoming message and request using websocket connection
func AppWebSocket(w http.ResponseWriter, r *http.Request) {
	// we want to using websocket communication, not http
	// so upgrade connection to WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
	defer conn.Close()

	// Register new connected client
	clients[conn] = true
	
	for {
		var msg Message
		// Read JSON Messages
		err := conn.ReadJSON(&msg)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			delete(clients, conn)
			break
		}
		log.Println(msg.Pesan, msg.Kode)
		// send message broadcast
		broadcast <- msg
	}
}
// handle incoming message
func HandleMessage() {
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