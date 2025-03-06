#!/bin/bash


die() {
  echo "ERROR: $1"
  exit 1
}


if ! command -v docker compose &> /dev/null; then
  die "Docker Compose is not installed."
fi


echo "Updating code..."
git fetch origin main || die "Git fetch failed."
git checkout main || die "Git checkout failed."
git pull origin main || die "Git pull failed."


echo "Restarting containers..."
docker compose down || die "Docker compose down failed."
docker compose up -d --remove-orphans || die "Docker compose up failed."


echo "Installing dependencies..."
docker compose run --rm composer install --no-dev --optimize-autoloader || die "Composer install failed."


echo "Running Artisan commands..."

docker compose run --rm artisan storage:link || die "Storage link failed."


docker compose run --rm artisan config:cache || die "Config caching failed."
docker compose run --rm artisan route:cache || die "Route caching failed."
docker compose run --rm artisan view:cache || die "View caching failed."

echo "Running migrations..."
docker compose run --rm artisan migrate --force || die "Migrations failed."

echo "************* Done *************"
