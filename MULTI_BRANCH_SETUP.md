# Multi-Branch Shop Architecture

How **Metis ERP** handles a **5–6 branch retail shop** with **multiple computers per branch**, **different roles**, and **one HQ admin** overseeing all locations.

---

## Table of contents

1. [Big picture](#1-big-picture--one-erp-all-branches-online)
2. [Organization chart](#2-organization-chart)
3. [Inside one branch](#3-inside-one-branch--multiple-computers-different-jobs)
4. [Bill flow](#4-bill-flow--make-bill-elsewhere--pay-at-main-desk)
5. [Branch separation in ERP](#5-branch-separation-in-the-erp)
6. [Full system map](#6-full-system-map-6-branches--multiple-pcs)
7. [Role × module matrix](#7-role--module-matrix)
8. [Implementation checklist](#8-implementation-checklist)
9. [Real-world notes](#9-real-world-notes)
10. [Summary](#10-summary)

---

## 1. Big picture — one ERP, all branches online

```text
                    ┌─────────────────────────────────────────┐
                    │         YOUR ERP SERVER (CLOUD/HQ)       │
                    │  4jeel ERP  •  One database  •  One URL   │
                    │  https://erp.yourcompany.com            │
                    └────────────────────┬────────────────────┘
                                         │
           ┌─────────────────────────────┼─────────────────────────────┐
           │                             │                             │
           ▼                             ▼                             ▼
    ┌─────────────┐              ┌─────────────┐              ┌─────────────┐
    │  BRANCH 1   │              │  BRANCH 2   │     ...      │  BRANCH 6   │
    │  (Browser)  │              │  (Browser)  │              │  (Browser)  │
    └─────────────┘              └─────────────┘              └─────────────┘

  Each PC = Chrome/Edge only.  NO ERP installed on each computer.
```

This is a **web-based** system. Every computer only needs a browser and network access to the server.

---

## 2. Organization chart

```text
                         ┌──────────────────────┐
                         │   MAIN ADMIN (HQ)    │
                         │  • All branches      │
                         │  • All reports       │
                         │  • Users & settings  │
                         │  • Company policy    │
                         └──────────┬───────────┘
                                    │
        ┌───────────┬───────────┬───┴───┬───────────┬───────────┐
        ▼           ▼           ▼       ▼           ▼           ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐     ┌─────────┐ ┌─────────┐
   │Branch 1 │ │Branch 2 │ │Branch 3 │ ... │Branch 5 │ │Branch 6 │
   │ Manager │ │ Manager │ │ Manager │     │ Manager │ │ Manager │
   └────┬────┘ └────┬────┘ └────┬────┘     └────┬────┘ └────┬────┘
        │           │           │               │           │
   Staff PCs    Staff PCs    Staff PCs       Staff PCs    Staff PCs
   (roles)      (roles)      (roles)         (roles)      (roles)
```

### Role overview

| Role | Typical access |
|------|----------------|
| **Main Admin (HQ)** | All branches, all modules, user management, consolidated P&L |
| **Branch Manager** | Own branch only — sales, stock, staff, daily reports |
| **Main desk / Cashier** | Create invoice, **collect payment**, close sale, print receipt |
| **Billing clerk** | Create quotation/order/invoice — often **without** final payment |
| **Accountant** | Journals, expenses, bank, reports — **no** casual sales edits |
| **Warehouse / stock** | Stock in/out, transfers (if separate PC) |

Roles are configured in ERP using **Filament Shield** (permissions per user).

---

## 3. Inside one branch — multiple computers, different jobs

Example: **Branch 3** with 6 computers

```text
  BRANCH 3  (Warehouse/Location = "Branch 3" in ERP)
  ═══════════════════════════════════════════════════════════════

  ┌──────────────────── MAIN DESK (Front PC) ────────────────────┐
  │  Role: Cashier / Main Billing                                 │
  │  • Open pending bills from other PCs                          │
  │  • Collect cash / card / transfer                             │
  │  • Register payment → invoice PAID                            │
  │  • Print receipt for customer                                 │
  └───────────────────────────────────────────────────────────────┘
           ▲                    ▲                    ▲
           │ send bill          │ send bill          │ send bill
           │ (unpaid)           │ (unpaid)           │ (unpaid)
  ┌────────┴──────┐    ┌────────┴──────┐    ┌────────┴──────┐
  │  Billing PC 2 │    │  Billing PC 3 │    │  Billing PC 4 │
  │  Role: Sales  │    │  Role: Sales  │    │  Role: Sales  │
  │  • Add items  │    │  • Add items  │    │  • Add items  │
  │  • Create     │    │  • Create     │    │  • Create     │
  │    invoice    │    │    invoice    │    │    invoice    │
  │  • Status:    │    │  • Status:    │    │  • Status:    │
  │    UNPAID /   │    │    UNPAID /   │    │    UNPAID /   │
  │    "To pay at │    │    "To pay at │    │    "To pay at │
  │     main desk"│    │     main desk"│    │     main desk"│
  └───────────────┘    └───────────────┘    └───────────────┘

  ┌──────────────── BACK OFFICE ────────────────────────────────┐
  │  Accounting PC 1 & 2                                          │
  │  Role: Branch Accountant                                      │
  │  • Expenses, supplier bills, bank reconciliation              │
  │  • Branch P&L, tax reports                                    │
  │  • Cannot delete paid invoices (manager/admin only)           │
  └───────────────────────────────────────────────────────────────┘

  ┌──────────────── BRANCH MANAGER PC ────────────────────────────┐
  │  Role: Branch Manager                                         │
  │  • Approve discounts / returns                                │
  │  • Daily sales & stock for Branch 3 only                      │
  │  • Manage branch users (optional)                             │
  └───────────────────────────────────────────────────────────────┘
```

The same layout repeats at **Branch 1, 2, 4, 5, and 6**.

---

## 4. Bill flow — “make bill elsewhere → pay at main desk”

```text
  SALES PC (any billing counter)          MAIN DESK PC (cashier)
  ─────────────────────────────          ─────────────────────────

  1. Customer selects items
  2. Create Sales Order / Invoice
  3. Save as UNPAID  ──────────────────►  4. Cashier sees "Pending payments"
     (linked to Branch 3                      or invoice list filtered
      warehouse)                              by branch + unpaid)

                                          5. Customer comes to main desk
                                          6. Cashier opens that invoice
                                          7. Register Payment
                                          8. Invoice = PAID
                                          9. Print receipt
                                          10. Stock reduced (if configured)
```

### ERP modules involved

| Step | Module |
|------|--------|
| Products & pricing | **Products** |
| Stock per branch | **Inventories** |
| Orders / quotations | **Sales** |
| Customer bill | **Invoices** |
| Cash / card collection | **Payments** |
| Books & reports | **Accounting** |

---

## 5. Branch separation in the ERP

```text
  ONE COMPANY (client business)
  │
  ├── Company settings (name, logo, tax ID)
  │
  ├── Branch 1  →  Warehouse/Location "Branch 1"  →  stock for Branch 1 only
  ├── Branch 2  →  Warehouse/Location "Branch 2"
  ├── Branch 3  →  Warehouse/Location "Branch 3"
  ├── ...
  └── Branch 6  →  Warehouse/Location "Branch 6"

  Users are tied to:
    • Role        (what they can do)
    • Branch /    (what data they see — configure and test)
      warehouse
```

| User type | Data visibility |
|-----------|-----------------|
| **HQ Admin** | All branches |
| **Branch Manager** | Own branch only |
| **Branch staff** | Own branch only (sales, stock, etc.) |

Configure warehouse defaults and permissions so Branch A staff cannot see Branch B sales.

---

## 6. Full system map (6 branches × multiple PCs)

```text
                              HQ
                    ┌─────────────────┐
                    │   MAIN ADMIN    │
                    │  Reports: all   │
                    │  Users: all     │
                    └────────┬────────┘
                             │
     ┌───────────────────────┼───────────────────────┐
     │                       │                       │
     ▼                       ▼                       ▼
┌─────────┐            ┌─────────┐            ┌─────────┐
│Branch 1 │            │Branch 2 │     ...    │Branch 6 │
├─────────┤            ├─────────┤            ├─────────┤
│Manager  │            │Manager  │            │Manager  │
│Main desk│            │Main desk│            │Main desk│  ← pay & receipt
│Sales x2 │            │Sales x2 │            │Sales x2 │  ← create unpaid bills
│Acct x2  │            │Acct x2  │            │Acct x2  │  ← bookkeeping
└────┬────┘            └────┬────┘            └────┬────┘
     │                      │                      │
     └──────────────────────┴──────────────────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │   SINGLE ERP DATABASE   │
              │  • Sales per branch     │
              │  • Stock per branch     │
              │  • Consolidated accounts│
              └─────────────────────────┘
```

---

## 7. Role × module matrix

```text
                    │ Sales │ Invoice │ Payment │ Stock │ Accounting │ All branches
────────────────────┼───────┼─────────┼─────────┼───────┼────────────┼─────────────
Main Admin (HQ)     │  ✓    │   ✓     │   ✓     │  ✓    │     ✓      │      ✓
Branch Manager      │  ✓    │   ✓     │   ✓     │  ✓    │  ✓ (branch)│   own only
Main desk Cashier   │  ✓    │   ✓     │   ✓     │ view  │     ✗      │   own only
Billing clerk       │  ✓    │   ✓     │   ✗     │ view  │     ✗      │   own only
Branch accountant   │ view  │  view   │  view   │ view  │  ✓ (branch)│   own only
```

**Legend:** ✓ = full access · view = read only · ✗ = no access

---

## 8. Implementation checklist

```text
  SETUP ORDER
  ───────────
  1. Create company + upload logo
  2. Create 5–6 warehouses (one per branch)
  3. Create users (one login per person recommended)
  4. Assign roles via Filament Shield
  5. Install plugins: Products, Inventories, Sales, Invoices, Payments, Accounting
  6. Define workflow: unpaid invoice → main desk payment
  7. Test: Branch A cannot see Branch B sales
  8. Train staff: billing PCs never take payment; main desk only
```

### Install required plugins (CLI)

```bash
php artisan products:install
php artisan inventories:install
php artisan sales:install
php artisan invoices:install
php artisan payments:install
php artisan accounting:install
```

### Suggested role names to create

| Role name | Assigned to |
|-----------|-------------|
| `HQ Admin` | Company owner / IT |
| `Branch Manager` | One per branch |
| `Cashier` | Main desk PC users |
| `Billing Clerk` | Secondary billing counters |
| `Branch Accountant` | Back-office bookkeeping |

---

## 9. Real-world notes

| Topic | Recommendation |
|--------|----------------|
| **Internet** | Each branch needs a stable connection to the ERP server |
| **One login per staff** | Better audit trail than sharing one “billing” user on multiple PCs |
| **Main desk** | Designate one physical counter as the official payment point |
| **Stock** | Each branch warehouse holds its own quantity |
| **Transfers** | HQ can move stock between branches inside ERP |
| **Reports** | Branch manager = daily branch report; HQ admin = all branches + totals |
| **Server** | One central server (4 vCPU, 8 GB RAM is a good starting point for ~30 users) |
| **Backups** | Daily database + `storage/` backups |

---

## 10. Summary

```text
  All branches → same website → same database;
  each branch = own warehouse + own users/roles;
  sales PCs create bills → main desk PC collects money;
  HQ admin + branch managers oversee their scope.
```

---

## Related docs

- [CHANGE.md](./CHANGE.md) — Reskin and productization checklist
- [README.md](./README.md) — Metis ERP documentation
