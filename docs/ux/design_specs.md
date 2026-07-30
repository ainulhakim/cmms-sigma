# CMMS SIGMA — UI/UX Design Specification

> **Version:** 1.0  
> **Platform:** Android (Mobile-first)  
> **App:** CMMS SIGMA — Computerized Maintenance Management System

---

## 1. Design System

### 1.1 Color Palette

| Token | Hex | Usage |
|---|---|---|
| **Primary** | `#1565C0` | App bar, primary buttons, active tab, links |
| **Primary Light** | `#5E92F3` | Pressed states, secondary highlights |
| **Primary Dark** | `#003C8F` | Status bar, header backgrounds |
| **Secondary** | `#26A69A` | Success states, positive trends, secondary CTAs |
| **Secondary Light** | `#64D8CB` | Soft success backgrounds |
| **Surface** | `#FFFFFF` | Cards, sheets, dialogs |
| **Background** | `#F5F7FA` | Screen background |
| **On Surface (High)** | `#1C1B1F` | Primary text |
| **On Surface (Medium)** | `#49454F` | Secondary text, labels |
| **On Surface (Disabled)** | `#C6C4C9` | Disabled text/icons |
| **Outline** | `#79747E` | Borders, dividers |
| **Outline Light** | `#E0E0E0` | Subtle dividers |
| **Error** | `#D32F2F` | Errors, validation, critical status |
| **Error Light** | `#FFEBEE` | Error background |
| **Warning** | `#F9A825` | Pending/warning status |
| **Warning Light** | `#FFF8E1` | Warning background |
| **Success** | `#2E7D32` | Completed/confirmed status |
| **Success Light** | `#E8F5E9` | Success background |
| **Info** | `#0288D1` | Informational chips |

### 1.2 Typography

| Style | Font | Weight | Size | Line Height | Usage |
|---|---|---|---|---|---|
| **H1** | Inter | Bold (700) | 32sp | 40dp | Screen title |
| **H2** | Inter | SemiBold (600) | 24sp | 32dp | Section header |
| **H3** | Inter | SemiBold (600) | 20sp | 28dp | Card title |
| **Body Large** | Inter | Regular (400) | 16sp | 24dp | Primary body text |
| **Body Medium** | Inter | Regular (400) | 14sp | 20dp | Secondary text, descriptions |
| **Body Small** | Inter | Regular (400) | 12sp | 16dp | Caption, timestamps |
| **Label Large** | Inter | Medium (500) | 14sp | 20dp | Button text, tab labels |
| **Label Small** | Inter | Medium (500) | 11sp | 16dp | Chip text, badges |
| **Monospace** | JetBrains Mono | Regular (400) | 14sp | 20dp | Measurement values, IDs |

### 1.3 Spacing Scale

| Token | dp | Usage |
|---|---|---|
| **Space-4** | 4 | Tiny gaps, icon padding |
| **Space-8** | 8 | List item padding, chip spacing |
| **Space-12** | 12 | Card content padding |
| **Space-16** | 16 | Screen margins, card padding |
| **Space-20** | 20 | Section gaps |
| **Space-24** | 24 | Between card groups |
| **Space-32** | 32 | Screen top padding |
| **Space-40** | 40 | Major section spacing |

### 1.4 Elevation & Shadows

| Level | dp | Usage |
|---|---|---|
| **Level 0** | 0dp | Flat surfaces, background |
| **Level 1** | 1dp | Subtle card separation |
| **Level 2** | 3dp | Standard cards |
| **Level 3** | 6dp | FAB, search bar, dropdown |
| **Level 4** | 8dp | Bottom navigation, app bar |
| **Level 5** | 12dp | Modal dialogs, snackbar |

### 1.5 Corner Radius

| Token | Value | Usage |
|---|---|---|
| **Radius-Small** | 4dp | Chips, small badges |
| **Radius-Medium** | 8dp | Cards, buttons, form fields |
| **Radius-Large** | 12dp | Bottom sheet, dialog |
| **Radius-Full** | 50% | Circular avatars, FAB |

### 1.6 Icon Set

- **Icon Library:** Material Symbols (Outlined style, 24dp standard)
- **Fallback:** Material Icons (filled style for bottom nav active states)
- **Custom Icons:** Machine-type icons (gears, pump, compressor, conveyor, generator)
- **Status Icons:** check_circle (success), error (critical), schedule (pending), hourglass_empty (in-progress)

