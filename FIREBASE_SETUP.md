# Firebase Setup Instructions

## Issue
You're getting the error: `Firebase has not been correctly initialized`

This happens because Flutter needs a `firebase_options.dart` file that contains your project's Firebase configuration.

## Solution

### Step 1: Install FlutterFire CLI
Run this command in your terminal:

```bash
dart pub global activate flutterfire_cli
```

### Step 2: Configure Firebase for Flutter
Navigate to your project directory and run:

```bash
cd /Users/tems/PulseBreak+/pulsebreak_plus
flutterfire configure
```

This command will:
1. Connect to your Firebase project
2. Generate the `lib/firebase_options.dart` file
3. Configure Firebase for all platforms (iOS, Android, Web)

### Step 3: Update main.dart (if needed)
Once the `firebase_options.dart` file is generated, we may need to update your main.dart to import it.

### What's happening?
- You already have `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- But Flutter also needs the `firebase_options.dart` file for initialization
- The FlutterFire CLI will generate this automatically from your existing Firebase project

### Expected Files After Setup:
- ✅ `android/app/google-services.json` (you have this)
- ✅ `ios/Runner/GoogleService-Info.plist` (you have this)
- ❌ `lib/firebase_options.dart` (missing - will be created)

Run the commands above and Firebase authentication should work perfectly!