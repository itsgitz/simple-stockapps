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
	User_email			string
	Date_created		string
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