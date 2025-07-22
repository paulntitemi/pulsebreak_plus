# Firebase Setup Instructions

## Overview
This app uses Firebase for authentication and other services. The configuration files are not included in the repository for security reasons.

## Setup Required Files

### 1. Android Firebase Configuration
Create `android/app/google-services.json` with your Firebase project configuration:

```json
{
  "project_info": {
    "project_number": "YOUR_PROJECT_NUMBER",
    "project_id": "YOUR_PROJECT_ID",
    "storage_bucket": "YOUR_PROJECT_ID.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "YOUR_ANDROID_APP_ID",
        "android_client_info": {
          "package_name": "com.example.pulsebreak_plus"
        }
      },
      "oauth_client": [
        {
          "client_id": "YOUR_OAUTH_CLIENT_ID",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "YOUR_API_KEY"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

### 2. iOS Firebase Configuration
Create `ios/Runner/GoogleService-Info.plist` with your Firebase iOS configuration:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CLIENT_ID</key>
    <string>YOUR_IOS_CLIENT_ID</string>
    <key>REVERSED_CLIENT_ID</key>
    <string>YOUR_REVERSED_CLIENT_ID</string>
    <key>API_KEY</key>
    <string>YOUR_IOS_API_KEY</string>
    <key>GCM_SENDER_ID</key>
    <string>YOUR_GCM_SENDER_ID</string>
    <key>PLIST_VERSION</key>
    <string>1</string>
    <key>BUNDLE_ID</key>
    <string>com.example.pulsebreakPlus</string>
    <key>PROJECT_ID</key>
    <string>YOUR_PROJECT_ID</string>
    <key>STORAGE_BUCKET</key>
    <string>YOUR_PROJECT_ID.appspot.com</string>
    <key>IS_ADS_ENABLED</key>
    <false/>
    <key>IS_ANALYTICS_ENABLED</key>
    <false/>
    <key>IS_APPINVITE_ENABLED</key>
    <true/>
    <key>IS_GCM_ENABLED</key>
    <true/>
    <key>IS_SIGNIN_ENABLED</key>
    <true/>
    <key>GOOGLE_APP_ID</key>
    <string>YOUR_GOOGLE_APP_ID</string>
</dict>
</plist>
```

## Getting Your Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing project
3. Add Android app with package name `com.example.pulsebreak_plus`
4. Add iOS app with bundle ID `com.example.pulsebreakPlus`
5. Download the respective configuration files
6. Place them in the correct directories as shown above

## Security Note
**NEVER commit these configuration files to version control!** They contain sensitive API keys and project information.