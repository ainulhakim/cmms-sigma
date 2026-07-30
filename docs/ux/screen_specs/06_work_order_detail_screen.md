# Work Order Detail Screen — UI/UX Specification

> **Screen ID:** 06  
> **Route:** `/work-orders/{id}`  
> **Auth Required:** Yes  
> **Parent:** Work Order List (tap card)

---

## 1. Purpose

Display full details of a single work order. Allows technicians to view instructions, start tasks, log completion, and report breakdowns.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Back arrow (←)
- Center: "WO-001" (WO ID)
- Right: Overflow menu (⋮) → Edit, Assign, Delete

**Header Section:**
- Task title (H3, Bold)
- Machine name with `precision_manufacturing` icon (Body Medium, Primary text, tappable to machine detail)
- Status chip (large, 36dp)
- Priority badge (small chip with label)
- Assigned technician (Body Medium, with `person` icon)
- Due date (Body Medium, with `calendar_today` icon)

**Live Timer Section (if In Progress):**
- Card with Primary background (`#E3F2FD`)
- Timer display: HH:MM:SS (Monospace, 32sp Bold, Primary)
- Controls: "Pause" (Outlined) | "Complete" (Filled, Success color)
- Timer shows from when status changed to "In Progress"

**Expandable Sections (cards):**
- **Description** — Full task description text (Body Medium), expandable if >3 lines
- **Checklist** — Shows checklist items with status (toggle icon), CTA "View Full Checklist"
- **Attachments** — Photo thumbnails (64×64dp, rounded) in horizontal scroll, "Add" button

**Action Buttons (sticky bottom bar):**
- If Pending: "📋 Start Task" (Filled) | "⚠️ Report Breakdown" (Outlined, Error)
- If In Progress: "⏸️ Pause" (Outlined) | "✅ Complete Task" (Filled, Success)
- If Completed: "📋 View Checklist" (Text) | "⚠️ Report Issue" (Outlined, Error)

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ←  WO-001                   ⋮    │  ← App bar
├──────────────────────────────────┤
│                                  │
│  Replace nozzle seal             │  ← Title (H3)
│  🏭 Filling Machine-01           │  ← Machine link
│  ✅ In Progress  🔴 Critical     │  ← Status chip + Priority
│  👤 John D. · 📅 Due: Aug 2      │  ← Assignment info
│                                  │
│  ┌────────────────────────────┐  │
│  │  ⏱️ 00:32:15               │  │  ← Live timer (In Progress)
│  │  [⏸️ Pause]  [✅ Complete]  │  │  ← Timer controls
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Description              ▼ │  │  ← Expandable section
│  │ Replace the nozzle seal..  │  │
│  │ 1. Depressurize system..   │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Checklist            View >│  │  ← Checklist summary
│  │ ✅ 1. Inspect nozzle seal  │  │
│  │ ⬜ 2. Measure alignment    │  │
│  │ ⬜ 3. Check pressure       │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Attachments       [+ Add]  │  │
│  │ [📷] [📷] [📷]             │  │  ← Thumbnail strip
│  └────────────────────────────┘  │
│                                  │
├──────────────────────────────────┤
│ [⏸️ Pause]   [✅ Complete Task]  │  ← Sticky action bar
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Back arrow | Icon button | Pop back to Work Order List |
| Overflow menu | Icon button | Dropdown: Edit, Reassign, Delete, Print |
| Machine name link | Text link | Navigate to Machine Detail |
| Timer (HH:MM:SS) | Live display | Updates every second; non-interactive |
| Pause button | Outlined button | Pauses timer, status → Paused (new state) |
| Complete button | Filled button | Opens confirmation dialog, marks complete |
| Description header | Expandable tap | Expand/collapse description text |
| "View Full Checklist" | Text button | Navigate to Checklist Form (pre-filled) |
| Attachment thumbnails | Image | Opens full-screen image viewer |
| Add attachment | Icon button | Opens camera/gallery picker |
| Report Breakdown | Text/Outlined button | Navigate to Breakdown Report |

---

## 5. States

### 5.1 Loading State

- Skeleton header (title line + 2 info lines)
- Skeleton timer card (60dp shimmer)
- 2 skeleton expandable sections
- Action buttons disabled

### 5.2 Empty / Not Found

- Full-screen state if WO ID invalid:
  - Icon: `search_off` (96dp)
  - Title: "Work Order Not Found"
  - Description: "This work order may have been deleted."
  - Button: "Back to List"

### 5.3 Error State

- Snackbar: "Failed to load work order details. Retry?"
- Timer loses sync: shows "--:--:--" with retry option

### 5.4 Happy Path (In Progress → Complete)

1. User taps WO-001 from list → detail screen loads
2. Header shows "In Progress" chip + Critical priority
3. Timer displays 00:32:15 and counting
4. User reads description (expanded)
5. User sees checklist: 1/3 done
6. User taps "Complete Task" → confirmation dialog: "Mark WO-001 as complete?"
   - [Cancel] [Confirm]
7. User taps Confirm → status updates to Completed, timer stops
8. Action bar updates: now shows "View Checklist" + "Report Issue"
9. Snackbar: "WO-001 marked as complete." (3s)
10. Back arrow → Work Order List (status updated)

---

## 6. Technical Notes

- Data from `/api/work-orders/{id}`
- Timer start time from `startedAt` timestamp in WO data
- Timer syncs with server every 60s to prevent drift
- Status updates via PATCH `/api/work-orders/{id}/status`
- Timer pause records elapsed time server-side
- Attachments upload via multipart POST `/api/work-orders/{id}/attachments`
