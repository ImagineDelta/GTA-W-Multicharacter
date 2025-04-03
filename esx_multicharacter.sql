CREATE TABLE `multicharacter_slots` (
	`identifier` VARCHAR(60) NOT NULL,
	`slots` INT(11) NOT NULL,
	PRIMARY KEY (`identifier`) USING BTREE,
	INDEX `slots` (`slots`) USING BTREE
) ENGINE=InnoDB;

ALTER TABLE `users` ADD COLUMN
	`disabled` TINYINT(1) NULL DEFAULT '0';

ALTER TABLE users
ADD COLUMN IF NOT EXISTS playtime INT(11) DEFAULT '0';

ALTER TABLE users
ADD COLUMN IF NOT EXISTS name VARCHAR(255);