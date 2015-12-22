# PSDNS
MySQL Powershell DNS RR Automator

Download "DNS.PS1" and "sql functions includes.ps1"

Changes Effected Lines Alter DNS.ps1 to reflect your MYSQL Server 8-11 change the path to sql functions includes.ps1 3 change references to boothtech.uk to your domain. 30,32,45,47,73,74,76,89,90,93

create mysql database with table relevant to boothtech.uk

CREATE TABLE Boothtech.uk ( HOST_ID int(11) NOT NULL AUTO_INCREMENT COMMENT 'Auto Increment ID', HOST varchar(65) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL COMMENT '[Host].boothtech.uk', User_ID int(11) DEFAULT NULL, Update timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'last updated', A_Record varchar(16) DEFAULT NULL COMMENT 'IPv4 Address', AAA Record varchar(40) DEFAULT NULL COMMENT 'IPv6 address', TXT_Record varchar(65) DEFAULT NULL, added tinyint(1) NOT NULL DEFAULT '1' COMMENT 'will be set to false once server has created DNS records', updated tinyint(1) NOT NULL DEFAULT '0' COMMENT 'set to 1 when updated', PRIMARY KEY (HOST_ID) )
