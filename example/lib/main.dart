import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kill_switch_example_mock/firebase_options.dart';
import 'package:kill_switch_flutter/kill_switch.dart';
import 'rich_content_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KillSwitchTheme? _selectedTheme;
  String _themeName = 'Auto (System)';

  void _updateTheme(KillSwitchTheme theme, String name) {
    setState(() {
      _selectedTheme = theme;
      _themeName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kill Switch Example',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2C2C2E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.white,
          surface: Color(0xFF2C2C2E),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: Builder(
        builder: (context) {
          final effectiveTheme =
              _selectedTheme ?? KillSwitchTheme.auto(context);
          return KillSwitchWrapper(
            theme: effectiveTheme,
            title: 'App Temporarily Unavailable',
            message:
                'This app is currently under maintenance. Please try again later.',
            buttonText: 'Exit App',
            child: MainDemoScreen(
              selectedTheme: effectiveTheme,
              themeName: _themeName,
              onThemeChanged: _updateTheme,
            ),
          );
        },
      ),
    );
  }
}

class MainDemoScreen extends StatelessWidget {
  final KillSwitchTheme selectedTheme;
  final String themeName;
  final Function(KillSwitchTheme, String) onThemeChanged;

  const MainDemoScreen({
    super.key,
    required this.selectedTheme,
    required this.themeName,
    required this.onThemeChanged,
  });

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
              const SizedBox(height: 32),
              const Text(
                'This Screen Demonstrates The Kill Switch Functionality. When Enabled, A Dialog Will Appear Instantly.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Theme Selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Theme: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      themeName,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildThemeButton('Auto (System)', null),
                        _buildThemeButton('Light', KillSwitchTheme.light()),
                        _buildThemeButton('Dark', KillSwitchTheme.dark()),
                        _buildThemeButton(
                          'Custom Blue',
                          _createCustomBlueTheme(),
                        ),
                        _buildThemeButton(
                          'Custom Green',
                          _createCustomGreenTheme(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlutterKillSwitch(
                          theme: selectedTheme,
                          confirmationTitle: 'Enable Kill Switch?',
                          confirmationMessage:
                              'This will block all users from accessing the app. Are you sure you want to continue?',
                          confirmButtonText: 'Yes, Enable',
                          cancelButtonText: 'Cancel',
                        ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RichContentDemo(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Rich Content Demo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Try different themes and enable the kill switch to see how the dialogs adapt to your chosen theme. Use the Rich Content Demo to explore HTML, images, videos, and interactive forms.',
                style: TextStyle(color: Colors.white60, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(String name, KillSwitchTheme? theme) {
    final isSelected = themeName == name;
    return GestureDetector(
      onTap: () => onThemeChanged(theme ?? KillSwitchTheme.light(), name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  KillSwitchTheme _createCustomBlueTheme() {
    return const KillSwitchTheme(
      backgroundColor: Color(0xFF1A237E),
      primaryColor: Color(0xFF3F51B5),
      titleTextColor: Colors.white,
      bodyTextColor: Color(0xFFE8EAF6),
      buttonBackgroundColor: Color(0xFF3F51B5),
      buttonTextColor: Colors.white,
      borderRadius: 20.0,
      buttonBorderRadius: 10.0,
      shadowColor: Color(0x66000000),
      shadowBlurRadius: 25.0,
      shadowSpreadRadius: 8.0,
      iconSize: 45.0,
      dialogPadding: EdgeInsets.all(28.0),
      borderColor: Color(0xFF5C6BC0),
      borderWidth: 2.0,
    );
  }

  KillSwitchTheme _createCustomGreenTheme() {
    return const KillSwitchTheme(
      backgroundColor: Color(0xFF1B5E20),
      primaryColor: Color(0xFF4CAF50),
      titleTextColor: Colors.white,
      bodyTextColor: Color(0xFFE8F5E8),
      buttonBackgroundColor: Color(0xFF4CAF50),
      buttonTextColor: Colors.white,
      borderRadius: 12.0,
      buttonBorderRadius: 6.0,
      shadowColor: Color(0x66000000),
      shadowBlurRadius: 15.0,
      shadowSpreadRadius: 3.0,
      iconSize: 35.0,
      dialogPadding: EdgeInsets.all(20.0),
      borderColor: Color(0xFF66BB6A),
      borderWidth: 1.5,
    );
  }
}
