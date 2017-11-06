--  SQL script: DC Stock Apps
--  Created by: Anggit Muhamad Ginanjar
--  Copyright @AQX
--  Lintasarta Data Center TBS

-- Create user if not exsits
CREATE USER IF NOT EXISTS 'dc'@'localhost' IDENTIFIED BY 'P4sswordDC';
GRANT ALL ON stockapps.* TO 'dc'@'localhost';

-- Create user login table
-- Table that contains information about login
CREATE TABLE IF NOT EXISTS `user_login` (
	`user_id` VARCHAR(8) NOT NULL PRIMARY KEY,	-- User ID
	`user_login_name` VARCHAR(8) NOT NULL,		-- User Name, Initial that contain 3 characters on it and in-casesensitive... It will be used when user want to login, ex: aqx
	`user_name` VARCHAR(64) NOT NULL,			-- User Common Name, contain the name of the user that will viewed on website
	`user_privilege` VARCHAR(16) NOT NULL,		-- Several privilege belong to the user login (Such as Administrator or Operator) 
	`password` VARCHAR(64) NOT NULL,			-- Password, will encrypted with encryption program
	`user_email` VARCHAR(64) NOT NULL,			-- E-mail
	`key` VARCHAR(64) NOT NULL,					-- Key as key while users forgot their password
	`date_created` DATETIME NOT NULL			-- Date and time when it user was created
);

-- Item's table that contains list of item
-- These items can added only by Administrator User
CREATE TABLE IF NOT EXISTS `items` (
	`item_id` VARCHAR(8) NOT NULL PRIMARY KEY,		-- Item ID
	`item_name` VARCHAR(254) NOT NULL,				-- Item name
	`item_limitation` INT NOT NULL,
	`item_quantity` INT NOT NULL,
	`item_unit` VARCHAR(32) NOT NULL,
	`time_period` DATE NOT NULL,
	`date_of_entry` DATETIME NOT NULL,
	`item_owner` VARCHAR(254) NOT NULL,
	`item_status` VARCHAR(32) NOT NULL
);