package main

import (
	"fmt"
	"log"
	"github.com/jmoiron/sqlx"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	var db *sqlx.DB
	var err error

	db, err = sqlx.Connect("mysql", "dc:P4sswordDC@tcp(127.0.0.1:3306)/stockapps")

	if err != nil {
		log.Println("MySQL Error:", err)
	}

	rows, _ := db.Query("SELECT FROM user_id, user_name user_login")

	for rows.Next() {
		var user_id, user_name string
		err = rows.Scan(&user_id, user_name)
		fmt.Println(user_id, user_name)
		if err != nil {
			log.Println("MySQL Error:", err)
		}
	}

	if err != nil {
		log.Println("MySQL Error:", err)
	}
}