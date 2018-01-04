//////////////////////////////////////////////////////////////////////////////////
// Web Socket Controller
package controllers
import (
	"log"
	"time"
	"net/http"
	"github.com/gorilla/websocket"
)

// Hub Websocket
// a.k.a Hub Channels
type Hub struct {
	Clients map[*Client]bool
	Broadcast chan string
	Register chan *Client
	Unregister chan *Client
	Content string

}

// Client Channels
type Client struct {
	ws *websocket.Conn
	send chan []byte
}

const (
	write_wait = 10 * time.Second
	pong_wait = 60 * time.Second
	ping_period = (pong_wait * 9) / 10
	max_message_size = 1024 * 1024
)

// Register and Unregister connected client would be here
// also broadcasting message
var h = Hub {
	Broadcast: make(chan string),
	Register: make(chan *Client),
	Unregister: make(chan *Client),
	Clients: make(map[*Client]bool),
	Content: "",
}

// upgrade HTTP to websocket
var upgrader = &websocket.Upgrader{
	ReadBufferSize: max_message_size,
	WriteBufferSize: max_message_size,
	EnableCompression: true,
	CheckOrigin: func (r *http.Request) bool { return true },
}

// Run channel concurrency,
// Register, Unregister, and Broadcast
func (h *Hub) Run() {
	for {
		select {
		case c:= <-h.Register:
			h.Clients[c] = true
			c.send <- []byte(h.Content)
			break
		case c:= <-h.Unregister:
			_, ok := h.Clients[c]
			if ok {
				delete(h.Clients, c)
				close(c.send)
			}
			break
		case m:= <-h.Broadcast:
			h.Content = m
			h.BroadcastMessage()
			break
		}
	}
}

// I wrote this function, so that could be run in main package as goroutine
func (this *MainController) RunningWebSocketController() {
	h.Run()
}

// Broadcasting message function to all connected client
func (h *Hub) BroadcastMessage() {
	for c := range h.Clients{
		select {
		case c.send <- []byte(h.Content):
			break
		default:
			close(c.send)
			delete(h.Clients, c)
		}
	}
}

// WebSocket Handler
func (this *MainController) AppWebSocket(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		log.Println(err)
		return
	}

	c := &Client{
		send: make(chan []byte, max_message_size),
		ws: ws,
	}
	h.Register <- c
	go c.WritePump()
	c.ReadPump()
}

func (c *Client) ReadPump() {
	defer func() {
		h.Unregister <- c
		c.ws.Close()
	}()

	c.ws.SetReadLimit(max_message_size)
	c.ws.SetReadDeadline(time.Now().Add(pong_wait))
	c.ws.SetPongHandler(func(string) error {
		c.ws.SetReadDeadline(time.Now().Add(pong_wait))
		return nil
	})
	for {
		_, message, err := c.ws.ReadMessage()
		if err != nil {
			break
		}
		log.Println(string(message))
		h.Broadcast <- string(message)
	}
}

func (c *Client) WritePump() {
	ticker := time.NewTicker(ping_period)
	defer func() {
		ticker.Stop()
		c.ws.Close()
	}()

	for {
		select {
		case message, ok := <-c.send:
			if !ok {
				c.write(websocket.CloseMessage, []byte{})
				return
			}
			if err := c.write(websocket.TextMessage, message); err != nil {
				return
			}
		case <-ticker.C:
			if err := c.write(websocket.PingMessage, []byte{}); err != nil {
				return
			}
		}
	}
}

func (c *Client) write(message_type int, message []byte) error {
	c.ws.SetWriteDeadline(time.Now().Add(write_wait))
	return c.ws.WriteMessage(message_type, message)
}

// end of Web Socket
//////////////////////////////////////////////////////////////////////////////////