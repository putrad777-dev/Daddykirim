CREATE DATABASE IF NOT EXISTS daddykirim;
USE daddykirim;

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer', 'driver', 'admin') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- DRIVER PROFILES
-- =========================
CREATE TABLE driver_profiles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    vehicle_type ENUM('motor', 'mobil') NOT NULL DEFAULT 'motor',
    vehicle_number VARCHAR(20),
    is_online BOOLEAN NOT NULL DEFAULT FALSE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================
-- ORDERS
-- =========================
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    customer_id BIGINT UNSIGNED NOT NULL,
    driver_id BIGINT UNSIGNED NULL,

    pickup_address TEXT NOT NULL,
    destination_address TEXT NOT NULL,

    pickup_latitude DECIMAL(10,8),
    pickup_longitude DECIMAL(11,8),

    destination_latitude DECIMAL(10,8),
    destination_longitude DECIMAL(11,8),

    item_description TEXT,

    distance_km DECIMAL(8,2) DEFAULT 0,
    delivery_fee DECIMAL(12,2) DEFAULT 0,

    status ENUM(
        'pending',
        'accepted',
        'picked_up',
        'on_delivery',
        'completed',
        'cancelled'
    ) NOT NULL DEFAULT 'pending',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    FOREIGN KEY (driver_id)
        REFERENCES users(id)
        ON DELETE SET NULL
);

-- =========================
-- ORDER STATUS HISTORY
-- =========================
CREATE TABLE order_status_histories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    order_id BIGINT UNSIGNED NOT NULL,

    status ENUM(
        'pending',
        'accepted',
        'picked_up',
        'on_delivery',
        'completed',
        'cancelled'
    ) NOT NULL,

    note TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE
);

-- =========================
-- DRIVER LOCATIONS
-- =========================
CREATE TABLE driver_locations (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    driver_id BIGINT UNSIGNED NOT NULL,

    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (driver_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);

-- =========================
-- PAYMENTS
-- =========================
CREATE TABLE payments (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    order_id BIGINT UNSIGNED NOT NULL UNIQUE,

    amount DECIMAL(12,2) NOT NULL,

    method ENUM(
        'cash',
        'qris',
        'ewallet'
    ) NOT NULL DEFAULT 'cash',

    status ENUM(
        'pending',
        'paid',
        'failed'
    ) NOT NULL DEFAULT 'pending',

    paid_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE
);
