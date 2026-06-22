-- MySQL Database Setup for EliteDrive Vehicle Rental System
CREATE DATABASE IF NOT EXISTS vehicle_rental;
USE vehicle_rental;

-- 1. Admin Table
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
) AUTO_INCREMENT = 1;

-- 2. Customer Table
CREATE TABLE IF NOT EXISTS customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password VARCHAR(100) NOT NULL
) AUTO_INCREMENT = 2;

-- 3. Vehicle Table
CREATE TABLE IF NOT EXISTS vehicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price_per_day DOUBLE NOT NULL,
    transmission VARCHAR(50) NOT NULL,
    fuel VARCHAR(50) NOT NULL,
    seats INT NOT NULL,
    image VARCHAR(255),
    rating DOUBLE DEFAULT 5.0,
    description TEXT,
    status VARCHAR(20) DEFAULT 'available',
    year INT NOT NULL
) AUTO_INCREMENT = 1;

-- 4. Booking Table
CREATE TABLE IF NOT EXISTS booking (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_email VARCHAR(100) NOT NULL,
    vehicle_id INT NOT NULL,
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    pickup_location VARCHAR(150) NOT NULL,
    total_price DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    FOREIGN KEY (vehicle_id) REFERENCES vehicle(id) ON DELETE CASCADE
) AUTO_INCREMENT = 1000;

-- ═══ SEED INITIAL DATA ═══════════════════════════════════════

-- Seed Admin
INSERT IGNORE INTO admin (id, name, email, password) VALUES 
(1, 'Admin User', 'admin@elitedrive.com', 'admin123');

-- Seed Customers
INSERT IGNORE INTO customer (id, name, email, phone, password) VALUES 
(2, 'Alexander Harris', 'a.harris@email.com', '+1 555 0101', 'password123'),
(3, 'Marcus Lawson', 'm.lawson@mail.com', '+1 555 0202', 'password123'),
(4, 'Sophia Reynolds', 'sophia.r@webmail.com', '+44 7911 234567', 'password123'),
(5, 'Priya Sharma', 'priya.s@inbox.com', '+91 98765 43210', 'password123'),
(6, 'James Kowalski', 'j.kowalski@corp.net', '+49 151 23456789', 'password123'),
(7, 'Lena Torres', 'lena.t@fastmail.com', '+34 612 345 678', 'password123'),
(8, 'Kwame Nkrumah', 'k.nkrumah@global.org', '+233 20 123 4567', 'password123'),
(9, 'Rachel Moore', 'rachel.m@outlook.com', '+1 555 0787', 'password123'),
(10, 'Daniel Osei', 'd.osei@proton.me', '+44 7700 900456', 'password123'),
(11, 'Yuna Lee', 'yuna.lee@connect.kr', '+82 10 1234 5678', 'password123'),
(12, 'Ben Walsh', 'ben.w@themail.co.uk', '+44 7800 123456', 'password123');

