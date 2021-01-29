FROM debian:buster

RUN apt-get update && apt-get install -y nginx php-fpm php-mysql wget
RUN apt-get install -y mariadb-server
RUN apt-get install -y php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip

RUN mkdir temp
COPY ./srcs/start.sh ./
COPY ./srcs/nginx-configaration ./temp/nginx-configaration
COPY ./srcs/phpmyadmin-configaration.php ./temp/phpmyadmin-configaration.php
COPY ./srcs/wordpress-configaration.php ./temp/wordpress-configaration.php

CMD bash start.sh