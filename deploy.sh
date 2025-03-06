#!/bin/bash

# Функция для обработки ошибок
die() {
  echo "ERROR: $1"
  exit 1
}

# Проверяем наличие Docker Compose
if ! command -v docker compose &> /dev/null; then
  die "Docker Compose is not installed."
fi

# Обновление кода
echo "Updating code..."
git fetch origin main || die "Git fetch failed."
git checkout main || die "Git checkout failed."
git pull origin main || die "Git pull failed." # Добавили проверку

# Остановка и запуск контейнеров (с удалением "осиротевших")
echo "Restarting containers..."
docker compose down || die "Docker compose down failed."
docker compose up -d --remove-orphans || die "Docker compose up failed."

# Установка зависимостей
echo "Installing dependencies..."
docker compose run --rm composer install --no-dev --optimize-autoloader || die "Composer install failed."

# Выполнение команд Artisan (объединены в один вызов)
echo "Running Artisan commands..."
docker compose run --rm artisan bash -c \
  '[ ! -L public/storage ] && php artisan storage:link || echo "Storage link already exists."; \
   php artisan config:cache; \
   php artisan route:cache; \
   php artisan view:cache; \
   php artisan migrate --force' || die "Artisan commands failed."

echo "************* Done *************"
