DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  id int(11) NOT NULL AUTO_INCREMENT,
  domain_id int(11) NOT NULL,
  username varchar(155) NOT NULL,
  password varchar(255) NOT NULL,
  enabled tinyint(1) NOT NULL DEFAULT '1',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY domain_id_user_name (domain_id, username),
  CONSTRAINT accounts_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS aliases;
CREATE TABLE aliases (
  id int(11) NOT NULL AUTO_INCREMENT,
  domain_id int(11) NOT NULL,
  alias varchar(155) NOT NULL,
  email varchar(255) NOT NULL,
  enabled tinyint(1) NOT NULL DEFAULT '1',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY domain_id (domain_id),
  CONSTRAINT aliases_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS domains;
CREATE TABLE domains (
  id int(11) NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  enabled tinyint(1) NOT NULL DEFAULT '1',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS recipient_bccs;
CREATE TABLE recipient_bccs (
  id int(11) NOT NULL AUTO_INCREMENT,
  account_id int(11) NOT NULL,
  receiver_email_address varchar(255) NOT NULL,
  enabled tinyint(1) DEFAULT '1',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY rbccs_account_id_receiver_email_address (account_id, receiver_email_address),
  CONSTRAINT recipient_bccs_ibfk_1 FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sender_bccs;
CREATE TABLE sender_bccs (
  id int(11) NOT NULL AUTO_INCREMENT,
  account_id int(11) NOT NULL,
  receiver_email_address varchar(255) NOT NULL,
  enabled tinyint(1) NOT NULL DEFAULT '1',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY account_id_receiver_email_address (account_id, receiver_email_address),
  CONSTRAINT sender_bccs_ibfk_1 FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

DROP VIEW IF EXISTS vw_aliases;
CREATE VIEW vw_aliases AS 
    select concat(a.alias, '@', d.name) AS alias, a.email AS email,(d.enabled & a.enabled) AS enabled 
    from aliases a inner join domains d on d.id = a.domain_id;

DROP VIEW IF EXISTS vw_recipient_bccs;
CREATE VIEW vw_recipient_bccs AS 
    select concat(a.username, '@', d.name) AS source_email_address, r.receiver_email_address AS receiver_email_address, r.enabled AS enabled 
    from recipient_bccs r inner join accounts a on a.id = r.account_id join domains d on d.id = a.domain_id;

DROP VIEW IF EXISTS vw_sender_bccs;
CREATE VIEW vw_sender_bccs AS 
    select concat(a.username, '@', d.name) AS source_email_address, f.receiver_email_address AS receiver_email_address, f.enabled AS enabled 
    from accounts a inner join domains d on a.domain_id = d.id join sender_bccs f on f.account_id = a.id;

DROP VIEW IF EXISTS vw_user_logins;
CREATE VIEW vw_user_logins AS 
    select d.id AS domain_id, a.id AS account_id, concat(a.username, '@', d.name) AS login, a.password AS password, d.enabled & a.enabled AS enabled 
    from accounts a inner join domains d on d.id = a.domain_id;
