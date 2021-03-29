#!/bin/bash

apt-get update
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

echo "[client]
user=USUARIO
password=SENHA" > ~/.my.cnf

BD=scripts
USER=USUARIO
PASSWORD=SENHA
HOST=PRIVADOIP

cat<<EOF > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
EOF

a2enmod rewrite
a2ensite wordpress

systemctl restart apache2
systemctl reload apache2

curl -O https://wordpress.org/latest.tar.gz

tar xzvf latest.tar.gz

touch wordpress/.htaccess

cp -a wordpress/. /var/www/html/wordpress

cat<<EOF > wp-config.php
<?php
define( 'DB_NAME', '$BD' );
define( 'DB_USER', '$USER' );
define( 'DB_PASSWORD', '$PASSWORD' );
define( 'DB_HOST', '$HOST' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

cp wp-config.php /var/www/html/wordpress/

chown -R www-data:www-data /var/www/html/wordpress

find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;

find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;

systemctl restart apache2