--  SQL script: DC Stock Apps
--  Created by: Anggit Muhamad Ginanjar @ PT APLIKANUSA LINTASARTA
--  Copyright @AQX

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

-- Default values for user_login table
INSERT INTO `user_login` (
	`user_id`, `user_login_name`, `user_name`, `user_privilege`,
	`password`, `user_email`, `key`, `date_created`
) VALUES (
	'001', 'mimin', 'Default User', 'Administrator', '123456abC',
	'mimin.mimin@lintasarta.co.id', '0992012412Bxas', '2017-11-11'
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
	`owner_id` VARCHAR(16) NOT NULL,
	`item_location` VARCHAR(32) NOT NULL,
	`item_status` VARCHAR(32) NOT NULL
);

-- Default values for items table
INSERT INTO `items` (
	`item_id`, `item_name`, `item_model`, `item_limitation`, `item_quantity`,
	`item_unit`, `date_of_entry`, `item_time_period`, `item_expired`, `item_owner`, `owner_id`, `item_location`,
	`item_status`
) VALUES (
	'001', 'Cat-7 UTP Cable', 'AMP Connect', 5, 10, 'Cable Roll', '2017-11-11', 'None',
	'0000-00-00', 'PT APLIKANUSA LINTASARTA', '0091202898120', 'DC TBS 1st Floor', 'Available'
);
