package main

import (
	"fmt"
	"time"
	"log"
	"github.com/jmoiron/sqlx"
	_ "github.com/go-sql-driver/mysql"
)

var db *sqlx.DB
var err error

func init() {
	db, err = sqlx.Connect("mysql", "dc:IniP4ssword@tcp(127.0.0.1:3306)/stockapps")
	if err != nil {
		log.Println(err)
	}
}

func main() {
	/* Date time */
	now := time.Now()
	timeToAdd := time.Hour * 24 * (5 - 1)
	justAddIt := now.Add(timeToAdd)
	fmt.Println(now.Format("2006-01-02"))
	fmt.Println(justAddIt.Format("2006-01-02"))

	id := fmt.Sprintf("%d", now.Nanosecond())

	sql_query := "INSERT INTO table_test (Id, Name, Class) VALUES (?, ?, ?)"
	rows, err := db.Queryx(sql_query, id, "Anggit MG", "12 TKJB")

	if err != nil {
		log.Println(err)
	}

	defer rows.Close()
}