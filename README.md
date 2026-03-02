# Kigali City Services & Places Directory

A full-featured Flutter mobile application for Kigali residents to discover, navigate, and manage essential public services and leisure venues across Kigali, Rwanda.

## Features

- 🔐 **Firebase Authentication** — Sign up, log in, log out with enforced email verification
- 📍 **Location Directory** — Browse hospitals, police stations, libraries, restaurants, cafés, parks, and tourist attractions
- 🔍 **Search & Filter** — Real-time search by name and category chip filtering
- ✏️ **Full CRUD** — Create, read, update, and delete listings stored in Cloud Firestore
- 🗺️ **Google Maps Integration** — Embedded maps with markers on the detail screen; full map view
- 🧭 **Navigation** — "Get Directions" launches Google Maps turn-by-turn navigation
- 👤 **User Listings** — Each user manages their own listings
- 🔔 **Notification Toggle** — Location notification preference (persisted locally)
- 🌙 **Dark Navy UI** — Premium dark theme matching the Kigali City design mockup

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Auth | Firebase Authentication (email/password) |
| Database | Cloud Firestore |
| State Management | **Provider** |
| Maps | google_maps_flutter |
| Navigation | url_launcher |
| Location | geolocator |
| Preferences | shared_preferences |

---

## Firestore Database Structure

```
users/
  {uid}/
    uid:          string   // Firebase Auth UID
    email:        string
    displayName:  string
    createdAt:    timestamp

listings/
  {listingId}/
    name:          string   // Place or service name
    category:      string   // "Hospital" | "Police Station" | "Library" | "Restaurant" | "Café" | "Park" | "Tourist Attraction" | "Pharmacy" | "Utility Office"
    address:       string
    contactNumber: string
    description:  string
    latitude:     number   // Geographic coordinates
    longitude:    number
    createdBy:    string   // Firebase Auth UID of creator
    timestamp:    timestamp
```

### Security Rules
- All authenticated users can **read** all listings
- Only the **owner** (`createdBy == request.auth.uid`) can **update** or **delete** their listing
- All authenticated users can **create** new listings

---

## State Management Architecture

This app uses **Provider** for state management with strict separation of concerns:

```
Firestore → ListingService → ListingProvider → UI Widgets
Firebase Auth → AuthService → AppAuthProvider → AuthGate → Screens
```

- **Services** (`lib/services/`): All Firebase API calls. No UI logic.
- **Providers** (`lib/providers/`): Expose service data to the UI. Handle loading/error states. UI widgets only call provider methods.
- **Screens** (`lib/screens/`): Use `context.watch<Provider>()` to rebuild when data changes. Never call Firebase directly.

---

## Folder Structure

```
lib/
├── main.dart                  # App entry, provider setup, AuthGate routing
├── firebase_options.dart      # Firebase configuration
├── models/
│   ├── user_profile.dart      # UserProfile data model
│   └── listing.dart           # Listing data model
├── services/
│   ├── auth_service.dart      # Firebase Auth + Firestore user profile
│   └── listing_service.dart   # Firestore CRUD for listings
├── providers/
│   ├── auth_provider.dart     # Auth state machine + user profile
│   └── listing_provider.dart  # Listings stream + search/filter + CRUD
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── verify_email_screen.dart
│   ├── home_shell.dart        # BottomNavigationBar container
│   ├── directory_screen.dart  # Browse all listings
│   ├── my_listings_screen.dart
│   ├── map_view_screen.dart
│   ├── settings_screen.dart
│   ├── listing_detail_screen.dart
│   └── add_edit_listing_screen.dart
└── widgets/
    ├── listing_card.dart
    └── category_chips.dart
```

---

## Firebase Setup

1. **Create Firebase Project**: [console.firebase.google.com](https://console.firebase.google.com)
2. **Enable Authentication**: Authentication → Sign-in method → Email/Password → Enable
3. **Create Firestore Database**: Firestore Database → Create database (start in test mode)
4. **Register Android App**:
   - Package name: `com.example.kigali_city_service`
   - Download `google-services.json` → place in `android/app/`
5. **Update `lib/firebase_options.dart`** with your project values, or run:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

## Google Maps Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable **Maps SDK for Android**
3. Create an API Key
4. Replace `AIzaSyAXCmy04gtBTiuz0B9OM6hWK1lteN3_wc8` in `android/app/src/main/AndroidManifest.xml`

---

## Running the App

```bash
flutter pub get
flutter run
```

For release build:
```bash
flutter build apk --release
```
