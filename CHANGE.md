# Reskin & Productization Checklist — Metis

Complete guide for turning the **Aureus ERP** fork into your **Metis** product.

Use this file as a working checklist. Tick items as you complete them.

---

## Table of contents

1. [Before you change anything](#1-before-you-change-anything)
2. [Phase 1 — Environment & global app identity](#2-phase-1--environment--global-app-identity)
3. [Phase 2 — Logos, favicon & visual assets](#3-phase-2--logos-favicon--visual-assets)
4. [Phase 3 — Filament admin & customer panels](#4-phase-3--filament-admin--customer-panels)
5. [Phase 4 — Customer-facing text & translations](#5-phase-4--customer-facing-text--translations)
6. [Phase 5 — Remove upstream branding & telemetry](#6-phase-5--remove-upstream-branding--telemetry)
7. [Phase 6 — Email, PDFs & documents](#7-phase-6--email-pdfs--documents)
8. [Phase 7 — Package metadata & docs](#8-phase-7--package-metadata--docs)
9. [Phase 8 — Product improvements (commercial value)](#9-phase-8--product-improvements-commercial-value)
10. [Phase 9 — Multi-branch client setup](#10-phase-9--multi-branch-client-setup)
11. [Phase 10 — Production deployment](#11-phase-10--production-deployment)
12. [Phase 11 — QA before go-live](#12-phase-11--qa-before-go-live)
13. [What NOT to rename](#13-what-not-to-rename)
14. [Find remaining upstream references](#14-find-remaining-upstream-references)
15. [Upstream sync strategy](#15-upstream-sync-strategy)

---

## 1. Before you change anything

- [x] **Pick your product name** — Metis
- [ ] **Trademark search** for "Metis" and domain
- [ ] **Keep `LICENSE`** — MIT requires retaining copyright notice in distributed code
- [ ] **Add `THIRD_PARTY_LICENSES.md`** — credit Aureus ERP / Webkul as the upstream base
- [ ] **Register Git remote** — set your own as origin, keep upstream for sync
- [ ] Create a `rebrand` Git branch for all cosmetic changes (easier to merge upstream later)

---

## 2. Phase 1 — Environment & global app identity

| File | What to change | Status |
|------|----------------|--------|
| `.env` | `APP_NAME="Metis"` | ✅ Done |
| `.env` | `APP_URL` for production | ❌ Pending (set when deploying) |
| `.env` | `APP_TIMEZONE=Asia/Kolkata` | ✅ Done |
| `.env` | `APP_CURRENCY=INR` | ✅ Done |
| `.env` | `MAIL_FROM_ADDRESS`, `MAIL_FROM_NAME="Metis Support"` | ✅ Done |
| `.env.example` | Already has Metis defaults | ✅ Done |
| `config/app.php` | No changes needed (uses env vars) | ✅ Done |

**After any env changes:**

```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
```

---

## 3. Phase 2 — Logos, favicon & visual assets

### Logo files placed in `public/images/`

| File | Used for | Status |
|------|---------|--------|
| `public/images/logo.svg` | Admin login, top nav, customer panel | ✅ Done (check actual content is Metis logo) |
| `public/images/logo-light.png` | Light theme logo in panels | ✅ Done |
| `public/images/logo-dark.png` | Dark theme logo in panels | ✅ Done |
| `public/images/logo-full-light.svg` | Full light logo | ✅ Done |
| `public/images/logo-full-dark.svg` | Full dark logo | ✅ Done |
| `public/images/favicon.ico` | Browser tab icon | ✅ Done |
| `public/images/favicon.png` | Browser tab icon (PNG) | ✅ Done |

### Filament panel config

| File | Status |
|------|--------|
| `app/Providers/Filament/AdminPanelProvider.php` — logo paths, favicon, primary color (`#E31E24`) | ✅ Done |
| `app/Providers/Filament/CustomerPanelProvider.php` — logo paths, favicon, primary color | ✅ Done |

### PDF / cache logo

| File | What to change | Status |
|------|----------------|--------|
| `plugins/webkul/support/src/Http/Controllers/ImageCacheController.php` | Replaced remote Aureus logo with local `images/logo-light.png` | ✅ Done |
| `plugins/webkul/support/src/Traits/HasFilamentDefaults.php` | Updated version `1.4.0` → `1.0.0` | ✅ Done |

---

## 4. Phase 3 — Filament admin & customer panels

| File | Status |
|------|--------|
| `app/Providers/Filament/AdminPanelProvider.php` — logo, favicon, primary color | ✅ Done |
| `app/Providers/Filament/CustomerPanelProvider.php` — logo, favicon, primary color | ✅ Done |
| `resources/views/vendor/filament-panels/livewire/topbar.blade.php` — no upstream references | ✅ Done |
| `resources/views/vendor/filament-panels/livewire/sidebar.blade.php` — no upstream references | ✅ Done |
| `resources/views/filament/components/language-switcher.blade.php` — no upstream references | ✅ Done |
| `resources/views/filament/components/auth-language-switcher.blade.php` — no upstream references | ✅ Done |
| `plugins/webkul/website/resources/views/filament/customer/footer/index.blade.php` — removed aureuserp.com & webkul.com links | ✅ Done |
| `tailwind.config.js` — brand-neutral (Figtree font, no branding) | ✅ Done |
| `resources/css/app.css` — RTL styles only, no branding | ✅ Done |

---

## 5. Phase 4 — Customer-facing text & translations

| File | What to change | Status |
|------|----------------|--------|
| `lang/en/welcome.php` | Replaced "AureusERP" with "Metis" | ✅ Done |
| `lang/ar/welcome.php` | Replaced "AureusERP" with "Metis" | ✅ Done |
| `plugins/webkul/website/resources/lang/en/filament/app.php` | Replaced "Aureus ERP" with "Metis" | ✅ Done |
| `plugins/webkul/website/resources/lang/ar/filament/app.php` | Replaced "Aureus ERP" with "Metis" | ✅ Done |
| `plugins/webkul/accounts/resources/lang/en/enums/communication-standard.php` | `'aureus' => 'Aureus'` → `'Standard'` | ✅ Done |
| `lang/en/admin.php` | No Aureus references found | ✅ Done |
| `lang/ar/admin.php` | No Aureus references found | ✅ Done |

Search all lang files:

```bash
rg -i "aureus|webkul" lang/ plugins/*/resources/lang/
```

---

## 6. Phase 5 — Remove upstream branding & telemetry

| File | What to change | Status |
|------|----------------|--------|
| `plugins/webkul/plugin-manager/src/Listeners/Installer.php` | Disabled phone-home telemetry | ✅ Done |
| `plugins/webkul/plugin-manager/src/Console/Commands/InstallERP.php` | "Metis is successfully installed" | ✅ Done |
| `plugins/webkul/plugin-manager/src/Console/Commands/InstallERP.php` | GitHub star link → `4jeel-cloud/aureuserp` | ✅ Done |
| `plugins/webkul/support/src/Http/Controllers/ImageCacheController.php` | Now serves local `images/logo-light.png` instead of remote | ✅ Done |
| `resources/views/scribe/index.blade.php` | "Metis API Documentation" | ✅ Done |

Regenerate API docs after rebrand:

```bash
php artisan scribe:generate
```

---

## 7. Phase 6 — Email, PDFs & documents

| File / Item | Status |
|-------------|--------|
| Mail `.env` config (from address, from name) | ✅ Done |
| Email templates — no upstream references found in any Blade views | ✅ Done |
| `plugins/webkul/support/src/Traits/PDFHandler.php` — brand-neutral generic trait | ✅ Done |
| Company record in admin UI — set real business name, logo, tax ID | ❌ Pending |

Search email templates:

```bash
rg -i "aureus|webkul" resources/views plugins/*/resources/views --glob "*.blade.php"
```

---

## 8. Phase 7 — Package metadata & docs

| File | What to change | Status |
|------|----------------|--------|
| `composer.json` | Updated name, description, support URLs | ✅ Done |
| `package.json` | No Aureus references found | ✅ Done |
| `README.md` | Replaced with Metis branding | ✅ Done |
| `CHANGELOG.md` | Added Metis header at top | ✅ Done |
| `AGENTS.md` | No Aureus references found | ✅ Done |
| `MULTI_BRANCH_SETUP.md` | Updated references | ✅ Done |
| `CODE_OF_CONDUCT.md` | No Aureus references found | ✅ Done |

### Plugin composer.json files (26 files)

Every `plugins/webkul/*/composer.json` has `"name": "Aureus ERP"` and `"email": "support@aureuserp.in"` in authors — cosmetic, batch update:

Affected plugins:
- accounts, accounting, analytics, blogs, chatter, contacts, employees, fields, full-calendar, inventories, invoices, maintenance, manufacturing, partners, payments, plugin-manager, products, projects, purchases, recruitments, sales, security, support, table-views, time-off, timesheets, website

| Item | Status |
|------|--------|
| Rebrand author name in all plugin composer.json files | ✅ Done (26 plugins, "Aureus ERP" → "Metis", "support@aureuserp.in" → "ajeelajeel99@gmail.com") |

### Docker / production files

| File | Status |
|------|--------|
| `docker/production/Dockerfile` — fully rebranded (paths, DB names, config names) | ✅ Done |
| `docker/production/README.md` — fully rebranded | ✅ Done |
| `docker/production/build-install.sh` — updated messages | ✅ Done |
| `docker/production/entrypoint.sh` — app dir, log prefix, DB defaults | ✅ Done |
| `docker/production/nginx.conf` — root path | ✅ Done |
| `docker/production/supervisord.conf` — queue paths | ✅ Done |
| `docker/production/mysql-init.sql` — DB name, user | ✅ Done |
| `docker/production/php-fpm.conf` — log path | ✅ Done |
| `docker-compose.yml` — no Aureus references (Laravel Sail default) | ✅ N/A |

### GitHub files

| File | Status |
|------|--------|
| `.github/workflows/docker_publish.yml` — rebranded labels, image name | ✅ Done |
| `.github/workflows/pest_tests.yml` — rebranded step name + DB name | ✅ Done |
| `.github/workflows/playwright_tests.yml` — rebranded job name + DB names | ✅ Done |
| `.github/ISSUE_TEMPLATE/feature_request.yml` — rebranded | ✅ Done |
| `.github/ISSUE_TEMPLATE/bug_report.md` — rebranded | ✅ Done |
| `.github/ISSUE_TEMPLATE/bug.yml` — rebranded | ✅ Done |

### Test files

| File | Status |
|------|--------|
| `tests/e2e-pw/package.json` — "Metis ERP" description | ✅ Done |

### Legal pages (defer until business is registered)

- [ ] `Terms of Service` — deferred (business not registered yet)
- [ ] `Privacy Policy` — deferred
- [ ] `Support SLA` or support page URL — deferred
- [ ] `THIRD_PARTY_LICENSES.md` — deferred

---

## 9. Phase 8 — Product improvements (commercial value)

### Must-have for paying clients

- [ ] **Hosted deployment** — one server, HTTPS, backups
- [ ] **Onboarding wizard** — company, currency, fiscal year, first admin
- [ ] **Role templates** — Branch Manager, Cashier, Accountant, HQ Admin
- [ ] **Backup script** — daily DB + `storage/` snapshot
- [ ] **Update process** — staging → production with migration runbook
- [ ] **Support channel** — email, ticket system, or WhatsApp (your choice)
- [ ] **User documentation** — even 10–20 pages PDF beats none

### Install business modules per client

```bash
php artisan inventories:install
php artisan sales:install
php artisan purchases:install
php artisan invoices:install
php artisan accounting:install
php artisan employees:install
# etc.
```

### Optional SaaS layer (your custom code)

- [ ] Signup + billing (Stripe)
- [ ] Per-customer database or tenant ID column
- [ ] Super-admin dashboard for your company
- [ ] License key / subscription check (your private package)

### Country-specific compliance (often custom)

- [ ] Tax rules / VAT
- [ ] Invoice numbering format
- [ ] E-invoicing integration
- [ ] Payroll rules (if using HR module)

---

## 10. Phase 9 — Multi-branch client setup

### Architecture

- [ ] **One central ERP server** — all branches use browser only
- [ ] **Do not install ERP on each PC**
- [ ] **Stable internet** or HQ-hosted server + VPN

### Configuration inside ERP

- [ ] Create **one warehouse/location per branch** (Inventories module)
- [ ] Create **users per branch** with Filament Shield roles
- [ ] Restrict branch users to their warehouse (test thoroughly)
- [ ] HQ roles can view **consolidated** reports
- [ ] Set **company logo & legal info** once at HQ company record

### Server sizing (starting point)

| Resource | Recommendation |
|----------|----------------|
| CPU | 4 vCPU |
| RAM | 8 GB |
| DB | MySQL 8 |
| Cache | Redis |
| Storage | SSD + daily backups |

---

## 11. Phase 10 — Production deployment

### Pre-deploy commands

```bash
composer install --no-dev --optimize-autoloader
npm ci && npm run build
php artisan migrate --force
php artisan config:cache
php artisan view:cache
php artisan storage:link
```

### Web server

- Nginx or Apache → `public/` as document root
- PHP 8.3+ with: `openssl`, `mbstring`, `pdo_mysql`, `fileinfo`, `curl`, `zip`, `gd`, `intl`
- Queue worker: `php artisan queue:work`
- Scheduler cron: `* * * * * php /path/to/artisan schedule:run`

### Security hardening

- [ ] `APP_DEBUG=false`
- [ ] Strong admin password + MFA (built into Filament)
- [ ] Firewall — only 80/443 public
- [ ] Remove or protect `public/adminer.php` if not needed
- [ ] Regular `composer audit` and Laravel security updates

---

## 12. Phase 11 — QA before go-live

### Visual / brand

- [ ] Admin login page — your logo and colors
- [ ] Customer portal login — your logo
- [ ] Browser tab title and favicon
- [ ] Email "from" name shows your product
- [ ] PDF invoice shows client company logo (not Aureus)
- [ ] Footer has **no** aureuserp.com or webkul.com links
- [ ] Mobile layout acceptable on tablet/phone

### Functional smoke test

- [ ] Create product → purchase → receive stock → sale → invoice → payment
- [ ] Branch stock isolation (if multi-branch)
- [ ] User permissions (cashier cannot access accounting)
- [ ] Password reset email works
- [ ] Backup restore tested once

### Search for leftover upstream strings

```bash
rg -i "aureus|aureuserp|webkul\.com|updates\.aureuserp" --glob "!vendor/**" --glob "!node_modules/**" --glob "!CHANGELOG.md"
```

---

## 13. What NOT to rename

These are **internal PHP namespaces** — renaming breaks the app and upstream merges:

- `Webkul\` namespace in `plugins/webkul/*`
- Plugin directory names under `plugins/webkul/`
- Database table prefixes and migration class names
- Composer package paths in `composer.json` merge plugin config

Only change **user-visible strings**, assets, URLs, and your own new packages (e.g. `plugins/metis/`).

---

## 14. Find remaining upstream references

Run from project root:

```powershell
# User-visible branding
rg -i "aureus|aureuserp|webkul\.com" . --glob "!vendor/**" --glob "!node_modules/**" --glob "!storage/**" --glob "!bootstrap/cache/**"

# Logo/asset paths
rg "logo\.svg|favicon|cache/logo" app config public resources plugins --glob "!vendor/**"

# Telemetry endpoints
rg "updates\.aureuserp" . --glob "!vendor/**"
```

---

## 15. Upstream sync strategy

Keep getting bugfixes from Aureus without losing your brand:

```bash
git remote add upstream https://github.com/aureuserp/aureuserp.git
git fetch upstream
git checkout main
git merge upstream/master
# Resolve conflicts — usually in files you rebranded (logo paths, lang files, footer)
```

**Minimize merge pain:**

1. Keep rebranding in **few files** where possible (`.env`, logos, lang files, footer blade)
2. Put **new commercial features** in `plugins/metis/` or `app/` — not scattered edits
3. Document your custom patches in `PATCHES.md`

---

## Quick priority order (first week)

| Day | Task |
|-----|------|
| 1 | ✅ `.env` APP_NAME, logos in `public/images/`, panel primary color |
| 2 | ✅ Footer blade + `lang/en/welcome.php` + website lang files |
| 3 | ✅ Disable `Installer.php` telemetry; fix `ImageCacheController` logo |
| 4 | ❌ Company record in admin — real name, logo, currency |
| 5 | ❌ Install modules client needs; create roles and test one full workflow |
| 6 | ✅ Write your README + basic user guide |
| 7 | ❌ Deploy to staging server; client UAT |

---

## Local install reference (this machine)

The ERP is installed in: `c:\Users\ajeel\OneDrive\Desktop\erp`

| Item | Value |
|------|-------|
| URL | http://127.0.0.1:8000 |
| Admin panel | http://127.0.0.1:8000/admin |
| Admin email | `admin@4jeel.local` |
| Admin password | `password123` |
| Database | SQLite (`database/database.sqlite`) |
| PHP | 8.3.31 (required — not XAMPP 8.2) |

### Start dev server

```bash
cd c:\Users\ajeel\OneDrive\Desktop\erp
php artisan serve
```

### Reinstall from scratch

```bash
del database\database.sqlite
New-Item -ItemType File database\database.sqlite
php artisan erp:install --force --admin-name="Admin" --admin-email="admin@4jeel.local" --admin-password="password123" --no-interaction
```

---

*Upstream base: [aureuserp/aureuserp](https://github.com/aureuserp/aureuserp) (MIT). Product: Metis.*
