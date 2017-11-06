// testing 

package main

import (
	"fmt"
	"log"
	"github.com/jmoiron/sqlx"
	_ "github.com/go-sql-driver/mysql"
)

// user login struct for fetching all data from table
// it'll using to fetch data from as array struct
type user_login struct {
	User_id		string
	User_name	string
}

func main() {
	var db *sqlx.DB
	var err error

	db, err = sqlx.Connect("mysql", "dc:IniP4ssword@tcp(127.0.0.1:3306)/stockapps")

	if err != nil {
		log.Println("MySQL Error:", err)
	}

	// single value with Queryx method
	rows, _ := db.Queryx("SELECT user_id, user_name FROM user_login")

	for rows.Next() {
		var user_id string
		var user_name string

		err = rows.Scan(&user_id, &user_name)
		fmt.Println(user_id, user_name)	// print:	001 Administrator \n 002 Anggit Muhamad Ginanjar
		if err != nil {
			log.Println("MySQL Error:", err)
		}
	}

	// multiple value within array struct using Get() method
	// create array struct variable, the struct is reference from user_login struct
	users := []user_login{}
	// usgin Select() method for fetching all data in table as array struct
	err = db.Select(&users, "SELECT user_id, user_name FROM user_login")
	fmt.Println(users)					// print: [{001 Administrator}, {002, Anggit Muhamad Ginanjar}]
	fmt.Println(users[1].User_name)		// print: Anggit Muhamad Ginanjar

	if err != nil {
		log.Println(err)
	}
}