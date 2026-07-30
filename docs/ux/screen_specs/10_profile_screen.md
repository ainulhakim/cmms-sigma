# Profile Screen — UI/UX Specification

> **Screen ID:** 10  
> **Route:** `/profile`  
> **Auth Required:** Yes  
> **Bottom Nav Tab:** 4 of 4

---

## 1. Purpose

Display user profile information, account settings, and app configuration. Provides access to logout and app info.

---

## 2. Layout Description

**App Bar (Primary, 56dp):**
- Left: Hamburger menu icon or empty
- Center: "Profile"
- Right: Edit icon (✏️) → Edit profile (future sprint)

**Avatar Card (hero section):**
- Large avatar (80×80dp circle):
  - Displays user initials on Primary background (e.g., "JD")
  - Or profile photo if uploaded
- User name: "John Delgado" (H3, Bold)
- Role: "Maintenance Technician" (Body Medium, Secondary text)
- Employee ID: "EMP-1024" (Body Small, Secondary text)

**Stats Row (card, below avatar):**
- 3 stat items (equal width):
  - "3" (H2, Bold) | "Machines" (Body Small)
  - "12" (H2, Bold, Secondary) | "Completed" (Body Small)
  - "98%" (H2, Bold, Success) | "On Time" (Body Small)

**Account Section (card):**
- Section header: "Account Information" (Label Large, 12dp top padding)
- Info rows with icon (40dp rounded icon area):
  - `email` | Email: j.delgado@sigma-cmms.com
  - `phone` | Phone: +1 (555) 123-4567
  - `badge` | Department: Maintenance
  - `calendar_month` | Joined: March 2024

**Settings Section (card):**
- Section header: "Settings" (Label Large)
- Settings rows (56dp each) with Switch on the right:
  - "🔔 Push Notifications" | Switch ON (Primary)
  - "🔊 Sound Alerts" | Switch ON
  - "📳 Vibrate" | Switch OFF
  - "🌙 Dark Mode" | Switch OFF
  - "📱 Biometric Login" | Switch ON

**App Info Section:**
- Row items with chevron (>) navigation:
  - "ℹ️ About CMMS SIGMA" → screen with version, licenses, credits
  - "📄 Privacy Policy" → opens URL
  - "📋 Terms of Service" → opens URL
  - "🛟 Help & Support" → opens contact/FAQ screen

**Logout Section:**
- "🚪 Log Out" row (Error color text, with `logout` icon)
- Tapping shows confirmation dialog

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│          Profile          ✏️     │  ← App bar
├──────────────────────────────────┤
│                                  │
│          ┌──────┐                │
│          │  JD  │                │  ← Avatar (80dp circle)
│          └──────┘                │
│       John Delgado               │  ← Name (H3)
│   Maintenance Technician         │  ← Role
│          EMP-1024                │  ← Employee ID
│                                  │
│  ┌────────────────────────────┐  │
│  │  3     │  12   │  98%     │  │  ← Stats row
│  │Mach. │ Cmpltd│ On Time   │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Account Information        │  │  ← Section header
│  │ ✉️ j.delgado@sigma-cmms... │  │
│  │ 📞 +1 (555) 123-4567      │  │
│  │ 🪪 Department: Maintenance │  │
│  │ 📅 Joined: March 2024     │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ Settings                   │  │
│  │ 🔔 Push Notifications  [●]│  │  ← Switch ON
│  │ 🔊 Sound Alerts        [●]│  │
│  │ 📳 Vibrate             [○]│  │  ← Switch OFF
│  │ 🌙 Dark Mode           [○]│  │
│  │ 📱 Biometric Login     [●]│  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ ℹ️ About              >   │  │
│  │ 📄 Privacy Policy     >   │  │
│  │ 📋 Terms of Service   >   │  │
│  │ 🛟 Help & Support     >   │  │
│  │ 🚪 Log Out           >   │  │  ← Error color text
│  └────────────────────────────┘  │
│                                  │
├──────────────────────────────────┤
│  📊  🏭  📋  👤                   │  ← Bottom nav (Profile active)
│ Dash Mach  WO  Profile           │
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Action |
|---|---|---|
| Edit icon (✏️) | Icon button | Opens Profile Edit form (future sprint) |
| Avatar | Image/Text | Opens photo picker for profile picture |
| Settings switch | Switch | Toggles setting; persists to SharedPreferences |
| About row | List item | Navigate to About screen (app version, licenses) |
| Privacy Policy | List item | Opens URL in browser |
| Terms of Service | List item | Opens URL in browser |
| Help & Support | List item | Opens contact/FAQ screen |
| Log Out row | List item (Error) | Shows confirmation dialog: "Are you sure you want to log out?" [Cancel] [Log Out] |
| Log Out confirm | Dialog button | Clears session, navigates to Login Screen |
| Log Out cancel | Dialog button | Closes dialog |

---

## 5. States

### 5.1 Loading State

- Avatar circle skeleton (80dp, shimmer)
- Name skeleton (2 lines, 200dp + 120dp)
- Stats skeleton (3 number blocks, shimmer)
- Settings switches disabled until loaded
- All navigation rows disabled

### 5.2 Empty State

*(Not applicable — profile always has user data from auth token. If profile load fails, show error state.)*

### 5.3 Error State

- Snackbar: "Failed to load profile. Pull to retry."
- Avatar shows generic initials if photo fails to load
- Settings section loads from local cache if API fails

### 5.4 Happy Path

1. User taps Profile tab → avatar shows "JD" initials on Primary bg
2. Stats show 3 machines, 12 completed, 98% on-time
3. Account info displays all fields correctly
4. User toggles "Dark Mode" switch → app immediately switches to dark theme
5. User taps "About" → navigates to About screen (version 1.0.0, licenses)
6. User presses back → returns to Profile
7. User taps "Log Out" → dialog appears
8. User confirms → session cleared → navigated to Login Screen
9. Snackbar: "Logged out successfully."

### 5.5 Logout Confirmation Dialog

```
┌──────────────────────────┐
│                          │
│   🚪 Log Out             │
│                          │
│  Are you sure you want   │
│  to log out?             │
│                          │
│      [Cancel] [Log Out]  │
│                          │
└──────────────────────────┘
```

---

## 6. Technical Notes

- Profile data from `/api/users/me` (from JWT token)
- Settings stored in `SharedPreferences` (DataStore preferred)
- Dark Mode: toggles `AppCompatDelegate.setDefaultNightMode()`
- Biometric login: configures auth preference; actual biometric setup happens on next login
- Logout: clears EncryptedSharedPreferences, resets navigation to Login
- Push notification settings: sends device token update to server
