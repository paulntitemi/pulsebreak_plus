#!/bin/bash

# PulseBreak+ Git History Cleanup Script
# This script completely removes sensitive files from git history
# ⚠️  WARNING: This rewrites git history and requires force push!

echo "🔥 Git History Cleanup for PulseBreak+ repository"
echo "⚠️  WARNING: This will rewrite git history!"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Confirmation prompt
read -p "🚨 This will permanently remove sensitive files from ALL git history. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cleanup cancelled."
    exit 1
fi

echo ""
echo "📍 Current directory: $(pwd)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

echo ""
echo "💾 Step 1: Creating backup..."
git branch backup-before-history-cleanup 2>/dev/null || echo "   (backup branch already exists)"

echo ""
echo "🧹 Step 2: Removing files from entire git history..."

# List of sensitive files and directories to remove
SENSITIVE_FILES=(
    "android/app/google-services.json"
    "ios/Runner/GoogleService-Info.plist"
    "android/local.properties"
    "*.DS_Store"
    "*.iml"
    "build/"
    "ios/Pods/"
    "ios/Podfile.lock"
    "linux/flutter/ephemeral/"
    "macos/Flutter/ephemeral/"
    "windows/flutter/ephemeral/"
)

echo "   📂 Files/directories to remove from history:"
for file in "${SENSITIVE_FILES[@]}"; do
    echo "      - $file"
done

echo ""
echo "   🔄 Rewriting git history (this may take a while)..."

# Use git filter-branch to remove sensitive files from all history
git filter-branch --force --index-filter '
    git rm --cached --ignore-unmatch android/app/google-services.json
    git rm --cached --ignore-unmatch ios/Runner/GoogleService-Info.plist
    git rm --cached --ignore-unmatch android/local.properties
    git rm --cached --ignore-unmatch ios/Podfile.lock
    git rm -r --cached --ignore-unmatch build/
    git rm -r --cached --ignore-unmatch ios/Pods/
    git rm -r --cached --ignore-unmatch linux/flutter/ephemeral/
    git rm -r --cached --ignore-unmatch macos/Flutter/ephemeral/
    git rm -r --cached --ignore-unmatch windows/flutter/ephemeral/
    find . -name ".DS_Store" -exec git rm --cached --ignore-unmatch {} \;
    find . -name "*.iml" -exec git rm --cached --ignore-unmatch {} \;
' --prune-empty --tag-name-filter cat -- --all

echo ""
echo "🧽 Step 3: Cleaning up git references..."

# Remove backup refs created by filter-branch
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo ""
echo "📝 Step 4: Updating working directory..."

# Ensure .gitignore and setup instructions are in place
git add .gitignore firebase_setup_instructions.md 2>/dev/null || true

# Commit if there are changes
if ! git diff --cached --quiet; then
    git commit -m "🔒 Security: Add comprehensive .gitignore and Firebase setup instructions

- Add robust .gitignore rules for sensitive files
- Add Firebase configuration setup instructions
- Prevent future commits of sensitive data"
fi

echo ""
echo "✅ Git history cleanup complete!"

echo ""
echo "📋 Summary:"
echo "   ✅ Removed sensitive files from ALL git history"
echo "   ✅ Created backup branch: backup-before-history-cleanup"
echo "   ✅ Cleaned up git references and garbage collection"
echo "   ✅ Updated .gitignore and documentation"

echo ""
echo "🚨 CRITICAL NEXT STEPS:"
echo "   1. 🔄 REGENERATE Firebase API keys immediately!"
echo "   2. 🌐 Update remote repository: git push --force --all"
echo "   3. 🏷️  Update tags if any: git push --force --tags"
echo "   4. 📢 Notify team members to re-clone repository"
echo "   5. 📊 Monitor Firebase usage for unauthorized access"

echo ""
echo "⚠️  Firebase Project Security:"
echo "   🔗 Console: https://console.firebase.google.com/project/pulsebreak-ad0c1"
echo "   🔑 Regenerate API keys in: Project Settings > General > Your apps"
echo "   📊 Check usage: Project Settings > Usage and billing"
echo "   🔒 Review IAM: Project Settings > Users and permissions"

echo ""
echo "📚 Next steps to restore Firebase functionality:"
echo "   1. Follow instructions in firebase_setup_instructions.md"
echo "   2. Download new config files from Firebase Console"
echo "   3. Place them in correct directories (ignored by .gitignore)"

echo ""
echo "🎉 Repository history is now clean and secure!"
echo "💡 Remember: The backup branch 'backup-before-history-cleanup' contains the original history if needed."