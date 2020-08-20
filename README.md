# Postfix Database

Configuration files and SQL scripts for configuring an email server based on Postfix and Dovecot using PostgreSQL or MySQL database backend.

This project doesn't contain the full database schema (tables), as it's intended as a companion to the [PostfixRestServer](https://github.com/lyubenblagoev/postfix-rest-server) project, which can create the necessary tables (see below).

# Installation

You need to configure Postfix for virtual domains by setting the required `virtual_*` keys in main.cf and point them to the appropriate `mysql_*` files (if you are using MySQL database) or `pgsql_*` files (for PostgreSQL). Then configure Dovecot to use SQL authentication using the file in etc/dovecot.

Create a 'servermail' database and 'mailuser' user for your mail server and change the dbname, username and password in the configuration files accordingly. Of course you can change the database name, user's name or user's password. If you chose to do so, don't forget to check and modify the SQL scripts in the `views` directory accordingly.

Once the database and user are created in the database server you can use the [PostfixRestServer](https://github.com/lyubenblagoev/postfix-rest-server) to create the database tables by enabling `spring.jpa.generate-ddl` configuration parameter and set configure the database connection in `application.properties` and then create the views that are needed for Postfix and Dovecot using the scripts in the `views` directory.

## Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as possible to help me fixing the possible bug. I encourage you to help even more by forking the project and sending a pull request.
