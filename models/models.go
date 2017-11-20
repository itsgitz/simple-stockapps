// Main Models Package
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
// used for database handling, transaction, or CRUD (Create, Read, Update, Delete)

package models

import (
	"log"
	"github.com/jmoiron/sqlx"
	_ "github.com/go-sql-driver/mysql"
)

type Items_Columns struct{
	Item_id				string
	Item_name			string
	Item_model			string
	Item_limitation		int
	Item_quantity		int
	Item_unit 			string
	Date_of_entry		string
	Item_time_period	string
	Item_expired		string
	Item_owner			string
	Item_status			string
}

var db *sqlx.DB
var err error

// initialization connection to database using init() function
// will run first when the program start to running
func init() {
	db, err = sqlx.Connect("mysql", "dc:IniP4ssword@tcp(127.0.0.1:3306)/stockapps")
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
}

// ModelsReadLogin function used for checking user login name in database table
// username and password used as parameter
// it will return true if user is exists
// else, return false
func ModelsReadLogin(username, password string) bool {
	var isExists bool	// boolean

	// query to database for checking username
	rows, err := db.Query("SELECT exists (SELECT user_login_name, password FROM user_login WHERE user_login_name=? AND password=?)", 
		username, 
		password,
	)
	for rows.Next() {
		rows.Scan(&isExists)
	}
	defer rows.Close()

	if err != nil {
		log.Println(err)
	}

	// return the boolean value
	return isExists
}

// ModelsSelectFromItems function used for display the table of database content
// the function will return all values in `items` table
func ModelsSelectFromItems() []Items_Columns {
	items_value := []Items_Columns{}

	err = db.Select(&items_value, "SELECT * FROM items")
	if err != nil {
		log.Println("[!] ERROR: ModelsSelectFromItems:", err)
	}

	return items_value
}