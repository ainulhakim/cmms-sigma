# Breakdown Report Screen — UI/UX Specification

> **Screen ID:** 08  
> **Route:** `/breakdown-report`  
> **Auth Required:** Yes  
> **Parent:** Machine Detail or Work Order Detail (from "Report Breakdown" action)

---

## 1. Purpose

Allow technicians to report equipment breakdowns or urgent issues. Capture machine details, problem description, severity, and optional photo evidence.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Close (X) or Back arrow (←)
- Center: "Report Breakdown"
- Right: Empty (no actions)

**Form (ScrollView):**
- All fields use Outlined style with 8dp radius
- 16dp horizontal margin

**Form Fields (in order):**

1. **Machine** — Dropdown/Picker
   - Pre-filled if navigated from Machine Detail
   - Dropdown lists all 5 machines
   - Helper: "Select the affected machine"

2. **Problem Title** — Single-line text field
   - Max 100 characters
   - Placeholder: "Brief title of the issue"
   - Character counter: "0/100"

3. **Severity** — Chip group (required, single select):
   - "🔴 Critical" (Error bg)
   - "🟡 High" (Warning bg)
   - "🔵 Medium" (Info bg)
   - "⚪ Low" (Neutral bg)

4. **Description** — Multi-line text field
   - 4 lines visible, 120dp height
   - Max 500 characters
   - Placeholder: "Describe what happened. Include any relevant details about the breakdown..."
   - Character counter: "0/500"

5. **Impact** — Chip group (multi-select):
   - "Production Stopped"
   - "Reduced Capacity"
   - "Safety Concern"
   - "Quality Issue"
   - "Other"

6. **Photo Evidence** — Attachment section
   - Camera button (Filled icon button, 48dp) + Gallery button (Outlined icon button, 48dp)
   - Photo preview strip (64×64dp thumbnails, with X remove button overlay on each)
   - Max 5 photos
   - Caption field (optional) per photo after tap

7. **Additional Notes** — Multi-line text field
   - 3 lines visible
   - Optional, placeholder: "Any additional information..."

**Action Buttons (sticky bottom bar):**
- "❌ Cancel" (Text button)
- "📱 Save as Draft" (Outlined button)
- "🚨 Submit Report" (Filled button, Error color `#D32F2F`, enabled when required fields complete)

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ✕  Report Breakdown              │  ← App bar
├──────────────────────────────────┤
│                                  │
│  Machine                         │
│  ┌────────────────────────────┐  │
│  │  Filling Machine-01    ▼  │  │  ← Dropdown (pre-filled)
│  └────────────────────────────┘  │
│                                  │
│  Problem Title                    │
│  ┌────────────────────────────┐  │
│  │ Nozzle seal leaking       │  │  ← Text field
│  └────────────────────────────┘  │
│  19/100                          │  ← Character counter
│                                  │
│  Severity                        │
│  [🔴 Critical] [🟡 High]         │  ← Chip group (single)
│  [🔵 Medium]  [⚪ Low]           │
│                                  │
│  Description                     │
│  ┌────────────────────────────┐  │
│  │ Nozzle seal began leaking  │  │
│  │ during operation at 14:30. │  │  ← Multi-line text
│  │ Pressure dropped from 4.2  │  │
│  │ to 2.1 Bar. System halted  │  │
│  │ as a safety precaution.    │  │
│  └────────────────────────────┘  │
│  127/500                         │  ← Character counter
│                                  │
│  Impact                          │
│  [Production] [Reduced] [Safety] │  ← Chips (multi-select)
│  [Quality]    [Other]            │
│                                  │
│  Photo Evidence (0/5)            │
│  [📷 Camera]  [🖼️ Gallery]      │  ← Add buttons
│  [📸IMG_001.jpg] [📸IMG_002.jpg] │  ← Thumbnails with ✕
│                                  │
│  Additional Notes                │
│  ┌────────────────────────────┐  │
│  │ Possible cause: worn seal │  │  ← Optional notes
│  └────────────────────────────┘  │
│                                  │
├──────────────────────────────────┤
│ [❌ Cancel] [💾 Draft] [🚨 Submit] │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Close/Back | Icon button | Confirmation: "Discard this report?" with [Discard] [Keep Editing] |
| Machine dropdown | Picker | Opens bottom sheet with machine list + search |
| Severity chips | Chip group (single) | Toggle selection; one required |
| Impact chips | Chip group (multi) | Toggle each independently |
| Camera button | Filled icon button | Opens device camera (runtime permission check) |
| Gallery button | Outlined icon button | Opens device gallery picker |
| Photo remove (✕) | Icon button overlay | Removes photo; confirmation if >1 photo |
| Photo tap | Image | Opens full-screen photo viewer with caption editor |
| Cancel button | Text button | Same as close |
| Save Draft button | Outlined button | Persists report as draft; snackbar "Draft saved" |
| Submit button | Filled button (Error) | Validates all required fields, submits, navigates back |

---

## 5. States

### 5.1 Loading State

- Form fields show skeleton outlines (shimmer)
- Dropdown populated asynchronously
- Submit button disabled until data loads

### 5.2 Validation States

| Field | Condition | Error Message |
|---|---|---|
| Machine | Not selected | "Please select a machine" |
| Problem Title | Empty | "Title is required" |
| Problem Title | >100 chars | Counter turns red at 100 |
| Severity | None selected | "Please select a severity level" |
| Description | Empty | "Description is required" |
| Description | >500 chars | Counter turns red at 500 |
| Photos | API size > 10MB each | Snackbar: "Photo too large. Max 10MB." |

### 5.3 Error States

- **Submit failure:** Snackbar "Failed to submit report. Retry?" + Retry action
- **Photo upload failure:** Inline per-photo: "Upload failed. Tap to retry."
- **Network loss:** Snackbar "Connection lost. Draft saved locally."

### 5.4 Happy Path

1. User arrives from Machine Detail (Filling Machine-01) → Machine pre-selected
2. User types title: "Nozzle seal leaking"
3. User selects "Critical" severity
4. User writes description (~127 chars)
5. User selects "Production Stopped" + "Safety Concern" impact
6. User takes 2 photos via camera → thumbnails appear
7. User taps "Submit Report"
8. Confirmation dialog: "Submit breakdown report for Filling Machine-01?"
   - [Cancel] [Submit]
9. User taps Submit → spinner (1.5s min) → success
10. Snackbar: "Breakdown report submitted. Work order created." (5s)
11. Auto-navigate to newly created Work Order Detail

---

## 6. Technical Notes

- Form submission via POST `/api/breakdown-reports`
- Creates a new Work Order with "Critical" priority automatically
- Photos uploaded via multipart, compressed to 1080px max dimension before upload
- Draft saved locally in Room DB with auto-save every 30s
- Submit button enabled only when: machine set, title not empty, severity selected, description not empty
