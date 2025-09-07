FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Instalar Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Configurar el directorio de la app
WORKDIR /app

# Copiar archivos
COPY . .

# Instalar dependencias
RUN composer install --no-dev --optimize-autoloader

# Generar cache de Laravel
RUN php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

# Exponer puerto
EXPOSE 10000

# Arrancar Laravel
CMD php artisan serve --host 0.0.0.0 --port 10000
