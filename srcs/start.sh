# project folder
mkdir /var/www/oryndoon
mkdir /var/www/oryndoon/logs
chown -R www-data /var/www/*
chmod -R 755 /var/www/*
echo "<?php echo phpinfo(); ?>" >> /var/www/oryndoon/index.php

# ssl
mkdir /etc/nginx/ssl
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/oryndoon.pem \
        -keyout /etc/nginx/ssl/oryndoon.key -subj "/C=RU/ST=moscow/L=moscow/O=school21/CN=oryndoon"

# nginx configuration
mv /temp/nginx-configaration /etc/nginx/sites-available/oryndoon
ln -s /etc/nginx/sites-available/oryndoon /etc/nginx/sites-enabled/oryndoon
rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default

# mysql
service mysql start
echo "CREATE DATABASE oryndoon_wp;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# phpmyadmin
cd /var/www/oryndoon || exit
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
tar xzvf phpMyAdmin-5.0.4-all-languages.tar.gz && mv phpMyAdmin-5.0.4-all-languages phpmyadmin
rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
mv /temp/phpmyadmin-configaration.php /var/www/oryndoon/phpmyadmin/config.inc.php

# wordpress
cd /var/www/oryndoon || exit
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz && mv latest.tar.gz wordpress
rm -rf latest.tar.gz
mv /temp/wordpress-configaration.php /var/www/oryndoon/wordpress/wp-config.php

service php7.3-fpm start
service nginx start
bash