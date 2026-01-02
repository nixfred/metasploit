# Vulnerable WordPress for pentesting practice
# Weak admin credentials and debug mode enabled
FROM wordpress:5.4-php7.2

# Enable debug mode (exposes errors)
RUN echo "define('WP_DEBUG', true);" >> /usr/src/wordpress/wp-config-docker.php; \
    echo "define('WP_DEBUG_LOG', true);" >> /usr/src/wordpress/wp-config-docker.php; \
    echo "define('WP_DEBUG_DISPLAY', true);" >> /usr/src/wordpress/wp-config-docker.php

# Expose
EXPOSE 80
