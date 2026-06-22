# EliteDrive — Vehicle Rental Management System

A full-stack Java Servlet + JSP web application for vehicle rental management, backed by **MySQL**. Features a customer-facing frontend and a complete admin dashboard with live database integration.

---

## 🗂 Project Structure

```
vehicle management system/
├── src/                          # Java source files
│   ├── dao/
│   │   ├── DBConnection.java     # JDBC connection pool
│   │   ├── CustomerDAO.java      # Customer CRUD operations
│   │   ├── VehicleDAO.java       # Vehicle CRUD operations
│   │   ├── BookingDAO.java       # Booking CRUD operations
│   │   └── UserDAO.java          # Delegates to CustomerDAO + Admin table
│   ├── model/
│   │   ├── User.java             # Customer / Admin model
│   │   ├── Vehicle.java          # Vehicle model
│   │   └── Booking.java          # Booking model
│   └── servlet/
│       ├── LoginServlet.java     # POST /login
│       ├── RegisterServlet.java  # POST /register
│       ├── LogoutServlet.java    # GET  /logout
│       ├── AdminServlet.java     # POST /vehicle (add/update/delete)
│       ├── BookingServlet.java   # POST /booking (create / updateStatus)
│       └── VehicleServlet.java   # GET  /vehicles (customer listing)
├── web/                          # Web application root (deploy this)
│   ├── WEB-INF/
│   │   ├── web.xml               # Servlet mappings & configuration
│   │   ├── lib/
│   │   │   └── mysql-connector-j-8.0.33.jar
│   │   └── classes/              # Compiled .class files go here
│   ├── admin/                    # Admin JSP pages
│   │   ├── index.jsp             # Dashboard (live stats)
│   │   ├── vehicles.jsp          # Vehicle management
│   │   ├── bookings.jsp          # Booking management
│   │   ├── customers.jsp         # Customer management
│   │   ├── reports.jsp           # Analytics & reports
│   │   └── add-vehicle.jsp       # Add / Edit vehicle form
│   ├── index.jsp                 # Customer homepage
│   ├── login.jsp                 # Login page
│   ├── register.jsp              # Registration page
│   ├── vehicles.jsp              # Vehicle listing (customer)
│   ├── booking.jsp               # Booking form
│   └── ...
├── schema.sql                    # ← Run this first!
├── build.bat                     # Build / compile script
└── server.js                     # Static HTML server (dev only)
```

---

## 🗄 Database Setup

### 1. Prerequisites
- MySQL Server 8.x installed and running
- A MySQL user (default in `DBConnection.java`: `root` / `2002sh..`)

### 2. Run the SQL Script

Open MySQL Workbench or the MySQL command line and run:

```sql
source C:/Users/User/Desktop/vehicle management system/schema.sql
```

Or via command line:
```bash
mysql -u root -p < "C:\Users\User\Desktop\vehicle management system\schema.sql"
```

This creates the `vehicle_rental` database with tables:
- `admin` — admin accounts
- `customer` — registered customers  
- `vehicle` — fleet vehicles
- `booking` — rental bookings

And seeds sample data (11 customers, 16 vehicles, 8 bookings).

### 3. Default Admin Credentials
| Email | Password |
|-------|----------|
| `admin@elitedrive.com` | `admin123` |

---

## ⚙ Build & Compile

### Requirements
- **Java JDK 11+** (JDK 24 found at `C:\Program Files\Java\jdk-24`)
- **Apache Tomcat 9.x** (for deployment)
- **servlet-api.jar** (from Tomcat's `lib/` folder)

### Step 1: Get servlet-api.jar

Copy `servlet-api.jar` from your Tomcat installation:

```
C:\apache-tomcat-9.x.x\lib\servlet-api.jar
→ Copy to →
C:\Users\User\Desktop\vehicle management system\web\WEB-INF\lib\javax.servlet-api-4.0.1.jar
```

> **Rename it** to `javax.servlet-api-4.0.1.jar` or update the filename in `build.bat`.

### Step 2: Run build.bat

Double-click `build.bat` or run from command prompt:

```cmd
cd "C:\Users\User\Desktop\vehicle management system"
build.bat
```

This compiles all Java source files into `web\WEB-INF\classes\`.

### Step 3: Deploy to Tomcat

Copy the entire `web` folder to Tomcat's webapps directory:

```
web\  →  C:\apache-tomcat-9.x.x\webapps\vehicle_rental\
```

### Step 4: Start Tomcat

```cmd
C:\apache-tomcat-9.x.x\bin\catalina.bat start
```

### Step 5: Open the App

```
http://localhost:8080/vehicle_rental/
```

---

## 🚗 Features

### Customer Portal
| Feature | URL | Description |
|---------|-----|-------------|
| Home | `/` | Browse featured vehicles |
| Browse Vehicles | `/vehicles` | Filter by category, price, fuel |
| Vehicle Details | `/vehicles?id=X` | Full vehicle info |
| Register | `/register` | Create customer account |
| Login | `/login` | Customer login |
| Book Vehicle | `/booking?vehicleId=X` | Submit booking |
| My Bookings | `/booking.jsp` | View booking history |
| Logout | `/logout` | End session |

### Admin Dashboard
| Feature | URL | Description |
|---------|-----|-------------|
| Dashboard | `/admin/index.jsp` | Live stats: customers, vehicles, revenue |
| Vehicles | `/admin/vehicles.jsp` | Add / Edit / Delete vehicles |
| Bookings | `/admin/bookings.jsp` | Approve / Cancel / Complete bookings |
| Customers | `/admin/customers.jsp` | View all registered customers |
| Reports | `/admin/reports.jsp` | Analytics: category, top vehicles |

---

## 🔌 Database Configuration

Edit `src/dao/DBConnection.java` to change connection settings:

```java
private static final String URL = "jdbc:mysql://localhost:3306/vehicle_rental?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String USER = "root";
private static final String PASSWORD = "2002sh..";
```

---

## 📋 Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Java 11+ Servlets & JSP |
| Database | MySQL 8.x + JDBC (mysql-connector-j 8.0.33) |
| Frontend | HTML5, CSS3, Bootstrap 5.3, Bootstrap Icons |
| Server | Apache Tomcat 9.x |
| Build | Manual javac / build.bat |

---

## 🔐 Session Management

- **Customer session** → attribute: `currentUser` (role: `CUSTOMER`)
- **Admin session** → attribute: `adminUser` (role: `ADMIN`)
- Session timeout: 60 minutes (configured in `web.xml`)

---

## ⚠ Notes

1. **Passwords are stored in plain text** — use bcrypt in production
2. The `server.js` Node server only serves the **static HTML** files (for development preview), not the Java servlet app
3. The `admin/` folder at the root serves static admin HTML prototypes only — the live admin is at `web/admin/*.jsp`
