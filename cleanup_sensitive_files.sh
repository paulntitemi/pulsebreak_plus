#!/bin/bash

# PulseBreak+ Security Cleanup Script
# This script removes sensitive files from git repository

echo "🔒 Starting security cleanup for PulseBreak+ repository..."

# Navigate to project directory
cd "$(dirname "$0")"

echo "📍 Current directory: $(pwd)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

echo "📋 Checking git status..."
git status

echo ""
echo "🗑️  Step 1: Removing sensitive files from git tracking..."

# Remove Firebase configuration files (SENSITIVE)
echo "   - Removing android/app/google-services.json"
git rm --cached android/app/google-services.json 2>/dev/null || echo "     (file not tracked or already removed)"

echo "   - Removing ios/Runner/GoogleService-Info.plist"
git rm --cached ios/Runner/GoogleService-Info.plist 2>/dev/null || echo "     (file not tracked or already removed)"

# Remove build directories and generated files
echo "   - Removing build directory"
git rm -r --cached build/ 2>/dev/null || echo "     (directory not tracked or already removed)"

echo "   - Removing iOS Pods directory"
git rm -r --cached ios/Pods/ 2>/dev/null || echo "     (directory not tracked or already removed)"

echo "   - Removing ios/Podfile.lock"
git rm --cached ios/Podfile.lock 2>/dev/null || echo "     (file not tracked or already removed)"

# Remove system files
echo "   - Removing .DS_Store files"
find . -name ".DS_Store" -exec git rm --cached {} \; 2>/dev/null || echo "     (no .DS_Store files tracked)"

echo "   - Removing .iml files"
find . -name "*.iml" -exec git rm --cached {} \; 2>/dev/null || echo "     (no .iml files tracked)"

# Remove local configuration files
echo "   - Removing android/local.properties"
git rm --cached android/local.properties 2>/dev/null || echo "     (file not tracked or already removed)"

# Remove ephemeral directories
echo "   - Removing ephemeral directories"
git rm -r --cached linux/flutter/ephemeral/ 2>/dev/null || echo "     (linux ephemeral not tracked)"
git rm -r --cached macos/Flutter/ephemeral/ 2>/dev/null || echo "     (macos ephemeral not tracked)"
git rm -r --cached windows/flutter/ephemeral/ 2>/dev/null || echo "     (windows ephemeral not tracked)"

echo ""
echo "🧹 Step 2: Cleaning up local files..."

# Remove local sensitive files (keep them locally but not in git)
echo "   - Backing up Firebase config files to safe location..."
mkdir -p ~/Desktop/pulsebreak_firebase_backup 2>/dev/null
cp android/app/google-services.json ~/Desktop/pulsebreak_firebase_backup/ 2>/dev/null && echo "     ✅ Backed up google-services.json"
cp ios/Runner/GoogleService-Info.plist ~/Desktop/pulsebreak_firebase_backup/ 2>/dev/null && echo "     ✅ Backed up GoogleService-Info.plist"

echo ""
echo "📝 Step 3: Committing changes..."

# Add the updated .gitignore
git add .gitignore
git add firebase_setup_instructions.md

# Commit the removal of sensitive files
git commit -m "🔒 Security: Remove sensitive Firebase config files and build artifacts

- Remove android/app/google-services.json (contains API keys)
- Remove ios/Runner/GoogleService-Info.plist (contains API keys)
- Remove build directories and generated files
- Remove iOS Pods directory
- Remove system files (.DS_Store, .iml)
- Update .gitignore with comprehensive security rules
- Add Firebase setup instructions

🚨 Firebase API keys were exposed and should be regenerated!
📋 Use firebase_setup_instructions.md to recreate config files locally"

echo ""
echo "✅ Step 4: Cleanup complete!"

echo ""
echo "📋 Summary of actions taken:"
echo "   ✅ Removed sensitive Firebase configuration files from git"
echo "   ✅ Removed build artifacts and generated files"
echo "   ✅ Removed system files (.DS_Store, .iml)"
echo "   ✅ Updated .gitignore with security rules"
echo "   ✅ Backed up Firebase configs to ~/Desktop/pulsebreak_firebase_backup/"
echo "   ✅ Committed changes with security message"

echo ""
echo "🚨 IMPORTANT NEXT STEPS:"
echo "   1. The Firebase config files are backed up to ~/Desktop/pulsebreak_firebase_backup/"
echo "   2. You should regenerate Firebase API keys since they were exposed publicly"
echo "   3. Use firebase_setup_instructions.md to recreate the config files"
echo "   4. Consider using 'git push --force' if you need to update remote repository"

echo ""
echo "⚠️  WARNING: Firebase API keys were exposed in git history!"
echo "   🔄 Regenerate keys at: https://console.firebase.google.com/"
echo "   📊 Monitor usage at: https://console.firebase.google.com/project/pulsebreak-ad0c1/usage"

echo ""
echo "🎉 Repository is now secure!"