---

## 2. Component Library

### 2.1 Cards

**Specification:**
- Background: Surface (white)
- Elevation: Level 2 (3dp)
- Corner radius: 8dp
- Padding: 16dp (content)
- Inner spacing: 12dp between elements
- States: idle, pressed (elevation drops to 1dp, background shifts to `#F5F5F5`)

**Card Types:**

| Type | Description | Height |
|---|---|---|
| **KPI Card** | Metric value + label + optional icon | 120dp |
| **Machine Card** | Machine name + status chip + last activity | 88dp |
| **Work Order Card** | WO ID + title + status chip + priority + date | 104dp |
| **Timeline Card** | Event dot + title + description + timestamp | 72dp |
| **Simple Card** | Title + brief description | 64dp |

### 2.2 Buttons

**Filled Button:**
- Height: 48dp
- Horizontal padding: 24dp
- Corner radius: 8dp
- Background: Primary `#1565C0`
- Text color: White
- Text style: Label Large (14sp/500)
- Icon slot: 18dp icon before label
- States: idle → pressed (80% opacity) → disabled (40% opacity)

**Outlined Button:**
- Height: 48dp
- Border: 1.5dp solid Primary `#1565C0`
- Background: Transparent
- Text color: Primary
- Corner radius: 8dp
- States: idle → pressed (5% primary tint fill) → disabled (40% opacity)

**Text Button:**
- Height: 40dp
- Padding: 12dp horizontal
- Background: Transparent
- Text color: Primary
- States: idle → pressed (5% primary tint background)

**Icon Button:**
- Size: 40×40dp
- Icon: 24dp
- Ripple: Primary at 12% opacity

**FAB (Floating Action Button):**
- Size: 56×56dp (standard)
- Elevation: Level 3 (6dp)
- Corner radius: 16dp
- Background: Primary `#1565C0`
- Icon color: White

### 2.3 Chips

| Property | Value |
|---|---|
| Height | 32dp |
| Corner radius | 16dp (pill) |
| Padding | 12dp horizontal |
| Text | Label Small (11sp/500) |
| Icon | 16dp (optional, left side) |
| Close icon | 14dp (for filter chips) |

**Chip Variants by Status:**

| Status | Background | Text Color | Border |
|---|---|---|---|
| **Operational** | `#E8F5E9` | `#2E7D32` | None |
| **Needs Maintenance** | `#FFF8E1` | `#F57F17` | None |
| **Critical** | `#FFEBEE` | `#D32F2F` | None |
| **In Progress** | `#E3F2FD` | `#1565C0` | None |
| **Completed** | `#E8F5E9` | `#2E7D32` | None |
| **Pending** | `#FFF8E1` | `#F57F17` | None |
| **Overdue** | `#FFEBEE` | `#D32F2F` | None |

### 2.4 Bottom Navigation

- Height: 64dp (with safe-area padding of 8dp below)
- Background: Surface (white)
- Top border: 0.5dp Outline Light
- Item count: 4
- Active state: Primary `#1565C0` icon + label
- Inactive state: Outline `#79747E` icon + label
- Label visibility: always shown
- Icon size: 24dp (filled style when active, outlined when inactive)

### 2.5 App Bar

- Height: 56dp (collapsed), 96dp (with subtitle)
- Background: Primary `#1565C0`
- Text color: White
- Elevation: Level 4 (8dp)
- Left slot: Navigation icon or back arrow (24dp)
- Right slots: Action icons (max 3), overflow menu

### 2.6 Snackbar

- Height: 48dp (single line) or 80dp (with action)
- Corner radius: 8dp (top corners only, full-width)
- Background: `#1C1B1F` (dark)
- Text color: White
- Text style: Body Medium (14sp)
- Action button color: Secondary `#26A69A`
- Elevation: Level 5 (12dp)
- Duration: 4s (informational) or 10s (with action)

### 2.7 Dialog

- Width: 312dp (280dp minimum, 560dp max on tablet)
- Corner radius: 12dp
- Background: Surface (white)
- Elevation: Level 5 (12dp)
- Padding: 24dp (title + content area)
- Buttons: Text buttons, right-aligned
- Scrim: #000000 at 32% opacity

### 2.8 Form Fields

