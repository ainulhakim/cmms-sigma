# Checklist Form Screen — UI/UX Specification

> **Screen ID:** 07  
> **Route:** `/checklist`  
> **Auth Required:** Yes  
> **Parent:** Machine Detail or Work Order Detail

---

## 1. Purpose

Allow technicians to complete a dynamic checklist for a maintenance task. Supports toggle items and numeric measurement fields with valid ranges.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Close (X) or Back arrow (←)
- Center: "Task Checklist"
- Right: "Save Draft" text button (if partially complete)

**Progress Header (card):**
- Progress bar (Linear, 6dp height, Primary fill with rounded corners)
- Progress label: "3 of 6 completed" (Body Medium, Secondary text)
- Estimated remaining time: "~4 min remaining" (Body Small, Secondary text)

**Checklist Items (ScrollView):**
- Each item card (72dp for toggle, 96dp for numeric):
  - **Item number badge** (24×24dp circle, Primary text on light Primary bg)
  - **Instruction text** (Body Large, Bold)
  - **Input area** (right side):
    - Toggle item: Switch (Primary thumb, when ON) or Checkbox (filled Primary)
    - Numeric item: Text field (80dp wide, outlined, numeric keyboard) with unit label below
  - **Validation:** Numeric fields show current value / acceptable range below in Body Small

**Notes Section:**
- Section header: "Additional Notes" (Label Large)
- Multi-line text field (120dp height, 4 lines visible)
- Placeholder: "Enter any observations or issues..."

**Action Buttons (sticky bottom bar):**
- "❌ Cancel & Discard" (Text button, Error color)
- "📱 Save as Draft" (Outlined button)
- "✅ Complete & Submit" (Filled button, enabled only when all required items done)

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│ ✕  Task Checklist    Save Draft │  ← App bar
├──────────────────────────────────┤
│                                  │
│  ┌────────────────────────────┐  │
│  │ ▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░│  │  ← Progress bar
│  │ 3 of 6 completed · ~4m rem │  │  ← Progress label
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ①  Inspect nozzle seal    │  │  ← Toggle item
│  │    for wear          [✓]  │  │  ← Switch ON
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ②  Measure nozzle         │  │  ← Numeric item
│  │    alignment (mm)          │  │
│  │                       [0.5]│  │  ← Numeric field
│  │                Range: ±0.5 │  │  ← Unit/range hint
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ③  Check pressure gauge   │  │  ← Numeric item
│  │                       [3.8]│  │
│  │             Range: 3.5-4.5 │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ④  Verify safety guard    │  │  ← Toggle item
│  │    in place           [✓]  │  │  ← Switch ON
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ⑤  Lubricate moving parts │  │  ← Toggle item
│  │                       [⬜] │  │  ← Switch OFF
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ⑥  Log operating temp     │  │  ← Numeric item
│  │                      [72]  │  │
│  │              Range: 60-80°C│  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Additional Notes           │  │
│  │ ┌──────────────────────┐   │  │
│  │ │ Noticed slight vib-  │   │  │  ← Multi-line text
│  │ │ ration at 3500 RPM.  │   │  │
│  │ │ Monitor during next  │   │  │
│  │ │ inspection.          │   │  │
│  │ └──────────────────────┘   │  │
│  └────────────────────────────┘  │
│                                  │
├──────────────────────────────────┤
│ [❌ Cancel] [💾 Save Draft] [✅ Submit]│
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Close/Back | Icon button | Confirmation dialog: "Discard checklist progress?" |
| Save Draft | Text button | Saves current progress as draft (API call) |
| Toggle switch | Switch | Toggles between Yes/No (ON=green, OFF=grey) |
| Numeric field | Text input (numeric) | Validates range; shows error if out of range |
| Notes field | Multi-line text | Free-form observations |
| Cancel button | Text button | Discard dialog (same as close) |
| Save Draft button | Outlined button | Persists state; snackbar "Draft saved" |
| Submit button | Filled button | Validates all items, submits, navigates back |
| Progress bar | Display only | Updates in real-time as items are completed |

---

## 5. States

### 5.1 Loading State

- 6 skeleton item cards (shimmer, 72dp each)
- Progress bar at 0% with "Loading checklist..."
- Action buttons disabled
- Data loaded from API; checklist template fetched by machine type

### 5.2 Empty State

*(Not applicable — checklist is always pre-populated with template items. If no template exists):*
- Icon: `fact_check` (96dp)
- Title: "No Checklist Template"
- Description: "This task has no predefined checklist. Add items manually or proceed."
- Buttons: "Add Item" | "Skip Checklist"

### 5.3 Validation States

| Condition | Visual |
|---|---|
| Numeric value out of range | Field outline → Error red; helper text "Value must be between 3.5-4.5" |
| Required toggle not set | No validation error (toggle defaults to OFF) |
| Notes too long (>500 chars) | Character counter turns red at 500: "495/500" |

### 5.4 Error States

- **Save failure:** Snackbar "Failed to save draft. Try again."
- **Submit failure:** Snackbar "Failed to submit checklist. Retry?" + Retry action
- **Network lost mid-form:** Snackbar "Connection lost. Progress saved locally." (cached in Room DB)

### 5.5 Happy Path

1. User arrives from Machine Detail "Start Task"
2. Progress shows 0/6, all switches OFF, fields empty
3. User toggles items 1, 4, 5 ON → progress shows 3/6
4. User enters 0.5 in alignment field, 3.8 in pressure gauge, 72 in temp → all in range
5. User adds notes about vibration
6. "Complete & Submit" becomes enabled (all items addressed)
7. User taps Submit → spinner → success
8. Snackbar: "Checklist submitted successfully." (3s)
9. Auto-navigate back to Work Order Detail (status now Completed)

---

## 6. Technical Notes

- Checklist template from `/api/checklist-templates/{machineCategory}`
- Submission via POST `/api/checklists`
- Progress persisted locally in Room DB as draft (keyed by work order ID)
- Numeric validation ranges defined in template metadata
- Draft auto-saved every 30s and on app background
