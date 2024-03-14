FROM php:8.0-apache
WORKDIR /var/www/html

COPY server.php index.php

# CORS support
COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod headers
RUN service apache2 restart

EXPOSE 80