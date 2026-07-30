# Machine List Screen — UI/UX Specification

> **Screen ID:** 03  
> **Route:** `/machines`  
> **Auth Required:** Yes  
> **Bottom Nav Tab:** 2 of 4

---

## 1. Purpose

Display a searchable, filterable list of all machines. Allows users to quickly find machines by name, code, status, or location.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Back arrow or hamburger (if not bottom-nav context)
- Center: "Machines"
- Right: Filter icon button (→ opens filter bottom sheet)

**Search Bar (below app bar, sticky):**
- Outlined search field with `search` prefix icon
- Placeholder: "Search by name, code, or location..."
- Clear button (X) appears when text entered
- Elevation: Level 3

**Filter Bottom Sheet (slide-up):**
- Title: "Filter Machines" (H3)
- Section: "Status" — Chip group: All, Operational, Needs Maintenance, Critical
- Section: "Category" — Chip group: All, Filling, Utilities, Pneumatics, Material Handling, Power Supply
- Section: "Location" — Text field or dropdown
- Buttons: "Clear All" (Text) | "Apply" (Filled)

**Machine List (ScrollView):**
- Pull-to-refresh enabled
- 5 machine cards (88dp each)
- Each card:
  - Left: Machine-type icon (40×40dp, rounded-square with light Primary background `#E3F2FD`)
  - Center: Machine name (Body Large, Bold), Code (Body Small, Secondary text), Location (Body Small, Secondary text)
  - Right: Status chip (pill, 32dp) + chevron forward icon

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│  ←    Machines          🔍      │  ← App bar
├──────────────────────────────────┤
│ ┌────────────────────────────┐   │
│ │ 🔍 Search machines...     │   │  ← Search bar (sticky)
│ └────────────────────────────┘   │
│                                  │
│ ┌────────────────────────────┐   │
│ │ ⚙️  Filling Machine-01    ✅ │  │  ← Operational (green chip)
│ │    FM-01 · Line A, Floor 1  > │  │
│ └────────────────────────────┘   │
│                                  │
│ ┌────────────────────────────┐   │
│ │ 🔥  Boiler-02            ⚠️  │  │  ← Needs Maintenance (yellow)
│ │    BL-02 · Utility Room B   > │  │
│ └────────────────────────────┘   │
│                                  │
│ ┌────────────────────────────┐   │
│ │ 💨  Compressor-03         ❌ │  │  ← Critical (red chip)
│ │    CP-03 · Basement C       > │  │
│ └────────────────────────────┘   │
│                                  │
│ ┌────────────────────────────┐   │
│ │ 📦  Conveyor-04           ✅ │  │  ← Operational (green chip)
│ │    CV-04 · Line B, Floor 2  > │  │
│ └────────────────────────────┘   │
│                                  │
│ ┌────────────────────────────┐   │
│ │ ⚡  Generator-05          ⚠️  │  │  ← Needs Maintenance (yellow)
│ │    GN-05 · Rooftop          > │  │
│ └────────────────────────────┘   │
│                                  │
├──────────────────────────────────┤
│  📊  🏭  📋  👤                   │  ← Bottom nav (Machines active)
│ Dash Mach  WO  Profile           │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Search field | Text input | Filters list in real-time (300ms debounce) |
| Clear search | Icon button (X) | Clears text, resets list |
| Filter icon | Icon button | Opens filter bottom sheet |
| Filter chips | Chip | Toggle selection (multi-select) |
| Apply filters | Filled button | Closes bottom sheet, applies filters |
| Clear filters | Text button | Resets all filter selections |
| Machine card (tap) | Card | Navigate to Machine Detail (slide left) |
| Status chip | Chip (display only) | Non-interactive indicator |
| Pull-to-refresh | Gesture | Reloads machine list |
| Bottom nav (Machines) | Tab | Scroll to top (already active) |
| Bottom nav (other) | Tab | Navigate to respective screen |

---

## 5. States

### 5.1 Loading State

- 5 skeleton list items (circle 40dp + 2 lines 200dp/120dp) with shimmer
- Search bar and filter icon disabled until loaded
- Status: "Loading machines..."

### 5.2 Empty State

```
┌──────────────────────────────────┐
│                                  │
│      🏭 (120×120dp, 40% op.)     │
│                                  │
│      No Machines Found           │
│   Machines you add will appear   │
│   here. Try adjusting your       │
│   search or filters.             │
│                                  │
│    ┌────────────────────────┐    │
│    │     Add Machine        │    │  ← CTA
│    └────────────────────────┘    │
│                                  │
└──────────────────────────────────┘
```

### 5.3 Search No Results

- Same illustration as empty state
- Title: "No results for '[query]'"
- Description: "Try different keywords or check your spelling."
- CTA: "Clear Search" text button

### 5.4 Error State

- Snackbar: "Couldn't load machines. Retry?"
- Full-screen error if initial load fails:
  - Icon: `error_outline` (96dp)
  - Title: "Connection Error"
  - Description: "Unable to load machine list."
  - Button: "Retry"

### 5.5 Happy Path

1. User taps Machines tab → list loads with 5 machines
2. User searches "boil" → list filters to 1 result (Boiler-02)
3. User clears search → all 5 reappear
4. User taps filter → bottom sheet opens → selects "Critical" status → Apply → list shows 1 machine (Compressor-03)
5. User taps Compressor-03 card → navigates to Machine Detail
6. Pull-to-refresh → list reloads with latest status updates

---

## 6. Technical Notes

- Data from `/api/machines`
- Search uses local filtering (client-side) for responsiveness
- Filters sent as query params on subsequent API calls
- List uses `RecyclerView` with `DiffUtil` for smooth updates
- Machine icons derived from `category` field
