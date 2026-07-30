# Work Order List Screen — UI/UX Specification

> **Screen ID:** 05  
> **Route:** `/work-orders`  
> **Auth Required:** Yes  
> **Bottom Nav Tab:** 3 of 4

---

## 1. Purpose

Display all work orders with tab-based filtering by status. Allows users to quickly find, create, and manage work orders.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Back arrow or hamburger
- Center: "Work Orders"
- Right: Add icon (+) → Create new work order

**Status Tab Bar (below app bar, sticky):**
- 5 scrollable tabs (equal width, 40dp height):
  - "All" (4)
  - "Pending" (2)
  - "In Progress" (1)
  - "Overdue" (1)
  - "Completed" (1)
- Active tab indicator: Primary color underline (3dp)
- Tab label shows count badge in parenthesis

**Work Order List (ScrollView):**
- Pull-to-refresh enabled
- Each WO Card (104dp):
  - **Top row:** WO ID (Body Small, Bold, Primary) | Status Chip (pill)
  - **Middle row:** Task Title (Body Large, Bold, truncate to 30 chars)
  - **Bottom row:** Priority badge (small chip) | Machine name (Body Small) | Due date (Body Small)

**Priority Badge Styles:**
| Priority | Color |
|---|---|
| Critical | `#D32F2F` red, bold |
| High | `#F57F17` orange |
| Medium | `#1565C0` blue |
| Low | `#757575` grey |

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ←  Work Orders             +    │  ← App bar (+, add WO)
├──────────────────────────────────┤
│ All(4) Pend(2) Prog(1) Ovr(1) Cmp(1)│ ← Tab bar (scrollable)
│──────────────────────────────────│
│                                  │
│ ┌─────────────────────────────┐  │
│ │ WO-001   Replace nozzle... ●│  │  ← WO Card
│ │ CRITICAL · Filling Machine   │  │  ← "In Progress" blue chip
│ │ Due: 2026-08-02          >  │  │
│ └─────────────────────────────┘  │
│                                  │
│ ┌─────────────────────────────┐  │
│ │ WO-002   Pressure valve ... ○│  │  ← "Pending" yellow chip
│ │ MEDIUM · Boiler-02            │  │
│ │ Due: 2026-08-05          >  │  │
│ └─────────────────────────────┘  │
│                                  │
│ ┌─────────────────────────────┐  │
│ │ WO-003   Emergency: Over... ✕│  │  ← "Overdue" red chip
│ │ CRITICAL · Compressor-03      │  │
│ │ Due: 2026-07-28          >  │  │
│ └─────────────────────────────┘  │
│                                  │
│ ┌─────────────────────────────┐  │
│ │ WO-004   Belt tension ad... ✓│  │  ← "Completed" green chip
│ │ LOW · Conveyor-04             │  │
│ │ Due: 2026-07-29          >  │  │
│ └─────────────────────────────┘  │
│                                  │
│ ┌─────────────────────────────┐  │
│ │ WO-005   Oil change & fi... ○│  │  ← "Pending" yellow chip
│ │ MEDIUM · Generator-05         │  │
│ │ Due: 2026-08-10          >  │  │
│ └─────────────────────────────┘  │
│                                  │
├──────────────────────────────────┤
│  📊  🏭  📋  👤                   │  ← Bottom nav (WO active)
│ Dash Mach  WO  Profile           │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Add button (+) | Icon button | Navigate to "Create Work Order" form |
| Tab (All) | Tab | Show all work orders |
| Tab (Pending) | Tab | Filter to pending |
| Tab (In Progress) | Tab | Filter to in-progress |
| Tab (Overdue) | Tab | Filter to overdue (red indicator if >0) |
| Tab (Completed) | Tab | Filter to completed |
| WO Card (tap) | Card | Navigate to Work Order Detail |
| Status chip | Chip (display) | Non-interactive |
| Pull-to-refresh | Gesture | Reload all work orders |
| Bottom nav (WO) | Tab | Scroll to top (already active) |

---

## 5. States

### 5.1 Loading State

- 5 skeleton cards (shimmer rectangles 104dp each)
- Tab badges show "..." while loading counts
- Pull-to-refresh spinner at top

### 5.2 Empty State (for any tab)

```
┌──────────────────────────────────┐
│                                  │
│      📋 (120×120dp, 40% op.)     │
│                                  │
│      No Work Orders              │
│   There are no work orders in    │
│   this status. Create one to     │
│   get started.                   │
│                                  │
│    ┌────────────────────────┐    │
│    │   Create Work Order    │    │  ← CTA
│    └────────────────────────┘    │
│                                  │
└──────────────────────────────────┘
```

### 5.3 Search / Filter No Results

- Same illustration
- Title: "No matching work orders"
- Description: "Try selecting a different status tab."

### 5.4 Error State

- Snackbar: "Failed to load work orders. Pull to retry."
- Full-screen error on initial load failure:
  - Icon: `error_outline`
  - Title: "Can't load work orders"
  - Description: "Check your connection and try again."
  - Button: "Retry"

### 5.5 Happy Path

1. User taps Work Orders tab → list loads with 5 WOs
2. Default tab "All" shows all items sorted by priority (critical first)
3. User taps "Pending" tab → list filters to 2 items (WO-002, WO-005)
4. User taps WO-002 card → navigates to Work Order Detail
5. User presses back → returns to filtered list (tab state preserved)
6. User taps "All" tab → full list restored
7. Pull-to-refresh → counts update

---

## 6. Technical Notes

- Data from `/api/work-orders`
- Tab filtering done via query params: `/api/work-orders?status=pending`
- Count badges from `/api/work-orders/counts` (lightweight endpoint)
- List sorted by: Overdue → Critical → High priority first, then by due date ascending
- RecyclerView with stable IDs for tab state preservation
