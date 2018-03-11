// Main Models Package
// by: Anggit Muhamad Ginanjar
//     STM NEGERI PEMBANGUNAN BANDUNG
// used for database handling, transaction, or CRUD (Create, Read, Update, Delete)

package models

import (
	"fmt"
	"log"
	"github.com/jmoiron/sqlx"
	_ "github.com/go-sql-driver/mysql"
)

//Items table in database
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
	Owner_id			string
	Item_location		string
	Item_status			string
	Added_by			string
}

var db *sqlx.DB
var err error

// initialization connection to database using init() function
// will run first when the program start to running
func init() {
	db, err = sqlx.Connect("mysql", "dc:)1)1P4sswordHello@tcp(127.0.0.1:3306)/stockapps")
	if err != nil {
		log.Println("[!] ERROR:", err)
	}
}

// get and read owner_id
func ModelsReadOwnerID(item_owner string) bool {
	var isExists bool

	x, err := db.Queryx("SELECT exists (SELECT owner_id FROM items WHERE item_owner=?)", item_owner)
	for x.Next() {
		x.Scan(&isExists)
	}
	defer x.Close()

	if err != nil {
		log.Println(err)
	}

	return isExists
}

func ModelsGetOwnerID(item_owner string) string {
	var owner_id string
	ex, err := db.Queryx("SELECT owner_id FROM items WHERE item_owner=? LIMIT 1", item_owner)
	if err != nil {
		log.Println(err)
	}
	defer ex.Close()

	for ex.Next() {
		ex.Scan(&owner_id)
	}

	return owner_id
}

// print number of table rows
func ModelsPrintItemsTableRows() int {
	var number_of_rows int
	x, err := db.Queryx("SELECT COUNT(*) FROM items")
	if err != nil {
		log.Println(err)
	}
	defer x.Close()
	for x.Next() {
		x.Scan(&number_of_rows)
	}
	return number_of_rows
}

// Searching item using this function
func ModelsSearchForItems(search, cat string) []Items_Columns {
	items_value := []Items_Columns{}

	// search by category
	// example
	// SELECT * FROM items WHERE cat LIKE %search%; 
	search = "%"+search+"%"
	query := fmt.Sprintf("SELECT * FROM items WHERE %s LIKE ? ORDER BY date_of_entry DESC", cat)
	err = db.Select(&items_value, query, search)

	return items_value
}

// ModelsSelectFromItems function used for display the table of database content
// the function will return all values in `items` table
func ModelsSelectFromOurItems() ([]Items_Columns, error) {
	items_value := []Items_Columns{}

	search := "'%lintasarta%'"
	query := fmt.Sprintf("SELECT * FROM items WHERE item_owner LIKE %s ORDER BY date_of_entry DESC", search)
	err = db.Select(&items_value, query)
	if err != nil {
		log.Println("[!] ERROR: ModelsSelectFromItems:", err)
	}

	return items_value, err
}

// Get all items data
func ModelsSelectAllItems(privilege string) ([]Items_Columns, error) {
	items_value := []Items_Columns{}

	if privilege == "Administrator" {
		err = db.Select(&items_value, "SELECT * FROM items ORDER BY date_of_entry DESC")
	} else {
		keyword := "'%lintasarta%'"
		query := fmt.Sprintf("SELECT * FROM items WHERE item_owner NOT LIKE %s ORDER BY date_of_entry DESC", keyword)
		err = db.Select(&items_value, query)
	}

	if err != nil {
		log.Println("[!] ERROR: ModelsSelectAllItems:", err)
	}

	return items_value, err
}

// other items means except lintasarta's items
func ModelsSelectOtherItems() ([]Items_Columns, error) {
	items_value := []Items_Columns{}
	search := "'%lintasarta%'"
	query := fmt.Sprintf("SELECT * FROM items WHERE item_owner NOT LIKE %s ORDER BY date_of_entry DESC", search)
	err = db.Select(&items_value, query)
	if err != nil {
		log.Println("[!] ERROR: ModelsSelectOtherItems:", err)
	}
	return items_value, err
}

// get empty items or item that has quantity 0
func ModelsSelectEmptyItems() ([]Items_Columns, error) {
	items_value := []Items_Columns{}
	err = db.Select(&items_value, "SELECT * FROM items WHERE item_quantity=?", 0)
	if  err != nil {
		log.Println("[!] ERROR: ModelsSelectEmptyItems:", err)
	}
	return items_value, err
}

// using this function could used for inserting data into database with spesific table
// in parameter
// parameter: (table_name, data)
func ModelsInsertDataItems(data ...string) error {
	sql_query := `INSERT INTO items (item_id, item_name, item_model, 
		item_limitation, item_quantity, item_unit, date_of_entry, item_time_period, 
		item_expired, item_owner, owner_id, item_location, item_status, added_by) 
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
	`
	x, err := db.Queryx(sql_query, data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12], data[13])
	defer x.Close()
	return err
}

// ModelsRemoveDataItem() is function that used for removing an item with the given ID
func ModelsRemoveDataItem(item_id string) error {
	x, err := db.Queryx("DELETE FROM items WHERE item_id=?", item_id)
	defer x.Close()
	return err
}

// ModelsUpdateDataItem() is function that used for updating an item with the given ID
//func ModelsUpdateDataItem(item_id, item_name, item_model, item_quantity, item_limitation, item_unit, item_time_period, item_expired, item_owner, item_location, item_status string) error {
func ModelsUpdateDataItem(item_id, item_name, item_model, item_quantity, item_limitation, item_unit, item_time_period, item_expired, item_owner, item_location, item_status string) error { 
	x, err := db.Queryx("UPDATE items SET item_name=?, item_model=?, item_quantity=?, Item_limitation=?, item_unit=?, item_time_period=?, item_expired=?, item_owner=?, item_location=?, item_status=? WHERE item_id=?", item_name, item_model, item_quantity, item_limitation, item_unit, item_time_period, item_expired, item_owner, item_location, item_status, item_id)
	defer x.Close()
	return err
}

func ModelsPickupItem(item_id, item_quantity, item_status string) error {
	x, err := db.Queryx("UPDATE items SET item_quantity=?, item_status=? WHERE item_id=?", item_quantity, item_status, item_id)
	defer x.Close()
	return err
}

func ModelsInsertDataTest(data ...string) {
	log.Println(data)
}

// cancel pickup request
func ModelsUpdateCancelPickUp(item_id string, reverse_quantity int) error {
	x, err := db.Queryx("UPDATE items SET item_quantity=? WHERE item_id=?", reverse_quantity, item_id)
	defer x.Close()
	return err
}

func ModelsUpdateHistoryCancel(status, history_id string) error {
	x, err := db.Queryx("UPDATE history SET history_status=? WHERE history_id=?", status, history_id)
	defer x.Close()
	return err
}