# Machine Detail Screen — UI/UX Specification

> **Screen ID:** 04  
> **Route:** `/machines/{id}`  
> **Auth Required:** Yes  
> **Parent:** Machine List (tap card)

---

## 1. Purpose

Display comprehensive details for a single machine. Provides QR code access, maintenance history tab, and actionable buttons for work orders.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Back arrow (←)
- Center: Machine name (truncated to 20 chars)
- Right: Overflow menu (⋮) → Edit, Share, Delete

**Hero Section (scrollable header):**
- Machine-type icon (64×64dp, rounded-square with category-colored background)
- Machine name (H3)
- Machine code (Body Medium, Secondary text)
- Status chip (pill, large variant 36dp)
- Location (Body Medium) with `location_on` icon
- Category label (Body Small, Secondary text)

**Info Section (card, 8dp radius):**
- Section header: "Details" (Label Large)
- Key-value rows (Body Medium):
  - "Department" | "Production"
  - "Install Date" | "2024-03-15"
  - "Last Maintenance" | "2026-07-28"
  - "Technician" | "John D."

**QR Code Section (card, centered content):**
- Section header: "QR Code" (Label Large)
- QR code image (120×120dp, centered)
- Machine ID text below: "M-001"
- "Share QR" text button below

**Tab Section:**
- Two tabs: "History" | "Work Orders"
- Tab bar: 2 equal-width tabs with indicator line
- **History tab:** Timeline list of last 5 maintenance events (same design as Dashboard timeline)
- **Work Orders tab:** List of associated work orders (compact WO cards)

**Action Buttons (sticky bottom bar):**
- "📋 Start Task" (Filled button, half width)
- "⚠️ Report Breakdown" (Outlined button, half width, Error color)

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ←  Filling Machine-01       ⋮    │  ← App bar
├──────────────────────────────────┤
│    ┌──────────┐                  │
│    │  ⚙️      │  Filling Machi-01│  ← Hero section
│    └──────────┘  FM-01           │
│                  ✅ Operational  │
│                  📍 Line A, FL1   │
│                  Category: Filling│
│                                  │
│  ┌────────────────────────────┐  │
│  │ Details                    │  │  ← Info card
│  │ Department    │ Production │  │
│  │ Install Date  │ 2024-03-15 │  │
│  │ Last Maint.   │ 2026-07-28 │  │
│  │ Technician    │ John D.    │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ QR Code                    │  │
│  │                            │  │
│  │       ██▀▀▀▀██▀▀▀▀██       │  │  ← QR code (120×120dp)
│  │       ██▄▄▄▄██▄▄▄▄██       │  │
│  │                            │  │
│  │           M-001            │  │
│  │        [ Share QR ]        │  │
│  └────────────────────────────┘  │
│                                  │
│  [ History ]  [ Work Orders ]    │  ← Tab bar
│  ───────                           │
│  ● Replace nozzle seal  ── Jul 28 │  ← Timeline
│  ● Seal inspection      ── Jul 28 │
│  ● Pressure test        ── Jul 25 │
│                                  │
├──────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────┐ │  ← Sticky action bar
│ │ 📋 Start Task   │ │ ⚠️ Rpt  │ │
│ │                 │ │Brkdown  │ │
│ └─────────────────┘ └─────────┘ │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Back arrow | Icon button | Pop back to Machine List |
| Overflow menu | Icon button | Dropdown: Edit, Share, Delete (with confirmation dialog) |
| QR code image | Image | Opens full-screen QR scanner view |
| Share QR | Text button | Shares machine ID via Android share sheet |
| History tab | Tab | Shows timeline of maintenance events |
| Work Orders tab | Tab | Shows list of associated WOs |
| Timeline card (tap) | Card | Navigate to Maintenance History filtered by this machine |
| Work order card (tap) | Card | Navigate to Work Order Detail |
| Start Task button | Filled button | Navigate to Checklist Form for this machine |
| Report Breakdown button | Outlined button | Navigate to Breakdown Report pre-filled with this machine |

---

## 5. States

### 5.1 Loading State

- Skeleton for hero section (64dp circle + 3 lines)
- Skeleton info card (2 lines)
- Skeleton QR placeholder (120dp square shimmer)
- Tab content skeleton (3 timeline items)
- Action buttons disabled until loaded

### 5.2 Empty State (History Tab)

- Icon: `history` (80dp, 40% opacity)
- Title: "No Maintenance History"
- Description: "History will appear once maintenance tasks are completed."

### 5.3 Empty State (Work Orders Tab)

- Icon: `assignment` (80dp, 40% opacity)
- Title: "No Work Orders"
- Description: "Create a work order to begin tracking maintenance."
- CTA: "Create Work Order" (text button)

### 5.4 Error State

- Snackbar on load failure: "Couldn't load machine details."
- Tab-specific retry: Each tab has individual retry if history or WO list fails
- Full reload on pull-to-refresh

### 5.5 Happy Path

1. User taps Filling Machine-01 from list
2. Hero section shows FM-01 with green Operational chip
3. Info card shows department, install date, last maintenance date
4. QR code displays valid machine code
5. History tab shows 3 timeline events
6. User taps "Start Task" → navigates to Checklist Form (machine pre-selected)
7. User navigates back via back arrow

---

## 6. Technical Notes

- Data from `/api/machines/{id}`
- History from `/api/machines/{id}/history`
- Work orders from `/api/machines/{id}/work-orders`
- QR code generated client-side using QR library from machine ID
- Action buttons navigate with `machineId` as parameter
