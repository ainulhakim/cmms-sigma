# Maintenance History Screen — UI/UX Specification

> **Screen ID:** 09  
> **Route:** `/maintenance-history`  
> **Auth Required:** Yes  
> **Parent:** Machine Detail (History tab) or accessible from Navigation Drawer

---

## 1. Purpose

Display a chronological timeline of all completed maintenance tasks. Provides statistical summary and filtering by machine or date range.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Back arrow (←) or hamburger
- Center: "Maintenance History"
- Right: Filter icon (🔍) → date range filter

**Stats Summary Bar (card, sticky below app bar):**
- Horizontal row of 4 stat items (equal width):
  - "Total Tasks" — 24 (Body Large, Bold) | "This Month" label (Body Small)
  - "🎯 Completed" — 18 (Body Large, Bold, Secondary/Green) | "On Time" label
  - "⏰ Pending" — 4 (Body Large, Bold, Warning) | "Overdue" label
  - "⏱️ Avg Time" — 1h 24m (Body Large, Bold, Primary) | label

**Filter Bar (below stats):**
- "All Machines" dropdown (or current machine name if filtered)
- Date range: "Jul 2026" — text button that opens date picker

**Timeline List (ScrollView):**
- Pull-to-refresh enabled
- Each timeline card (72dp):
  - **Left gutter (32dp):**
    - Status dot (12dp, colored: green=Completed, yellow=Pending, red=Failed)
    - Vertical connecting line (1dp, Outline Light) connecting dots
  - **Right content:**
    - Top: Machine name (Body Medium, Bold, Primary text)
    - Middle: Task description (Body Medium)
    - Bottom: Duration (Body Small, Secondary) | Date (Body Small, Secondary) | Technician (Body Small, Secondary)

**Timeline Group Headers:**
- Sticky header "Today" / "Yesterday" / "July 28, 2026" etc.
- Body Small, Bold, Secondary text with subtle background divider

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ←  Maintenance History      🔍  │  ← App bar
├──────────────────────────────────┤
│  ┌────────────────────────────┐  │
│  │ 24    │ 18 🎯│ 4 ⏰│ 1h24m │  │  ← Stats summary bar
│  │ Total │ OnTm │ Ovr │ Avg   │  │
│  └────────────────────────────┘  │
│                                  │
│  📦 All Machines     📅 Jul 2026 │  ← Filter bar
│                                  │
│  Today                           │  ← Sticky header
│  ●  Conveyor-04                  │  ← Timeline card
│  │  Belt tension adjustment      │
│  │  1h 15m · Jul 29 · Anna W.   │
│  │                               │
│  Yesterday                       │  ← Sticky header
│  ●  Filling Machine-01           │
│  │  Seal inspection              │
│  │  45m · Jul 28 · John D.      │
│  │                               │
│  ●  Generator-05                 │
│  │  Coolant top-up               │
│  │  30m · Jul 27 · Mike T.      │
│  │                               │
│  July 25                         │  ← Sticky header
│  ●  Compressor-03                │
│  │  Filter replacement           │
│  │  2h 10m · Jul 25 · Sarah K.  │
│  │                               │
│  ●  Boiler-02                    │
│  │  Descale treatment            │
│  │  3h 00m · Jul 22 · John D.   │
│  │                               │
│                                  │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Back arrow | Icon button | Pop back to previous screen |
| Filter icon | Icon button | Opens filter bottom sheet (machine picker + date range picker) |
| Filter chip (machines) | Dropdown | Filter by specific machine |
| Filter chip (date) | Text button | Opens date range picker (calendar) |
| Stat card (tap) | Card | Filter list by that stat category |
| Timeline card (tap) | Card | Navigate to the related Work Order Detail |
| Pull-to-refresh | Gesture | Reload history data |
| Timeline dot | Display only | Status indicator, non-interactive |
| Sticky header | Display only | Date grouping, auto-pins to top while scrolling |

---

## 5. States

### 5.1 Loading State

- Stats bar: skeleton numbers (40dp wide shimmer)
- Timeline: 5 skeleton cards (circle 12dp + 3 lines of shimmer)
- Filter bar disabled until loaded

### 5.2 Empty State

```
┌──────────────────────────────────┐
│                                  │
│      📜 (120×120dp, 40% op.)     │
│                                  │
│      No History Yet              │
│   Completed maintenance tasks    │
│   will appear here once you      │
│   start completing work orders.  │
│                                  │
└──────────────────────────────────┘
```

### 5.3 Filtered Empty State

- Same illustration
- Title: "No results for this filter"
- Description: "Try selecting a different machine or date range."
- CTA: "Clear Filters" (text button)

### 5.4 Error State

- Snackbar: "Couldn't load history. Pull to retry."
- Stats bar shows "--" for all values on failure
- Timeline area shows error state if data partially loads

### 5.5 Happy Path

1. User opens Maintenance History → stats bar loads with 24 total, 18 on-time, 4 overdue, 1h24m avg
2. Timeline shows grouped entries: Today (1 item), Yesterday (2 items), July 25 (2 items)
3. User scrolls → sticky headers update
4. User taps filter → selects "Boiler-02" → timeline filters to 1 item (Descale treatment)
5. User taps timeline card → navigates to Work Order Detail
6. User presses back → filter preserved
7. User clears filter → full timeline restored

---

## 6. Technical Notes

- Data from `/api/maintenance-history`
- Stats from `/api/maintenance-history/stats`
- Filter query params: `?machineId=002&from=2026-07-01&to=2026-07-31`
- Timeline uses `RecyclerView` with `ItemDecoration` for connecting lines
- Sticky headers via `ItemDecoration` or `PinnedHeaderItemDecoration`
- Infinite scroll: load 20 items, paginate with `?page=N&size=20`
