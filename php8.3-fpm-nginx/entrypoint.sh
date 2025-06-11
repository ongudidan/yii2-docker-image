#!/usr/bin/env bash

# Start PHP-FPM in the background
php-fpm &

# Start cron daemon with log output directed to the Docker logs
crond -L /proc/1/fd/1 -b -l 8 -c /etc/cron.d &

# Start nginx in the foreground
nginx -g "daemon off;"  &

# Start Supervisor (which will manage other processes like RabbitMQ worker)
supervisord -c /etc/supervisord.conf