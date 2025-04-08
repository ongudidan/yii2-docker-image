 Here's the full `README.md` file with all the instructions included, step-by-step:

```markdown
# PHP 8.3 FPM with Nginx Docker Image

This is a custom Docker image that combines PHP 8.3 FPM with Nginx, designed for use with Yii2 applications and other PHP-based projects. The image is built on top of the official `php:8.3-fpm-alpine` image and includes Nginx, Composer, and necessary PHP extensions.

## Features

- **PHP 8.3 FPM** for FastCGI support.
- **Nginx** web server.
- **Composer** for dependency management.
- PHP extensions for MySQL and ZIP support.
- Configurable PHP settings and Nginx configurations.
- Cron jobs support for running background tasks and APIs.

## Requirements

- Docker installed on your local machine.
- Docker Hub account (to push the image to Docker Hub).

## Build Instructions

1. **Clone this repository** or copy the `Dockerfile` to your local project.
   
2. **Navigate to the directory** where your `Dockerfile` is located:
   ```bash
   cd /path/to/your/project
   ```

3. **Build the Docker image** with the following command:
   ```bash
   docker build -t ongudidan/php8.3-fpm-nginx .
   ```

   - `-t` is used to tag the image with a name (`ongudidan/php8.3-fpm-nginx`).
   - This will use the `Dockerfile` in the current directory to build the image.

4. **Verify the image build**:
   After the build process completes, check that your image is listed in your local Docker images:
   ```bash
   docker images
   ```

## Running the Container Locally

1. **Run the Docker container** using the following command:
   ```bash
   docker run -d -p 8080:80 --name php-nginx-container ongudidan/php8.3-fpm-nginx
   ```

   - This will run the container in the background (`-d`), map port 80 in the container to port 8080 on your local machine (`-p 8080:80`), and give the container the name `php-nginx-container`.

2. **Access your application**:
   Open your browser and visit `http://localhost:8080` to verify that Nginx and PHP are running.

## Pushing the Image to Docker Hub

1. **Login to Docker Hub**:
   If you haven't logged in to Docker Hub yet, use the following command to log in:
   ```bash
   docker login
   ```

   You will be prompted to enter your Docker Hub username and password.

2. **Tag the image for Docker Hub**:
   If you want to push this image to Docker Hub under your account, tag the image with your Docker Hub username:
   ```bash
   docker tag ongudidan/php8.3-fpm-nginx ongudidan/php8.3-fpm-nginx:latest
   ```

3. **Push the image to Docker Hub**:
   After tagging the image, push it to your Docker Hub repository:
   ```bash
   docker push ongudidan/php8.3-fpm-nginx:latest
   ```

   This will upload the image to Docker Hub under the `ongudidan` account.

## Usage in Other Projects

Once the image is pushed to Docker Hub, you can pull it in any project or server where you need to use PHP 8.3 FPM with Nginx.

1. **Pull the image**:
   ```bash
   docker pull ongudidan/php8.3-fpm-nginx
   ```

2. **Run the container**:
   ```bash
   docker run -d -p 8080:80 --name php-nginx-container ongudidan/php8.3-fpm-nginx
   ```

## Customizing the Configuration

You can customize the PHP and Nginx configuration files as follows:

### PHP Configuration
- To adjust PHP settings (e.g., `php.ini`), modify the `php/php.ini` file in your project. Update values like `memory_limit`, `upload_max_filesize`, etc.

### Nginx Configuration
- To customize the Nginx settings, modify the `nginx/default.conf` file in your project. You can change the document root, server name, and any other directives as needed for your Yii2 or other PHP-based applications.

### Example Nginx Configuration
The default Nginx configuration file that you can use or modify is as follows:

```nginx
server {
    listen 80;
    listen [::]:80 default ipv6only=on;

    root /var/www/html/web; # Point to Yii2 web directory
    index index.php index.html;

    server_name _;

    error_log /dev/stdout info;
    access_log /dev/stdout;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+?\.php)(|/.*)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param HTTP_PROXY "";
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param QUERY_STRING $query_string;
        fastcgi_index index.php;
        fastcgi_intercept_errors on;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~ /vendor/.*\.php$ {
        deny all;
        return 404;
    }

    location ~* \.(engine|inc|install|make|module|profile|po|sh|.*sql|theme|twig|tpl(\.php)?|xtmpl|yml)(~|\.sw[op]|\.bak|\.orig|\.save)?$|/(\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\.(json|lock)|web\.config)$|/#.*#$|\.php(~|\.sw[op]|\.bak|\.orig|\.save)$ {
        deny all;
        return 404;
    }
}
```

### Cron Jobs
To add cron jobs for background tasks or API calls, do the following:

1. Add your cron job script(s) into the container's cron directory (e.g., `/etc/cron.d/`).
2. Modify the cron job configuration as needed to schedule tasks.
3. Rebuild the container using the `docker build` command if you've made any changes to the cron jobs.

## Troubleshooting

- **Unable to access Nginx**: Ensure that the container is running and ports are correctly mapped. Check the Nginx logs for any errors.
- **PHP errors**: Check the PHP error logs in `/var/log/php-fpm.log` inside the container for any issues.
- **Cron jobs not working**: Verify that the cron service is running in the container (`ps aux | grep cron`) and that your cron job configuration is correct.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Key sections in this `README.md`:
1. **Project Overview** - Describes the image features and requirements.
2. **Build Instructions** - Walks through building the Docker image.
3. **Running the Container** - Instructions for running the Docker container locally.
4. **Pushing to Docker Hub** - How to push your custom image to Docker Hub.
5. **Customizing the Configuration** - Guides for modifying PHP and Nginx configuration files.
6. **Cron Jobs** - Instructions for adding cron jobs for API calls and background tasks.
7. **Troubleshooting** - Common troubleshooting tips.

This `README.md` file will serve as a complete guide for building, running, and deploying your custom Docker image.# yii2-docker-image
