package models

import (
	"log"
)

// user_login table in database
type User_Login struct{
	User_id				string
	User_login_name 	string
	User_name 			string	// fullname of user
	User_privilege		string
	Password            string
	User_email			string
	Date_created		string
	Status              string
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

func ModelsSelectFromUserLogin(username string) []User_Login {
	user_login_value := []User_Login{}
	err = db.Select(&user_login_value, 
		"SELECT user_id, user_login_name, user_name, user_privilege, user_email, date_created FROM user_login WHERE user_login_name=?", 
		username,
	)

	if err != nil {
		log.Println("[!] ERROR: ModelsSelectFromUserLogin:", err)
	}

	return user_login_value
}

// add user
func ModelsAddUser(user_id, user_name, user_full_name, user_privilege, user_password, user_email, date_created, status string) error {
	sql_query := `INSERT INTO user_login (user_id, user_login_name, user_name, user_privilege, password, user_email, date_created, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
	x, err := db.Queryx(sql_query, user_id, user_name, user_full_name, user_privilege, user_password, user_email, date_created, status)
	defer x.Close()

	return err
}

// show all new user
func ModelsShowNewUsers() []User_Login {
	users_value := []User_Login{}
	query := `SELECT * FROM user_login WHERE status=?`
	err := db.Select(&users_value, query, "New")

	if err != nil {
		log.Println("[!] ERROR: ModelsShowNewUsers:", err)
	}

	return users_value
}

// show all registered user
func ModelsShowRegUsers() []User_Login {
	users_value := []User_Login{}
	query := `SELECT * FROM user_login WHERE status=?`
	err := db.Select(&users_value, query, "Registered")

	if err != nil {
		log.Println("[!] ERROR: ModelsShowRegUsers:", err)
	}

	return users_value
}

// get current user on session for setting
func ModelsGetCurrentSessionUser(username_in string) (user_id, user_name, user_full_name, user_privilege, user_password, user_email, date_created, status string) {

	var id, username, fullname, role, password, email, date, status_in string
	x, err := db.Queryx("SELECT * FROM user_login WHERE user_login_name=?", username_in)
	defer x.Close()

	for x.Next() {
		x.Scan(&id, &username, &fullname, &role, &password, &email, &date, &status_in)
	}

	if err != nil {
		log.Println("[!] ERROR: ModelGetCurrentSessionUser:", err)
	}

	return id, username, fullname, role, password, email, date, status_in
}

// delete user
func ModelsDeleteUser(id string) error {
	sql_query := "DELETE FROM user_login WHERE user_id=?"
	x, err := db.Queryx(sql_query, id)
	defer x.Close()

	return err
}

// update/setting user
func ModelsUpdateUser(user_id, user_fullname, user_name, user_password, status, user_email string) {
	if len(user_password) == 0 {
		sql_query := `UPDATE user_login SET user_login_name=?, user_name=?, user_email=?, status=? WHERE user_id=?`
		x, thisError := db.Queryx(sql_query, user_name, user_fullname, user_email, status, user_id)
		defer x.Close()

		if thisError != nil {
			log.Println(thisError)
		}
	} else {
		sql_query := `UPDATE user_login SET user_login_name=?, user_name=?, password=?, user_email=?, status=? WHERE user_id=?`
		x, thisError := db.Queryx(sql_query, user_name, user_fullname, user_password, user_email, status, user_id)
		defer x.Close()

		if thisError != nil {
			log.Println(thisError)
		}
	}
}