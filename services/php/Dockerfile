FROM php:8.5-cli-alpine
WORKDIR /app
COPY index.php .
ENV PHP_CLI_SERVER_WORKERS=4
CMD ["php", "-S", "0.0.0.0:8000", "index.php"]
