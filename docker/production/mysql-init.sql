CREATE DATABASE IF NOT EXISTS `metis`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'metis'@'127.0.0.1'
    IDENTIFIED WITH caching_sha2_password BY 'metis';

CREATE USER IF NOT EXISTS 'metis'@'localhost'
    IDENTIFIED WITH caching_sha2_password BY 'metis';

GRANT ALL PRIVILEGES ON `metis`.* TO 'metis'@'127.0.0.1';
GRANT ALL PRIVILEGES ON `metis`.* TO 'metis'@'localhost';

FLUSH PRIVILEGES;
