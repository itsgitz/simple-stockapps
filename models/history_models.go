package models

// history table in database
type History struct{
	History_id       string
	History_date     string
	History_code     string
	History_by       string
	History_content  string
	History_notes    string
}

// func history update for notification
func ModelsGetHistory() ([]History, error) {
	get_history := []History{}
	err = db.Select(&get_history, "SELECT * FROM history ORDER BY history_date DESC")
	return get_history, err
}

func ModelsUpdateHistory(id, date, code, by, content, notes string) error {
	sql_query := `INSERT INTO history (history_id, history_date, history_code, history_by, history_content, history_notes) VALUES
	(?, ?, ?, ?, ?, ?)
	`
	x, err := db.Queryx(sql_query, id, date, code, by, content, notes)
	defer x.Close()
	return err
}

func ModelsGetMyHistory(user string) ([]History, error) {
	get_history := []History{}
	err := db.Select(&get_history, "SELECT * FROM history WHERE history_by=? ORDER BY history_date DESC", user)
	return get_history, err
}