-- Seed Vehicles
INSERT IGNORE INTO vehicle (id, brand, model, category, price_per_day, transmission, fuel, seats, image, rating, description, status, year) VALUES 
(1, 'Aether', 'Spectre S', 'Car', 250.0, 'Automatic', 'Hybrid', 5, 'assets/images/car.jpg', 4.9, 'Toyota Premio executive luxury sedan with high fuel efficiency.', 'available', 2022),
(2, 'Apex', 'Volante GTR', 'Car', 320.0, 'Manual', 'Petrol', 2, 'assets/images/car.jpg', 4.9, 'Twin-turbo V8 high-performance sports coupe.', 'rented', 2023),
(3, 'TransPro', 'Cargo Master', 'Van', 110.0, 'Automatic', 'Diesel', 2, 'assets/images/van.jpg', 4.6, 'Spacious and durable commercial cargo transporter.', 'available', 2021),
(4, 'Ridgeline', 'Combi 9', 'Van', 130.0, 'Automatic', 'Petrol', 9, 'assets/images/van.jpg', 4.7, 'Toyota KDH Commuter replica people carrier with 9 comfortable seats.', 'available', 2022),
(5, 'ThunderRide', 'Storm 750', 'Motorbike', 75.0, 'Manual', 'Petrol', 2, 'assets/images/motorbike.jpg', 4.85, 'A naked street bike engineered for thrills and agility.', 'rented', 2023),
(6, 'IronHorse', 'Cruiser Classic', 'Motorbike', 85.0, 'Manual', 'Petrol', 2, 'assets/images/motorbike.jpg', 4.8, 'Retro V-twin classic cruiser designed for the open roads.', 'available', 2020),
(7, 'Zephyr', 'City Glide 125', 'Scooter', 35.0, 'Automatic', 'Petrol', 2, 'assets/images/scooter.jpg', 4.7, 'Traditional Sri Lankan Bajaj Tuk-Tuk three-wheeler model.', 'available', 2021),
(8, 'VoltRide', 'Eco E-Scoot', 'Scooter', 40.0, 'Automatic', 'Electric', 2, 'assets/images/scooter.jpg', 4.75, 'Quiet electric urban scooter with regenerative braking.', 'maintenance', 2023),
(9, 'OmniFleet', 'Shuttle 24', 'Bus', 280.0, 'Automatic', 'Diesel', 24, 'assets/images/bus.jpg', 4.65, 'Shuttle coach for employee transport and medium group tours.', 'available', 2021),
(10, 'CoachPro', 'Grand Tourer 52', 'Bus', 480.0, 'Automatic', 'Diesel', 52, 'assets/images/bus.jpg', 4.7, 'Premium luxury tourist coach with air-ride suspension and full comfort.', 'rented', 2022),
(11, 'HaulKing', 'Atlas 7.5T', 'Lorry', 195.0, 'Manual', 'Diesel', 2, 'assets/images/lorry.jpg', 4.6, 'Reliable medium weight cargo lorry with tail-lift body.', 'available', 2019),
(12, 'SteelHaul', 'Titan 18T', 'Lorry', 350.0, 'Automatic', 'Diesel', 2, 'assets/images/lorry.jpg', 4.55, 'Heavy-duty logistics lorry for large scale industrial hauling.', 'available', 2021),
(13, 'Vanguard', 'Ranger Pro 4x4', 'Truck', 175.0, 'Automatic', 'Diesel', 5, 'assets/images/truck.jpg', 4.8, 'Tough four-wheel-drive pickup truck for challenging terrain.', 'available', 2022),
(14, 'TerraFlex', 'Gladiator V8', 'Truck', 220.0, 'Automatic', 'Petrol', 5, 'assets/images/truck.jpg', 4.75, 'High-riding V8 truck with lift kit and heavy off-road tires.', 'available', 2023),
(15, 'AquaLux', 'Riviera 28', 'Boat', 450.0, 'Automatic', 'Petrol', 8, 'assets/images/boat.jpg', 4.9, 'Luxurious speed boat perfect for river cruising and coastal leisure.', 'available', 2022),
(16, 'SpeedWave', 'Jet Runner 22', 'Boat', 380.0, 'Automatic', 'Petrol', 6, 'assets/images/boat.jpg', 4.85, 'Sporty open layout motorboat tuned for water sports.', 'available', 2021);

-- Seed Bookings
INSERT IGNORE INTO booking (id, customer_email, vehicle_id, pickup_date, return_date, pickup_location, total_price, status) VALUES 
(1025, 'a.harris@email.com', 6, '2026-06-01', '2026-06-05', 'Colombo Airport', 340.0, 'approved'),
(1026, 'sophia.r@webmail.com', 2, '2026-06-08', '2026-06-10', 'Galle Face', 640.0, 'cancelled'),
(1027, 'rachel.m@outlook.com', 3, '2026-06-10', '2026-06-12', 'Kandy', 220.0, 'completed'),
(1028, 'yuna.lee@connect.kr', 13, '2026-06-15', '2026-06-17', 'Negombo', 350.0, 'completed'),
(1029, 'a.harris@email.com', 1, '2026-06-18', '2026-06-21', 'Colombo Fort', 750.0, 'active'),
(1032, 'm.lawson@mail.com', 5, '2026-06-25', '2026-06-28', 'Bentota', 225.0, 'pending'),
(1033, 'priya.s@inbox.com', 7, '2026-06-22', '2026-06-25', 'Colombo Fort', 105.0, 'pending'),
(1034, 'j.kowalski@corp.net', 15, '2026-06-27', '2026-06-30', 'Mirissa Marina', 1350.0, 'pending');
