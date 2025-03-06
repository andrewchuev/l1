git pull origin main

docker compose down
docker compose up -d

echo "Installing dependencies..."
docker compose run --rm composer install --no-dev --optimize-autoloader || die "Composer install failed."

docker compose run --rm artisan config:cache || die "Config caching failed."
docker compose run --rm artisan route:cache || die "Route caching failed."
docker compose run --rm artisan view:cache || die "View caching failed."

echo "Running migrations..."
docker compose run --rm artisan migrate --force
echo "************* Done *************"
