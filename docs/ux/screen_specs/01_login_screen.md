# Login Screen — UI/UX Specification

> **Screen ID:** 01  
> **Route:** `/login`  
> **Auth Required:** No

---

## 1. Purpose

Authenticate the user and establish a session. Entry point for the app. Supports email + password login with biometric fallback.

---

## 2. Layout Description

The screen is split into two visual zones:

**Top Zone (55% of viewport):**
- Full-width illustration area with centered content
- App logo (96×96dp, rounded square with Primary background, white sigma icon)
- App name "CMMS SIGMA" (H2, White)
- Tagline "Maintenance Simplified" (Body Medium, Primary Light at 80% opacity)
- Subtle curved wave divider at the bottom of the zone

**Bottom Zone (45% of viewport):**
- Surface (white) background
- Centered content
- Email text field (Full width with 24dp horizontal margin)
- Password text field (Full width, with visibility toggle icon on the right)
- Login button (Filled, Full width)
- "Forgot Password?" link (Text button, centered)
- Divider with "OR" text
- "Use Biometrics" button (Outlined, with fingerprint icon)
- Version label at bottom: "v1.0.0"

---

## 3. Wireframe (ASCII)

```
┌──────────────────────────────────┐
│                                  │
│          ┌──────────┐           │
│          │  [sigma] │           │  ← Logo (96×96dp)
│          └──────────┘           │
│                                  │
│        CMMS SIGMA                │  ← H2, White
│    Maintenance Simplified        │  ← Body Medium, 80% opacity
│                                  │
│   ╱╲                            │  ← Curved wave divider
│  ╱  ╲╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲  │
│ ╱                                │
├──────────────────────────────────┤
│  ┌──────────────────────────┐   │
│  │  Email address           │   │  ← Text field, inactive
│  └──────────────────────────┘   │
│  ┌──────────────────────────┐   │
│  │  Password          👁️    │   │  ← Text field, hidden
│  └──────────────────────────┘   │
│                                  │
│  ┌──────────────────────────┐   │
│  │       Sign In            │   │  ← Filled button, Primary
│  └──────────────────────────┘   │
│                                  │
│         Forgot Password?         │  ← Text button
│                                  │
│    ────────── OR ──────────      │  ← Divider
│                                  │
│  ┌──────────────────────────┐   │
│  │  🔐  Use Biometrics      │   │  ← Outlined button
│  └──────────────────────────┘   │
│                                  │
│              v1.0.0              │  ← Caption
└──────────────────────────────────┘
```

---

## 4. Interactive Elements

| Element | Type | Behavior |
|---|---|---|
| Email field | Text input, keyboard type="email" | Validates on focus loss; shows inline error if invalid |
| Password field | Text input, password masked | Toggle visibility with eye icon |
| Sign In button | Filled button | Validates all fields, triggers auth API call, shows loading spinner |
| Forgot Password | Text button | Opens password reset flow (external or in-app) |
| Biometrics button | Outlined button | Triggers device biometric prompt (fingerprint/face) |
| Visibility toggle | Icon button | Toggles password mask on/off |

---

## 5. States

### 5.1 Loading State

- Sign In button shows `CircularProgressIndicator` (24dp, white) replacing the label
- All input fields set to disabled (40% opacity)
- "Authenticating..." text shown below the button
- Biometrics button disabled

### 5.2 Empty State

- Initial app launch with no pre-filled credentials
- Fields show hint text: "Email address" and "Password"
- Cursor in email field on first open
- Sign In button disabled until both fields have content

### 5.3 Error States

| Condition | Visual Feedback |
|---|---|
| Empty email on submit | Field outline turns Error `#D32F2F`; helper text "Email is required" |
| Invalid email format | Field outline turns Error; helper text "Enter a valid email address" |
| Empty password on submit | Field outline turns Error; helper text "Password is required" |
| Password < 6 chars | Field outline turns Error; helper text "Password must be at least 6 characters" |
| Invalid credentials (401) | Snackbar appears: "Invalid email or password. Please try again." (4s, red action "Dismiss") |
| Network error | Snackbar appears: "Connection lost. Check your internet and try again." (10s, action "Retry") |
| Biometric auth failed | Inline message below biometric button: "Biometric authentication failed. Use your password." |

### 5.4 Happy Path

1. User enters email "j.delgado@sigma-cmms.com"
2. User enters password "●●●●●●●●●●"
3. Taps "Sign In" → button shows spinner (600ms min)
4. API authenticates → spinner removed
5. Screen transitions to Dashboard (slide left, 300ms)
6. Snackbar: "Welcome back, John!" (3s, dismiss)

---

## 6. Auth Flow Wireframe

```
[App Launch]
     │
     ▼
┌─────────────┐
│ Login Screen │ ◄── If no valid session
└──────┬──────┘
       │
       ├── Sign In ──► API Call ──► Success ──► [Dashboard]
       │                              │
       │                              └── Failure ──► Show error
       │
       ├── Biometrics ──► Device Auth ──► Success ──► [Dashboard]
       │                                    │
       │                                    └── Failure ──► Show message
       │
       └── Forgot Password ──► Email/Reset flow
```

---

## 7. Technical Notes

- Session token stored in EncryptedSharedPreferences
- Biometric key stored via Android BiometricPrompt API (crypto-based)
- Token refresh handled silently at app resume
- Auto-logout after 24h of inactivity
