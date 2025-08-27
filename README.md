# Kill Switch

[![pub package](https://img.shields.io/pub/v/kill_switch_flutter.svg)](https://pub.dev/packages/kill_switch_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ownership Available](https://img.shields.io/badge/Ownership-Available%20on%20Gumroad-FF6B6B)](https://deadbase.gumroad.com/l/muzzammil763)

<div align="center">
  <table>
    <tr>
      <td width="60%" valign="top">
        <h3>🎛️ Professional Kill Switch Solution</h3>
        <p>A Flutter Package That Provides A <strong>Kill Switch</strong> Functionality For Your App Using Firebase Firestore. This Package Allows App Owners To Remotely Disable Their App For Users With A Sleek, Professional Interface.</p>
        <br>
        <p>✨ <strong>Real-time synchronization</strong> across all devices</p>
        <p>🔒 <strong>Secure confirmation system</strong> prevents accidents</p>
        <p>🎨 <strong>Modern dark UI</strong> with professional design</p>
        <p>📱 <strong>Cross-platform support</strong> for iOS & Android</p>
        <p>⚡ <strong>Instant response</strong> without app restart</p>
      </td>
      <td width="40%" align="center" valign="middle">
        <img src="Images/Package Image.png" alt="Kill Switch Flutter Package" width="280"/>
      </td>
    </tr>
  </table>
</div>

## ✨ Features

- 🎛️ **Professional Kill Switch UI** - Dark themed interface with large Cupertino-style switch
- 🔥 **Firebase Integration** - Real-time monitoring using Cloud Firestore
- 🚫 **Non-Dismissible App Blocking** - Complete app blocking when kill switch is active
- 📱 **Cross-Platform Support** - Works on both iOS and Android
- ⚡ **Real-time Updates** - Instant kill switch activation/deactivation across all user devices
- 🎯 **Instant Dialog Management** - Dialogs appear and disappear instantly without app restart
- 📱 **Example App Included** - Complete demo app showing proper implementation
- 📚 **Comprehensive Documentation** - Full API documentation with Flutter-style comments

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
flutter pub add kill_switch_flutter
```

Or manually add to your `pubspec.yaml`:

```yaml
dependencies:
  kill_switch_flutter: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Step 1: Import the Package

```dart
import 'package:kill_switch_flutter/kill_switch_flutter.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kill_switch_flutter/kill_switch_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kill Switch Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2C2C2E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.white,
          surface: Color(0xFF2C2C2E),
        ),
      ),
      home: KillSwitchWrapper(
        child: MainDemoScreen(),
      ),
    );
  }
}

class MainDemoScreen extends StatelessWidget {
  const MainDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                'KILL SWITCH DEMO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'This screen demonstrates the Kill Switch functionality.\n\nWhen enabled, a dialog will appear instantly.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlutterKillSwitch(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Admin Panel - Toggle Kill Switch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Try enabling the kill switch in Admin Panel\nand return here to see the dialog.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🎨 Custom Themes

**New in v1.0.1!** The Kill Switch package now supports comprehensive theming to match your app's design.

### Basic Theme Usage

```dart
// Using built-in themes
KillSwitchWrapper(
  theme: KillSwitchTheme.dark(), // or .light()
  child: YourMainScreen(),
)

// Auto theme (adapts to system)
KillSwitchWrapper(
  theme: KillSwitchTheme.auto(context),
  child: YourMainScreen(),
)
```

### Custom Theme Configuration

Create your own theme with full control over colors, typography, and styling:

```dart
final customTheme = KillSwitchTheme(
  // Colors
  backgroundColor: Color(0xFF1A237E),
  primaryColor: Color(0xFF3F51B5),
  titleTextColor: Colors.white,
  bodyTextColor: Color(0xFFE8EAF6),
  buttonBackgroundColor: Color(0xFF3F51B5),
  buttonTextColor: Colors.white,
  
  // Layout & Styling
  borderRadius: 20.0,
  buttonBorderRadius: 10.0,
  iconSize: 45.0,
  dialogPadding: EdgeInsets.all(28.0),
  
  // Shadows & Borders
  shadowColor: Color(0x66000000),
  shadowBlurRadius: 25.0,
  shadowSpreadRadius: 8.0,
  borderColor: Color(0xFF5C6BC0),
  borderWidth: 2.0,
  
  // Typography
  titleTextStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  bodyTextStyle: TextStyle(
    fontSize: 16,
    color: Color(0xFFE8EAF6),
  ),
  buttonTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
);

KillSwitchWrapper(
  theme: customTheme,
  title: 'Custom Title',
  message: 'Custom maintenance message',
  buttonText: 'Exit',
  child: YourMainScreen(),
)
```

### Theme Properties

| Property | Type | Description |
|----------|------|-------------|
| `backgroundColor` | `Color?` | Dialog background color |
| `primaryColor` | `Color?` | Icon and accent color |
| `titleTextColor` | `Color?` | Title text color |
| `bodyTextColor` | `Color?` | Body text color |
| `buttonBackgroundColor` | `Color?` | Button background |
| `buttonTextColor` | `Color?` | Button text color |
| `borderRadius` | `double?` | Dialog corner radius |
| `buttonBorderRadius` | `double?` | Button corner radius |
| `shadowColor` | `Color?` | Dialog shadow color |
| `shadowBlurRadius` | `double?` | Shadow blur amount |
| `shadowSpreadRadius` | `double?` | Shadow spread amount |
| `iconSize` | `double?` | Lock icon size |
| `dialogPadding` | `EdgeInsets?` | Internal dialog padding |
| `borderColor` | `Color?` | Dialog border color |
| `borderWidth` | `double?` | Dialog border width |
| `titleTextStyle` | `TextStyle?` | Custom title styling |
| `bodyTextStyle` | `TextStyle?` | Custom body styling |
| `buttonTextStyle` | `TextStyle?` | Custom button styling |

### Admin Panel Theming

The admin panel also supports theming for confirmation dialogs:

```dart
FlutterKillSwitch(
  theme: customTheme,
  confirmationTitle: 'Enable Kill Switch?',
  confirmationMessage: 'This will block all users. Continue?',
  confirmButtonText: 'Yes, Enable',
  cancelButtonText: 'Cancel',
)
```

### Built-in Theme Presets

```dart
// Light theme
KillSwitchTheme.light()

// Dark theme  
KillSwitchTheme.dark()

// Auto theme (system-based)
KillSwitchTheme.auto(context)
```

### Theme Examples

**Material Design Blue:**
```dart
final blueTheme = KillSwitchTheme(
  backgroundColor: Color(0xFF1565C0),
  primaryColor: Color(0xFF42A5F5),
  titleTextColor: Colors.white,
  bodyTextColor: Color(0xFFE3F2FD),
  buttonBackgroundColor: Color(0xFF42A5F5),
  borderRadius: 16.0,
  iconSize: 40.0,
);
```

**Elegant Green:**
```dart
final greenTheme = KillSwitchTheme(
  backgroundColor: Color(0xFF2E7D32),
  primaryColor: Color(0xFF66BB6A),
  titleTextColor: Colors.white,
  bodyTextColor: Color(0xFFE8F5E8),
  buttonBackgroundColor: Color(0xFF66BB6A),
  borderRadius: 12.0,
  shadowBlurRadius: 15.0,
);
```

## 🎮 Running the Example

The package includes a complete example app. To run it:

```bash
cd example
flutter pub get
flutter run
```

The example demonstrates:
- Proper `KillSwitchWrapper` implementation
- Navigation to admin panel
- Real-time dialog showing/hiding
- Modern dark theme design

## 🔧 How It Works

### Kill Switch Activation Process

1. **Admin navigates** to kill switch screen
2. **Toggle switch** to enable kill switch
3. **Confirmation dialog** to confirm what you are doing
5. **Kill switch activates** and updates Firebase **only after confirmation**
6. **All user devices** receive the update instantly
7. **App blocking dialog** appears for all users immediately
8. **Users must close** the app

### Real-time Dialog Management

- **Instant Show**: Dialog appears immediately when kill switch becomes `true`
- **Instant Hide**: Dialog disappears immediately when kill switch becomes `false`
- **No Restart Required**: All changes happen in real-time without app restart
- **Cross-device Sync**: Changes sync instantly across all devices

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

- GitHub: [@muzzammil763](https://github.com/muzzammil763)
- Email: deadbase763@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Open source community for inspiration

## 📚 API Documentation

### FlutterKillSwitch Widget

The main admin interface for controlling the kill switch.

```dart
const FlutterKillSwitch({Key? key})
```

**Features:**
- Real-time Firebase Firestore synchronization
- Confirmation dialog with custom keyboard
- Dark theme design with improved layout
- Error handling with debug prints
- Responsive UI design

### KillSwitchWrapper Widget

Wraps your app to monitor kill switch state and show blocking dialogs.

```dart
const KillSwitchWrapper({
  Key? key,
  required Widget child,
})
```

**Parameters:**
- `child` (required): The widget to display when kill switch is inactive

**Features:**
- Real-time Firestore monitoring
- Instant dialog show/hide without app restart
- Non-dismissible blocking dialog
- Automatic app termination functionality
---

Made with ❤️ by [Muzamil Ghafoor](https://github.com/muzzammil763)