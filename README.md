# Postfix Database

Configuration files and database schema for Postfix and Dovecot. 

# Installation

You have to configure Postfix for virtual domains by setting the required `virtual_*` keys in main.cf and point them to the appropriate `mysql_*` files in the etc directory. Then configure Dovecot to use SQL authentication using the file in etc/dovecot.

Create a database that will hold the tables and views for your mail server and change the dbname, username and password in the configuration files accordingly.

## Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as possible to help me fixing the possible bug. I encourage you to help even more by forking the project and sending a pull request.
