package models

import "log"

// history table in database
type History struct{
	History_id       string
	History_date     string
	History_code     string
	History_by       string
	History_content  string
	History_notes    string
	Picked_item		 int
	Item_id          string
	History_status 	 string
}

// func history update for notification
func ModelsGetHistory() ([]History, error) {
	get_history := []History{}
	err = db.Select(&get_history, "SELECT * FROM history ORDER BY history_date DESC")
	return get_history, err
}

func ModelsUpdateHistory(id, date, code, by, content, notes, picked_item, item_id, status string) error {
	log.Println(status)
	sql_query := `INSERT INTO history (history_id, history_date, history_code, history_by, history_content, history_notes, picked_item, item_id, history_status) VALUES
	(?, ?, ?, ?, ?, ?, ?, ?, ?)
	`
	x, err := db.Queryx(sql_query, id, date, code, by, content, notes, picked_item, item_id, status)
	defer x.Close()
	return err
}

func ModelsGetMyHistory(user string) ([]History, error) {
	get_history := []History{}
	err := db.Select(&get_history, "SELECT * FROM history WHERE history_by=? ORDER BY history_date DESC", user)
	return get_history, err
}

func ModelsGetCurrentQuantity(item_id string) (int, error) {
	var quantity int
	x, err := db.Queryx("SELECT item_quantity FROM items WHERE item_id=?", item_id)

	defer x.Close()

	for x.Next() {
		x.Scan(&quantity)
	}

	return quantity, err
}