| Property | Value |
|---|---|
| Height | 56dp (filled) |
| Corner radius | 8dp (outlined variant) |
| Label | Body Small (12sp), moving to top on focus |
| Input | Body Large (16sp) |
| Helper text | Body Small (12sp), below field |
| Error color | Error `#D32F2F` |
| Active indicator | Primary `#1565C0` (1.5dp) |
| Inactive indicator | Outline `#79747E` (1dp) |

**Input Types:**
- Text field (single-line, multi-line)
- Dropdown / Picker
- Date picker
- Time picker
- Switch (40×24dp, thumb 16dp)
- Checkbox (18×18dp)
- Radio button (20×20dp)
- Slider
- Star rating (24dp per star)

---

## 3. Mobile-First Responsive Layout

### 3.1 Grid System

- Base column: 4 columns (phone, < 600dp)
- Tablet: 8 columns (600–840dp)
- Desktop: 12 columns (> 840dp)
- Gutter: 16dp
- Margins: 16dp left/right

### 3.2 Breakpoints

| Breakpoint | Width | Target |
|---|---|---|
| **Compact** | < 360dp | Small phones |
| **Medium** | 360–599dp | Standard phones |
| **Expanded** | 600–840dp | Tablets (portrait) |
| **Large** | > 840dp | Tablets (landscape), desktops |

### 3.3 Touch Targets

- Minimum touch target: 48×48dp
- Preferred: 48×48dp for icons, 56dp for buttons
- Spacing between interactive elements: 8dp minimum

### 3.4 Scrolling Behavior

- Standard scroll views with `android:fillViewport="true"`
- Pull-to-refresh on all list screens
- Smooth scroll to top on bottom nav tab re-tap
- Sticky headers for section lists (maintenance history)

---

## 4. States & Patterns

### 4.1 Empty States

Each list/dashboard screen must handle the empty state with:
1. **Illustration** — A 120×120dp centered icon (Material Symbol, Outline style, 40% opacity)
2. **Title** — "No items yet" or screen-specific messaging
3. **Description** — Brief explanation + suggested action
4. **CTA Button** — "Add first item" or primary action

**Screen-specific empty state messages:**

| Screen | Title | Description | CTA |
|---|---|---|---|
| Dashboard | No Data Yet | Start by adding your first machine | Add Machine |
| Machine List | No Machines Found | Machines you add will appear here | Add Machine |
| Work Orders | No Work Orders | Create a work order to get started | Create Work Order |
| Maintenance History | No History Yet | Completed maintenance tasks will appear here | — |

### 4.2 Loading States

**Skeleton Loading (preferred):**
- Animated shimmer effect (linear gradient sweep left-to-right over 1.5s, repeating)
- Skeleton dimensions matching the content they replace:
  - **KPI Card skeleton:** 3 rectangles (100×80dp each) with 12dp gap
  - **List item skeleton:** Circle (40dp) + 2 lines (200dp + 120dp wide, 14dp tall each)
  - **Timeline skeleton:** Circle (12dp) + vertical line + content block

**Full-screen loader:**
- Centered CircularProgressIndicator (48dp)
- Primary color
- Used only for initial app load or authentication transitions

### 4.3 Error States

1. **Inline error** — Below form field, red text "Required" or "Invalid format"
2. **Snackbar error** — Bottom of screen, "Connection lost. Retry?" + Retry action
3. **Full-screen error** — Illustration (broken connection icon, 96dp), title "Something went wrong", description "We couldn't load your data. Please try again.", CTA "Retry" button

### 4.4 Happy Path

All user flows should follow the **3-tap rule**: critical actions achievable in 3 taps or fewer.

---

## 5. Mock Data

### 5.1 Machines

| ID | Name | Code | Status | Location | Category | Last Activity |
|---|---|---|---|---|---|---|
| M-001 | Filling Machine-01 | FM-01 | Operational | Line A, Floor 1 | Filling | 15 min ago |
| M-002 | Boiler-02 | BL-02 | Needs Maintenance | Utility Room B | Utilities | 2 hours ago |
| M-003 | Compressor-03 | CP-03 | Critical | Basement C | Pneumatics | 30 min ago |
| M-004 | Conveyor-04 | CV-04 | Operational | Line B, Floor 2 | Material Handling | 1 hour ago |
| M-005 | Generator-05 | GN-05 | Needs Maintenance | Rooftop | Power Supply | 4 hours ago |

### 5.2 Work Orders

