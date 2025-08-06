# Kill Switch

[//]: # ([![pub package]&#40;https://img.shields.io/pub/v/flutter_kill_switch.svg&#41;]&#40;https://pub.dev/packages/flutter_kill_switch&#41;)

[//]: # ([![License: MIT]&#40;https://img.shields.io/badge/License-MIT-yellow.svg&#41;]&#40;https://opensource.org/licenses/MIT&#41;)

A Flutter package that provides a **kill switch** functionality for your app using Firebase Firestore. This package allows app owners to remotely disable their app for users with a sleek, professional interface.

## ✨ Features

- 🎛️ **Professional Kill Switch UI** - Dark themed interface with large Cupertino-style switch
- 🔐 **Secure Confirmation System** - Custom keyboard with "IWANNAENABLE" confirmation
- 🔥 **Firebase Integration** - Real-time monitoring using Cloud Firestore
- 🚫 **Non-Dismissible App Blocking** - Complete app blocking when kill switch is active
- 📱 **Cross-Platform Support** - Works on both iOS and Android
- ⚡ **Real-time Updates** - Instant kill switch activation across all user devices

## 📋 Prerequisites

Before using this package, ensure you have:

### 1. Firebase Setup
Your Flutter app **must** have Firebase configured and initialized:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### 2. Firestore Database
- Cloud Firestore must be **enabled** in your Firebase project
- Set up appropriate Firestore security rules

### 3. Required Dependencies
Add these to your app's `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.17.0
  cloud_firestore: ^4.13.0
  flutter_kill_switch: ^1.0.0
```

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```bash
flutter pub add kill_switch
```

Or manually add to your `pubspec.yaml`:

```yaml
dependencies:
  kill_switch: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Step 1: Import the Package

```dart
import 'package:kill_switch/kill_switch.dart';
```

### Step 2: Wrap Your Main App

Wrap your main app widget with `KillSwitchWrapper` to enable monitoring:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: KillSwitchWrapper(
        child: YourMainScreen(), // Your app's main screen
      ),
    );
  }
}
```

### Step 3: Navigate to Kill Switch Screen

Replace your admin/settings navigation with:

```dart
// Instead of navigating to your custom admin screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => FlutterKillSwitch(), // Use the package screen
  ),
);
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kill_switch/kill_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: KillSwitchWrapper(
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to My App', style: TextStyle(fontSize: 24)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlutterKillSwitch(),
                  ),
                );
              },
              child: Text('Admin Panel'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🔧 How It Works

### Kill Switch Activation Process

1. **Admin navigates** to kill switch screen
2. **Toggle switch** to enable kill switch
3. **Confirmation dialog** appears with custom keyboard
4. **Type "IWANNAENABLE"** to confirm action
5. **Kill switch activates** and updates Firebase
6. **All user devices** receive the update instantly
7. **App blocking dialog** appears for all users
8. **Users must close** the app

### Firebase Firestore Structure

The package creates this structure in your Firestore database:

```
📁 IAmNothing/
  📁 NothingInsideMe/
    📁 WhyAreYouFollowingThisCollection/
      📄 here/
        ✅ FlutterKillSwitch: boolean
        📅 lastUpdated: timestamp
```

*Don't worry about the funny collection names - they're intentionally obscure for security! 🔒*

## 🎨 Screenshots

### Kill Switch Screen
- Dark themed interface matching modern design standards
- Large, responsive Cupertino switch
- Clear warning messages

### Confirmation Dialog
- Custom keyboard with capital letters only
- Real-time text validation with color feedback
- Secure confirmation process

### App Blocking Dialog
- Professional blocking interface
- Non-dismissible dialog (back button disabled)
- Clean "Close App" functionality

## 🔒 Security Features

- **Custom Collection Path**: Uses obscure Firestore paths
- **Confirmation Required**: Must type specific text to enable
- **Real-time Monitoring**: Instant activation across devices
- **Non-Dismissible**: Users cannot bypass the kill switch
- **Automatic Closure**: Forces app termination when active

## ⚠️ Important Notes

- **Firebase Required**: This package requires active Firebase/Firestore setup
- **Internet Connection**: Kill switch requires internet to function
- **Admin Access**: Only admins should have access to the kill switch screen
- **Testing**: Test thoroughly in development before production use
- **Backup Plan**: Have alternative communication channels with users

## 🐛 Troubleshooting

### Common Issues

**Firebase not initialized:**
```dart
// Ensure Firebase is initialized before runApp()
await Firebase.initializeApp();
```

**Firestore permissions:**
```javascript
// Update Firestore rules to allow read/write
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // Adjust as needed
    }
  }
}
```

**Kill switch not activating:**
- Check internet connection
- Verify Firestore setup
- Ensure KillSwitchWrapper is properly implemented

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Muzamil Ghafoor**

- GitHub: [@muzamilghafoor](https://github.com/muzzammil763)
- Email: deadbase763@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Open source community for inspiration

## 📊 Changelog

### [1.0.0] - 2025-01-XX
- Initial release
- Kill switch functionality
- Firebase integration
- Custom confirmation system
- App blocking feature

---

Made with ❤️ by [Muzamil Ghafoor](https://github.com/muzzammil763)