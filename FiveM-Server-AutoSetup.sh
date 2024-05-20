#!/bin/bash

exit_with_error() {
    echo "Error: $1"
    exit 1
}

apt update || exit_with_error "Failed to update packages."
apt upgrade -y || exit_with_error "Failed to upgrade the system."

apt install -y mariadb-client mariadb-server || exit_with_error "Failed to install MariaDB."

apt install -y phpmyadmin || exit_with_error "Failed to install phpMyAdmin."

echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf || exit_with_error "Failed to configure Apache."

apt install -y php || exit_with_error "Failed to install PHP."

service apache2 restart || exit_with_error "Failed to restart Apache service."

mkdir CFX-Server || exit_with_error "Failed to create CFX-Server directory."
cd CFX-Server || exit_with_error "Failed to access CFX-Server directory."

wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7290-a654bcc2adfa27c4e020fc915a1a6343c3b4f921/fx.tar.xz || exit_with_error "Failed to download fx.tar.xz."
tar xvf fx.tar.xz || exit_with_error "Failed to extract fx.tar.xz."
rm fx.tar.xz || exit_with_error "Failed to remove fx.tar.xz."

clear || exit_with_error "Failed to clear console."

read -p "SQL User > " SQL_USER
read -p "SQL Pass > " SQL_PASS
read -p "SQL DATABASE > " SQL_DATABASE

clear || exit_with_error "Failed to clear console."

mysql -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'localhost' IDENTIFIED BY '$SQL_PASS'; \
           GRANT ALL PRIVILEGES ON *.* TO '$SQL_USER'@'localhost'; \
           CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;" || exit_with_error "Failed to create SQL user and database."

echo "Installation completed successfully."
echo "To launch the server with TXADMIN, run the command './run.sh'."
echo "To launch the server without TXADMIN, run the command './run.sh +exec server.cfg'."
