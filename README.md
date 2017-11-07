# StockApps: Stock of goods management system - Web Based Application

*Note: This is beta version and this still in proccess
StockApps is simple web based application that used for stock of goods management system. Below is several funtion of StockApps:

- Realtime table monitoring:
  Home page will showing table that contains items (Including columns such as Item Name, Item Quantity, Owner, Action (Pick Up or Delete),  etc). The table will realtime monitoring contents and action from user (Adding, picking up, and deleting item). 
- Realtime notification:
  Realtime notification bar will notify all user actions and item alerts (if item has reached the limit). Notification could be used as log for this application.
- Adding (by Administrator) and picking up item / stuff to table list (Realtime Table Monitoring):
  Only user that has Administrator privilege can adding or deleting item. Meanwhile user that has Operator privilege can only picking up items.
  
I've been writing all of these codes for 1 Months for free. You can always use or develop it but don't forget for appreciate me. Just adding my repository to your source code or application info.

# Installation
1. I'm using Golang as Server Side Script. You can download it from https://golang.org/dl/ and  for manual installation https://golang.org
2. Installing Git.
3. Make sure that golang has installed in your server. Create "src" directory (if not exist) in $GOPATH/ and change directory to "$GOPATH/src". Type this command on your cmd or terminal:

  $git clone github.com/anggitmg/stockapps #for clone the repo
  
4. This application using some of package/library/extention such as:
  - github.com/urfave/negroni (HTTP Middleware)
  - github.com/gorilla/mux (HTTP Router)
  - github.com/kataras/go-sessions (HTTP Sessions)
  - github.com/jmoiron/sqlx (SQL Extentions)
  - github.com/go-sql-driver (MySQL Driver for golang)
5. If all packages and application has installed you should change directory to stockapps and you can run it using:
  
  $go run main.go
  
  I hope you enjoy my application... have a nice day :)

  Regards,
  Anggit Muhamad Ginanjar
  *You can email me to anggitmg.tkjb@gmail.com, amg.bisnis.tkjb@gmail.com, or anggitmg.tkjb@merahputih.id
