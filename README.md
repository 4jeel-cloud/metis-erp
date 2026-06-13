<p align="center">
  <a href="https://github.com/4jeel-cloud/aureuserp">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/4jeel-cloud/metis-erp/master/public/images/logo-dark.png">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/4jeel-cloud/metis-erp/master/public/images/logo-light.png">
      <img src="https://raw.githubusercontent.com/4jeel-cloud/metis-erp/master/public/images/logo-light.png" alt="Metis ERP logo" width="350">
    </picture>
  </a>  
</p>

<h1 align="center">Metis ERP</h1>

<p align="center">
  <strong>Open-Source Enterprise Resource Planning for Modern Businesses</strong>
</p>

<p align="center">
  Built with Laravel 13 • Powered by FilamentPHP 5 • PHP 8.3+
</p>

---

## 📋 Table of Contents

1. [Introduction](#-introduction)
2. [Key Features](#-key-features)
3. [Why Choose Metis ERP?](#-why-choose-metis-erp)
4. [Requirements](#-requirements)
5. [Quick Start](#-quick-start)
6. [Plugin System](#-plugin-system)
7. [Plugin Installation & Management](#-plugin-installation--management)
8. [Customization](#-customization)
9. [Contributing](#-contributing)
10. [License](#-license)
11. [Security](#-security)
12. [Support & Community](#-support--community)

---

## 🚀 Introduction

Metis ERP is a comprehensive, open-source Enterprise Resource Planning (ERP) solution designed for Small and Medium Enterprises (SMEs) and large-scale organizations. Built on **[Laravel 13](https://laravel.com)**, the most popular PHP framework, and **[FilamentPHP 5](https://filamentphp.com)**, a cutting-edge admin panel framework, Metis ERP offers an extensible and developer-friendly platform for managing every aspect of your business operations.

Whether you're managing accounting, inventory, HR, CRM, or projects, Metis ERP provides a modular approach that grows with your business.

---

## ✨ Key Features

-   🏗️ **Modern Architecture**: Built with Laravel 13 and FilamentPHP 5 for maximum performance and developer experience
-   🧩 **Modular Plugin System**: Install only the features you need - from accounting to project management
-   🎨 **Beautiful UI/UX**: Responsive design with TailwindCSS 4, optimized for desktop and mobile
-   🔐 **Advanced Security**: Role-based access control with Filament Shield integration
-   📊 **Business Intelligence**: Built-in analytics and reporting tools
-   🌐 **Multi-Language Support**: Easily translate and localize for global businesses
-   ⚡ **High Performance**: Optimized database queries and caching strategies
-    🔧 **Developer-Friendly**: Clean code, comprehensive documentation, and extensive APIs
-   🔄 **Real-Time Updates**: LiveWire 4 integration for dynamic interfaces

---

## 🎯 Why Choose Metis ERP?

| Feature | Benefit |
|---------|---------|
| **Open Source** | Free to use, modify, and extend. No vendor lock-in |
| **Modern Stack** | Latest Laravel & FilamentPHP for cutting-edge features |
| **Scalable** | Handles everything from startups to enterprise operations |
| **Customizable** | Extend with your own plugins and modifications |
| **Community-Driven** | Active community support and continuous improvements |
| **Production-Ready** | Battle-tested with real-world business requirements |

---

## 📦 Requirements

Ensure your development environment meets the following requirements:

### Server Requirements
-   **PHP**: 8.3 or higher
-   **Database**: MySQL 8.0+ or SQLite 3.8.3+
-   **Web Server**: Apache 2.4+ or Nginx 1.18+

### Development Tools
-   **Composer**: Latest version (2.0+)
-   **Node.js**: 18.x or higher
-   **NPM/Yarn**: Latest stable version

### Framework Versions
-   **Laravel**: 13.x
-   **FilamentPHP**: 5.x
-   **Livewire**: 4.x
-   **TailwindCSS**: 4.x

---

## ⚡ Quick Start

### Development (Local / Windows / macOS / Linux)

#### Prerequisites
- **PHP** 8.3+ with extensions: bcmath, ctype, curl, fileinfo, gd, json, mbstring, openssl, pdo, pdo_sqlite, xml, zip
- **Composer** 2.0+ — use the bundled `composer.phar` if not globally installed
- **Node.js** 18+ and **npm**
- **SQLite** (default) or **MySQL** 8.0+

#### Step 1: Clone

```bash
git clone https://github.com/4jeel-cloud/aureuserp.git
cd aureuserp
```

#### Step 2: Install PHP & JS Dependencies

```bash
php composer.phar install
npm install
```

#### Step 3: Configure Environment

```bash
cp .env.example .env
# Edit .env if needed — DB_CONNECTION=sqlite is the default.
# For MySQL, uncomment and set DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD.
```

#### Step 4: Run Installation

```bash
php artisan erp:install --no-interaction \
    --admin-name="Admin" \
    --admin-email="admin@example.com" \
    --admin-password="password"
```

**What happens during installation:**

✅ Database migrations are executed  
✅ Core seeders populate initial data  
✅ Roles & permissions are generated (via Filament Shield)  
✅ Admin account is created  
✅ Storage directory linked

#### Step 5: Start Dev Servers

```bash
# Option A — All at once (server + queue + logs + Vite):
composer dev

# Option B — Manually:
php artisan serve              # → http://127.0.0.1:8000
npm run dev                    # → http://localhost:5173 (Vite hot-reload)
php artisan queue:listen       # Queue worker
php artisan pail               # Log viewer
```

#### Default Credentials

| Email | Password |
|-------|----------|
| `admin@example.com` | `password` |

#### Reinstalling

```bash
php artisan erp:install --force --no-interaction \
    --admin-name="Admin" \
    --admin-email="admin@example.com" \
    --admin-password="password"
```

To skip specific steps, append flags like `--skip-migrations`, `--skip-roles`, `--skip-seeders`, or `--skip-admin`.

---

### Production (Docker)

Build a self-contained production image with MySQL, Nginx, PHP-FPM, queue worker, and scheduler — all managed by Supervisor.

#### Prerequisites
- **Docker** 24+
- **Docker BuildKit** (enabled by default in recent versions)

#### Build the Image

```bash
docker build -f docker/production/Dockerfile -t metis-erp:latest .
```

This builds an Ubuntu 24.04 image containing:
- PHP 8.4-FPM with all required extensions
- Nginx with production config (gzip, caching headers, security headers)
- MySQL 8.0 with a pre-seeded database (initialized at build time)
- Supervisor managing 5 processes: MySQL, PHP-FPM, Nginx, queue worker, scheduler

**Build arguments** (all optional):

| Argument | Default | Description |
|----------|---------|-------------|
| `ADMIN_NAME` | `Administrator` | Admin user display name |
| `ADMIN_EMAIL` | `admin@example.com` | Admin login email |
| `ADMIN_PASSWORD` | `password` | Admin login password |
| `APP_REF` | `master` | Git branch/tag to clone |
| `PHP_VERSION` | `8.4` | PHP version |
| `NODE_VERSION` | `22` | Node.js version |

#### Run with Internal MySQL (default)

The database is baked into the image — no external dependencies:

```bash
docker run -d --name metis-erp \
    -p 80:80 \
    -p 443:443 \
    -e APP_URL=http://localhost \
    metis-erp:latest
```

#### Run with External MySQL (e.g. RDS, Cloud SQL, managed DB)

```bash
docker run -d --name metis-erp \
    -p 80:80 \
    -e DB_HOST=your-db-host.internal \
    -e DB_PORT=3306 \
    -e DB_DATABASE=metis \
    -e DB_USERNAME=metis \
    -e DB_PASSWORD=your-secure-password \
    -e APP_URL=https://your-domain.com \
    -e APP_KEY=base64:your-32-byte-key== \
    metis-erp:latest
```

The entrypoint will:
1. Wait up to 60s for the external MySQL to be reachable
2. Auto-detect if tables exist — if not, run a full installation
3. Generate an `APP_KEY` if none is provided

#### All Runtime Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | `127.0.0.1` | Database host (use external host for managed DB) |
| `DB_PORT` | `3306` | Database port |
| `DB_DATABASE` | `metis` | Database name |
| `DB_USERNAME` | `metis` | Database user |
| `DB_PASSWORD` | `metis` | Database password |
| `APP_ENV` | `production` | Application environment |
| `APP_DEBUG` | `false` | Debug mode (set to `true` for troubleshooting) |
| `APP_URL` | `http://localhost` | Application URL |
| `APP_KEY` | *(auto-generated)* | Laravel app key (32-byte base64) |
| `APP_NAME` | `Metis` | Application display name |
| `APP_LOCALE` | `en` | Default language |
| `APP_CURRENCY` | `USD` | Default currency |
| `APP_TIMEZONE` | `UTC` | Application timezone |

#### Docker Compose (Development)

For local development with Sail (MySQL + Redis + Mailpit):

```bash
cp .env.example .env
# Set DB_CONNECTION=mysql, DB_HOST=mysql, DB_USERNAME=sail, DB_PASSWORD=password
./vendor/bin/sail up -d
./vendor/bin/sail artisan erp:install --no-interaction
```

#### Health Check

The container includes a built-in health endpoint:

```bash
curl http://localhost/health
# → {"status":"healthy","timestamp":"...","checks":{"app":true,"database":true,"cache":true}}
```

The Docker HEALTHCHECK polls this endpoint every 30s (60s grace period, 3 retries). If it fails, the container is marked `unhealthy`.

---

## 🧩 Plugin System

Metis ERP features a powerful modular plugin system that allows you to customize your ERP installation based on your business needs. Choose only the modules you need to keep your system lean and efficient.

### 📦 Core Plugins (System Plugins)

These plugins are essential components of the system and are installed by default:

| Module     | Description                                       |
| ---------- | ------------------------------------------------- |
| Analytics  | Business intelligence and reporting tools         |
| Chatter    | Internal communication and collaboration platform |
| Fields     | Customizable data structure management            |
| Security   | Role-based access control and authentication      |
| Support    | Help desk and documentation                       |
| Table View | Customizable data presentation framework          |

### ⚡ Installable Plugins

These plugins can be installed as needed to extend system functionality:

#### 💼 Financial Management
| Module     | Description                           |
| ---------- | ------------------------------------- |
| Accounting | Financial accounting and reporting    |
| Accounts   | Core accounting operations            |
| Invoices   | Invoice generation and management     |
| Payments   | Payment processing and tracking       |

#### 📦 Operations
| Module        | Description                                                                     |
| ------------- | ------------------------------------------------------------------------------- |
| Inventories   | Inventory and warehouse management                                              |
| Manufacturing | Bill of Materials (BOM), Manufacturing Orders, Work Orders, Work Centers & Operations |
| Products      | Product catalog and management                                                  |
| Purchases     | Procurement and purchase order management                                       |
| Sales         | Sales pipeline and opportunity management                                       |

#### 👥 Human Resources
| Module       | Description                       |
| ------------ | --------------------------------- |
| Employees    | Employee management               |
| Recruitments | Applicant tracking and hiring     |
| Timeoffs     | Leave management and tracking     |
| Timesheet    | Employee work hour tracking       |

#### 🤝 Customer & Partner Management
| Module   | Description                                  |
| -------- | -------------------------------------------- |
| Contacts | Contact management for customers and vendors |
| Partners | Partner relationship management              |

#### 📊 Project & Content Management
| Module   | Description                     |
| -------- | ------------------------------- |
| Blogs    | Content management and blogging |
| Projects | Project planning and management |
| Website  | Customer-facing website module  |

---

## 🔧 Plugin Installation & Management

### Installing a Plugin

To install a plugin, use the following Artisan command:

```bash
php artisan <plugin-name>:install
```

**Example:** Install the Inventories plugin

```bash
php artisan inventories:install
```

During installation, the system automatically checks for dependencies. If dependencies are detected, you'll see:

```
This package products is already installed. What would you like to do? [Skip]:
  [0] Reseed
  [1] Skip
  [2] Show Seeders
```

**Options:**
- **Reseed**: Reinstall the plugin's seed data (overwrites existing data)
- **Skip**: Continue without modifying the already installed dependency
- **Show Seeders**: Display available data seeders for the plugin

### Uninstalling a Plugin

To remove a plugin from your system:

```bash
php artisan <plugin-name>:uninstall
```

**Example:** Uninstall the Inventories plugin

```bash
php artisan inventories:uninstall
```

⚠️ **Warning:** Uninstalling a plugin will remove its database tables and data. Make sure to backup your data before uninstalling.

### Plugin Dependencies

Some plugins require other plugins to function properly. The installation system:
- ✅ Automatically detects dependencies
- ✅ Prompts you to install required plugins
- ✅ Prevents conflicts and missing prerequisites
- ✅ Validates the installation order

---

## 🎨 Customization

Metis ERP is designed to be highly customizable, allowing you to tailor the system to your specific business needs:

### Plugin Customization
- 🔹 Install only the plugins you need
- 🔹 Extend existing plugins with custom functionality
- 🔹 Create custom plugins using the modular architecture

### UI/UX Customization
- 🔹 Create custom dashboards and reports
- 🔹 Modify themes and branding
- 🔹 Design custom forms and views with Filament

### Access Control
- 🔹 Define custom user roles and permissions
- 🔹 Configure role-based access control (RBAC)
- 🔹 Set granular permissions using Filament Shield

### Business Logic
- 🔹 Extend models with custom business rules
- 🔹 Create custom workflows and automations
- 🔹 Integrate with third-party services via APIs

---

## 🤝 Contributing

We welcome contributions from the community! Whether you're fixing bugs, adding features, or improving documentation, your help is appreciated.

### How to Contribute

1. **Fork the Repository**
   ```bash
   git clone https://github.com/4jeel-cloud/aureuserp.git
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing code style and conventions
   - Write tests for new features
   - Update documentation as needed

4. **Commit Your Changes**
   ```bash
   git commit -m "Add: Brief description of your changes"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Submit a Pull Request**
   - Provide a clear description of the changes
   - Reference any related issues
   - Ensure all tests pass

### Development Guidelines
- Follow Laravel and Filament best practices
- Maintain code quality with Laravel Pint: `vendor/bin/pint`
- Write PHPUnit tests for new functionality
- Use meaningful commit messages

---

## 📄 License

Metis ERP is truly open-source ERP framework that will always be **free** under the [MIT License](LICENSE).

### What This Means
- ✅ Free to use for commercial and personal projects
- ✅ Modify and distribute as you wish
- ✅ No licensing fees or restrictions
- ✅ Community-driven development

---

## 🔒 Security

Security is a top priority for Metis ERP. We take all security vulnerabilities seriously.

### Reporting Security Vulnerabilities

**⚠️ Please DO NOT disclose security vulnerabilities publicly.**

If you discover a security vulnerability in Metis ERP, please report it by opening an issue on our GitHub repository:

🐛 **Issue Tracker:** [GitHub Issues](https://github.com/4jeel-cloud/aureuserp/issues)

### What to Include
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if available)

We will acknowledge your report within 48 hours and provide a detailed response within 7 days, including our assessment and a timeline for a fix.

---

## 💬 Support & Community

Need help or want to connect with other Metis ERP users?

### 🤝 Get Support
- 🐛 **Issue Tracker:** [GitHub Issues](https://github.com/4jeel-cloud/aureuserp/issues) - Report bugs and request features

### 🔔 Stay Updated
- ⭐ **Star** this repository to show your support
- 👁️ **Watch** for new releases and updates
- 🍴 **Fork** to contribute to the project

---

<div align="center">

Made with ❤️

[⬆ Back to Top](#-table-of-contents)

</div>
