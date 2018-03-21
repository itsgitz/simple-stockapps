--  SQL script: DC Stock Apps
--  Created by: Anggit Muhamad Ginanjar @ Koperasi Karyawan PT APLIKANUSA LINTASARTA
--  Copyright @AQX

-- Create user login table
-- Table that contains information about login
CREATE TABLE IF NOT EXISTS `user_login` (
	`user_id` VARCHAR(16) NOT NULL PRIMARY KEY,	-- User ID
	`user_login_name` VARCHAR(8) NOT NULL,		-- User Name, Initial that contain 3 characters on it and in-casesensitive... It will be used when user want to login, ex: aqx
	`user_name` VARCHAR(64) NOT NULL,			-- User Common Name, contain the name of the user that will viewed on website
	`user_privilege` VARCHAR(16) NOT NULL,		-- Several privilege belong to the user login (Such as Administrator or Operator) 
	`password` VARCHAR(64) NOT NULL,			-- Password, will encrypted with encryption program
	`user_email` VARCHAR(64) NOT NULL,			-- E-mail
	`date_created` DATETIME NOT NULL,			-- Date and time when it user was created
	`status` VARCHAR(32) NOT NULL
)
ENGINE=InnoDB
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;

-- Default values for user_login table
INSERT INTO `user_login` (
	`user_id`, `user_login_name`, `user_name`, `user_privilege`,
	`password`, `user_email`, `date_created`, `status`
) VALUES (
	'001', 'mimin', 'Default User', 'Administrator', '123456abC',
	'mimin.mimin@lintasarta.co.id', '2017-11-11', 'Registered'
);

-- Item's table that contains list of item
-- These items can added only by Administrator User
CREATE TABLE IF NOT EXISTS `items` (
	`item_id` VARCHAR(16) NOT NULL PRIMARY KEY,		-- Item ID
	`item_name` VARCHAR(254) NOT NULL,				-- Item name
	`item_model` VARCHAR(254) NOT NULL,
	`item_limitation` INT NOT NULL,
	`item_quantity` INT NOT NULL,
	`item_unit` VARCHAR(32) NOT NULL,
	`date_of_entry` DATETIME NOT NULL,
	`item_time_period` VARCHAR(32) NOT NULL,
	`item_expired` DATETIME NOT NULL,
	`item_owner` VARCHAR(254) NOT NULL,
	`owner_id` VARCHAR(32) NOT NULL,
	`item_location` VARCHAR(32) NOT NULL,
	`item_status` VARCHAR(32) NOT NULL,
	`added_by` VARCHAR(64) NOT NULL
)
ENGINE=InnoDB
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;

CREATE TABLE IF NOT EXISTS `items_current_used` (
	`item_id` VARCHAR(16) NOT NULL PRIMARY KEY,
	`name` VARCHAR(254) NOT NULL,
	`in` DATETIME NOT NULL,
	`quantity` INT NOT NULL,
	`used` INT NOT NULL,
	`rest` INT NOT NULL,
	`status` VARCHAR(32) NOT NULL
)
ENGINE=InnoDB
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;

CREATE TABLE IF NOT EXISTS `items_report_storage` (
	`item_id` VARCHAR(16) NOT NULL PRIMARY KEY,
	`name` VARCHAR(254) NOT NULL,
	`in` DATETIME NOT NULL,
	`quantity` INT NOT NULL,
	`used` INT NOT NULL,
	`rest` INT NOT NULL,
	`status` VARCHAR(32) NOT NULL
)
ENGINE=InnoDB
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;

-- History table for history/log and notification backend storage
CREATE TABLE IF NOT EXISTS `history` (
	`history_id` VARCHAR(16) NOT NULL PRIMARY KEY,
	`history_date` DATETIME NOT NULL,
	`history_code` VARCHAR(16) NOT NULL,
	`history_by` VARCHAR(64) NOT NULL,
	`history_content` TEXT NOT NULL,
	`history_notes` TEXT NOT NULL,
	`picked_item` INT NOT NULL,
	`item_id` VARCHAR(16) NOT NULL,
	`history_status` VARCHAR(16) NOT NULL
)
ENGINE=InnoDB
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;