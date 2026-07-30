# Dashboard Screen — UI/UX Specification

> **Screen ID:** 02  
> **Route:** `/dashboard`  
> **Auth Required:** Yes  
> **Bottom Nav Tab:** 1 of 4

---

## 1. Purpose

Provide an at-a-glance operational overview. Displays KPIs, quick actions, and recent activity. Acts as the home screen after login.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Hamburger menu icon (24dp, white) → opens navigation drawer (future)
- Center: "Dashboard" (H3, White, 20sp)
- Right: Bell notification icon (24dp, white) with badge count

**Refreshable ScrollView:**

**KPI Section (top, 120dp each):**
- 3 KPI cards in a vertical column (mobile-optimized stack)
- Each card: metric value (H2, 32sp bold), metric label (Body Medium, Secondary text), trend indicator (+2 ↑ green or -1 ↓ red, Body Small)

**Quick Actions Section:**
- Section header "Quick Actions" (Label Large, Primary text)
- Horizontal chip row (scrollable, 32dp height):
  - "➕ New Work Order"
  - "➕ New Machine"
  - "📋 Report Breakdown"
  - "🔍 Scan QR"

**Recent Activity Section:**
- Section header "Recent Activity" (Label Large, Primary text)
- 3 timeline cards (72dp each):
  - Left: colored dot (12dp, status-colored) + vertical line
  - Right: description (Body Medium) + timestamp (Body Small, Secondary text)

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ☰    Dashboard        🔔 (2)    │  ← App bar, Primary
├──────────────────────────────────┤
│                                  │
│  ┌────────────────────────────┐  │
│  │  4              ↑ +2       │  │  ← KPI Card
│  │  Active Work Orders        │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │  3/5           ↓ -1        │  │  ← KPI Card
│  │  Machines Online           │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │  2.4 min        ↑ +0.3     │  │  ← KPI Card
│  │  Avg Response Time         │  │
│  └────────────────────────────┘  │
│                                  │
│  Quick Actions                   │
│  ┌──────┐ ┌──────┐ ┌──────────┐ │
│  │+ New │ │+ New │ │  Report  │ │  ← Scrollable chips
│  │  WO  │ │Mach. │ │Breakdown │ │
│  └──────┘ └──────┘ └──────────┘ │
│                                  │
│  Recent Activity                 │
│  ● Work order WO-003 ...  ── 5m │  ← Timeline cards
│  │                               │
│  ● Boiler-02 temp spike  ── 1h  │
│  │                               │
│  ● WO-004 completed      ── 3h  │
│                                  │
├──────────────────────────────────┤
│  📊  🏭  📋  👤                   │  ← Bottom nav
│ Dash Mach  WO  Profile           │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Hamburger menu | Icon button | Opens nav drawer (future sprint) |
| Notification bell | Icon button | Navigates to notifications screen |
| KPI Card (tap) | Card | Taps into full KPI detail or filtered list |
| Quick Action chips | Chip | Navigate to respective screens |
| Timeline card (tap) | Card | Navigate to detail of referenced item |
| Bottom nav (Dashboard) | Tab | Refreshes dashboard data (already active) |
| Bottom nav (Machines) | Tab | Navigates to Machine List |
| Bottom nav (Work Orders) | Tab | Navigates to Work Order List |
| Bottom nav (Profile) | Tab | Navigates to Profile |

---

## 5. States

### 5.1 Loading State

- 3 skeleton rectangles (100×80dp, shimmer animation) in place of KPI cards
- 3 skeleton list items (circle + line) in place of timeline
- Quick actions hidden until loaded
- Pull-to-refresh spinner at top

### 5.2 Empty State

```
┌──────────────────────────────────┐
│ ☰    Dashboard        🔔 (0)    │
├──────────────────────────────────┤
│                                  │
│           📊 (120×120dp)         │  ← Icon 40% opacity
│        No Data Yet               │  ← H3
│   Start by adding your first     │
│   machine to get started.        │
│                                  │
│    ┌────────────────────────┐    │
│    │     Add Machine        │    │  ← Filled button
│    └────────────────────────┘    │
│                                  │
├──────────────────────────────────┤
│ Bottom Nav                        │
└──────────────────────────────────┘
```

### 5.3 Error State

- Snackbar at bottom: "Couldn't load dashboard. Retry?" (10s, "Retry" action)
- Full-screen error overlay (if data missing on load):
  - Icon: `cloud_off` (96dp, 40% opacity)
  - Title: "Something went wrong"
  - Description: "We couldn't load your dashboard data."
  - Button: "Retry" (Filled, full width)

### 5.4 Happy Path

1. User opens app → data loads in <1.5s
2. KPI cards show: 4 active WOs (+2 trend), 3/5 machines online (-1), 2.4 min avg response (+0.3)
3. Quick action chips render in horizontal scroll
4. 3 timeline items show most recent activity
5. Bottom nav allows navigation to other tabs
6. Pull-to-refresh reloads data; shows updated values if changed

---

## 6. Technical Notes

- KPIs fetched from `/api/dashboard/kpis` endpoint
- Recent activity from `/api/activity/recent?limit=3`
- Auto-refresh on app resume (if >30s since last fetch)
- Pull-to-refresh minimum 500ms delay
