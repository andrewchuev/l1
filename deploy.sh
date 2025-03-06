git pull origin main

echo "Installing dependencies..."
composer install --no-dev --optimize-autoloader || die "Composer install failed."

echo "Running migrations..."
php artisan migrate --force || die "Migrations failed."

php artisan config:cache || die "Config caching failed."
php artisan route:cache || die "Route caching failed."
php artisan view:cache || die "View caching failed."

php artisan migrate --force

npm install

echo "************* Done *************"
