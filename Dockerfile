# Imagen base con PHP 8.2
FROM php:8.2-cli

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    && docker-php-ext-install zip

# Instalar Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Dar permisos a Laravel
RUN chmod -R 777 storage bootstrap/cache

# Instalar dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Generar cache de Laravel
RUN php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

# Exponer puerto de Render
EXPOSE 10000

# Iniciar Laravel
CMD php artisan serve --host 0.0.0.0 --port 10000
