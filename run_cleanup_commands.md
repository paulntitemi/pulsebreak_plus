# Git Commands to Run for Security Cleanup

## Copy and paste these commands one by one in your terminal:

```bash
# Navigate to project directory
cd "/Users/tems/PulseBreak+/pulsebreak_plus"

# Check current status
git status

# Remove sensitive Firebase files from git tracking
git rm --cached android/app/google-services.json
git rm --cached ios/Runner/GoogleService-Info.plist

# Remove build artifacts and unnecessary files
git rm -r --cached build/ 2>/dev/null || echo "build directory not tracked"
git rm -r --cached ios/Pods/ 2>/dev/null || echo "Pods directory not tracked"
git rm --cached ios/Podfile.lock 2>/dev/null || echo "Podfile.lock not tracked"

# Remove system files
find . -name ".DS_Store" -exec git rm --cached {} \; 2>/dev/null || echo "No .DS_Store files tracked"
find . -name "*.iml" -exec git rm --cached {} \; 2>/dev/null || echo "No .iml files tracked"

# Remove local properties
git rm --cached android/local.properties 2>/dev/null || echo "local.properties not tracked"

# Create backup of Firebase configs
mkdir -p ~/Desktop/pulsebreak_firebase_backup
cp android/app/google-services.json ~/Desktop/pulsebreak_firebase_backup/ 2>/dev/null && echo "Backed up google-services.json"
cp ios/Runner/GoogleService-Info.plist ~/Desktop/pulsebreak_firebase_backup/ 2>/dev/null && echo "Backed up GoogleService-Info.plist"

# Add updated files
git add .gitignore
git add firebase_setup_instructions.md
git add SECURITY_CLEANUP_README.md

# Commit the security changes
git commit -m "🔒 Security: Remove sensitive Firebase config files and build artifacts

- Remove android/app/google-services.json (contains API keys)
- Remove ios/Runner/GoogleService-Info.plist (contains API keys)  
- Remove build directories and generated files
- Remove iOS Pods directory
- Update .gitignore with comprehensive security rules
- Add Firebase setup instructions

🚨 Firebase API keys were exposed and should be regenerated!"

# Push changes
git push origin main

echo "✅ Basic cleanup complete!"
echo "🚨 IMPORTANT: Go to Firebase Console and regenerate your API keys!"
echo "📱 Your Firebase configs are backed up to ~/Desktop/pulsebreak_firebase_backup/"
```

## After running these commands:

1. **Regenerate Firebase API Keys:**
   - Go to https://console.firebase.google.com/project/pulsebreak-ad0c1
   - Delete and recreate your apps to get new API keys

2. **Restore Firebase functionality:**
   - Follow the instructions in `firebase_setup_instructions.md`
   - Place new config files in the correct directories

3. **Verify security:**
   - Run `git status` to ensure no sensitive files are tracked
   - Check that your app still builds and works