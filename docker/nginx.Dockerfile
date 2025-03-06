FROM nginx:latest

# Копирование конфигурационного файла Nginx
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Копирование сертификатов
COPY ./docker/nginx/ssl/server.crt /etc/nginx/ssl/server.crt
COPY ./docker/nginx/ssl/server.key /etc/nginx/ssl/server.key