| ID | Machine | Title | Status | Priority | Assigned | Due |
|---|---|---|---|---|---|---|
| WO-001 | Filling Machine-01 | Replace nozzle seal | In Progress | High | John D. | 2026-08-02 |
| WO-002 | Boiler-02 | Pressure valve calibration | Pending | Medium | Sarah K. | 2026-08-05 |
| WO-003 | Compressor-03 | Emergency: Overheating | Overdue | Critical | Mike T. | 2026-07-28 |
| WO-004 | Conveyor-04 | Belt tension adjustment | Completed | Low | Anna W. | 2026-07-29 |
| WO-005 | Generator-05 | Oil change & filter | Pending | Medium | John D. | 2026-08-10 |

### 5.3 Maintenance History

| Date | Machine | Task | Duration | Technician | Status |
|---|---|---|---|---|---|
| 2026-07-29 | Conveyor-04 | Belt tension adjustment | 1h 15m | Anna W. | Completed |
| 2026-07-28 | Filling Machine-01 | Seal inspection | 45m | John D. | Completed |
| 2026-07-27 | Generator-05 | Coolant top-up | 30m | Mike T. | Completed |
| 2026-07-25 | Compressor-03 | Filter replacement | 2h 10m | Sarah K. | Completed |
| 2026-07-22 | Boiler-02 | Descale treatment | 3h 00m | John D. | Completed |

### 5.4 Checklist Items (for Filling Machine-01 seal replacement)

| # | Item | Type | Value/Range |
|---|---|---|---|
| 1 | Inspect nozzle seal for wear | Toggle | Yes/No |
| 2 | Measure nozzle alignment (mm) | Numeric | ±0.5mm |
| 3 | Check pressure gauge reading | Numeric | 3.5–4.5 Bar |
| 4 | Verify safety guard in place | Toggle | Yes/No |
| 5 | Lubricate moving parts | Toggle | Yes/No |
| 6 | Log operating temperature | Numeric | 60–80°C |

### 5.5 User Profile

| Field | Value |
|---|---|
| Name | John Delgado |
| Role | Maintenance Technician |
| Email | j.delgado@sigma-cmms.com |
| ID | EMP-1024 |
| Department | Maintenance |
| Machines Assigned | 3 |
| Completed This Month | 12 |

### 5.6 KPI Dashboard Values

| Metric | Value | Trend | Period |
|---|---|---|---|
| Active Work Orders | 4 | ↑ +2 | Today |
| Machines Online | 3/5 | ↓ -1 | Today |
| Avg Response Time | 2.4 min | ↑ +0.3 | This Week |

---

## 6. Navigation Architecture

```
[Login Screen]
    │
    ▼
[Dashboard] ◄──── Bottom Nav (Tab 1)
    │
    ├──► [Machine List] ◄── Bottom Nav (Tab 2)
    │         │
    │         └──► [Machine Detail]
    │                  ├──► [Work Order Detail] (from history tab)
    │                  ├──► [Checklist Form] (from "Start Task")
    │                  └──► [Breakdown Report]
    │
    ├──► [Work Order List] ◄── Bottom Nav (Tab 3)
    │         │
    │         └──► [Work Order Detail]
    │                  ├──► [Checklist Form]
    │                  └──► [Breakdown Report]
    │
    └──► [Profile] ◄── Bottom Nav (Tab 4)
             │
             └──► [About / Settings]
```

**Bottom Navigation Tabs:**
1. **Dashboard** — icon: `dashboard`
2. **Machines** — icon: `precision_manufacturing`
3. **Work Orders** — icon: `assignment`
4. **Profile** — icon: `person`

---

## 7. Accessibility

- Minimum contrast ratio: 4.5:1 for normal text, 3:1 for large text (18sp+)
- All icons have content descriptions
- Focus indicators: 2dp solid Primary outline
- Touch targets: minimum 48×48dp
- Font scaling support up to 1.3× (200% system font size)

---

## 8. Motion & Animation

| Transition | Duration | Easing |
|---|---|---|
| Screen push (forward) | 300ms | FastOutSlowIn |
| Screen pop (back) | 250ms | FastOutSlowIn |
| Fade transition | 200ms | Linear |
| Ripple effect | 400ms | FastOutSlowIn |
| Pull-to-refresh | 200ms | Decelerate |
| Snackbar slide in/out | 150ms / 200ms | FastOutSlowIn |

---

*End of Design Specification Document*
