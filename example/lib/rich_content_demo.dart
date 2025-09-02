import 'package:flutter/material.dart';
import 'package:kill_switch_flutter/kill_switch.dart';

/// Demo screen showcasing rich content features in kill switch dialogs
class RichContentDemo extends StatefulWidget {
  const RichContentDemo({super.key});

  @override
  State<RichContentDemo> createState() => _RichContentDemoState();
}

class _RichContentDemoState extends State<RichContentDemo> {
  String selectedDemo = 'HTML Content';
  KillSwitchTheme currentTheme = KillSwitchTheme.dark();

  final Map<String, String> demoMessages = {
    'HTML Content': '''
<b>Service Temporarily Unavailable</b>

We are currently experiencing technical difficulties. 
<i>Our team is working hard to resolve this issue.</i>

For urgent matters, please contact us at:
<a href="mailto:support@example.com">support@example.com</a>

Thank you for your patience.
''',
    'Image Content': '''
Service Update Required

[img:https://via.placeholder.com/300x150/FF6B6B/FFFFFF?text=Update+Required]

Please update your app to continue using our services.
The new version includes important security improvements.
''',
    'Video Content': '''
Important Announcement

[video]https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4[/video]

Please watch this important message from our CEO regarding recent changes to our service.
''',
    'Interactive Forms': '''
Feedback Required

We value your opinion! Please help us improve by providing feedback:

[input:email]Your email address[/input]

[select:rating]Excellent,Good,Average,Poor[/select]

[checkbox:newsletter]Subscribe to our newsletter[/checkbox]

[button:submit]Submit Feedback[/button]
[button:skip]Skip for Now[/button]
''',
    'Mixed Content': '''
<b>System Maintenance</b>

[img:https://via.placeholder.com/250x100/4CAF50/FFFFFF?text=Maintenance+Mode]

Our system is currently under maintenance. 
<i>Expected completion time: 2 hours</i>

For real-time updates, visit:
<a href="https://status.example.com">status.example.com</a>

[input:email]Get notified when we're back online[/input]
[button:notify]Notify Me[/button]
''',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Rich Content Demo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2C2C2E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rich Content Features',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore different types of rich content in kill switch dialogs',
              style: TextStyle(color: Colors.white60, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Demo Type Selector
            const Text(
              'Select Demo Type:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: demoMessages.keys.map((demo) {
                return _buildDemoButton(demo);
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Theme Selector
            const Text(
              'Select Theme:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildThemeButton('Dark', KillSwitchTheme.dark()),
                _buildThemeButton('Light', KillSwitchTheme.light()),
                _buildThemeButton('Blue', _createCustomBlueTheme()),
                _buildThemeButton('Green', _createCustomGreenTheme()),
              ],
            ),

            const SizedBox(height: 40),

            // Preview Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preview Message:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    demoMessages[selectedDemo] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Show Dialog Button
            ElevatedButton(
              onPressed: _showRichContentDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Show Rich Content Dialog',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Note: This demo shows how rich content appears in kill switch dialogs. In a real app, these messages would be configured in your Firebase Firestore.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoButton(String demo) {
    final isSelected = selectedDemo == demo;
    return GestureDetector(
      onTap: () => setState(() => selectedDemo = demo),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.red
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          demo,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(String name, KillSwitchTheme theme) {
    final isSelected = currentTheme == theme;
    return GestureDetector(
      onTap: () => setState(() => currentTheme = theme),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showRichContentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: KillSwitchDialog(
          onClose: () => Navigator.of(context).pop(),
          theme: currentTheme,
          title: 'Rich Content Demo',
          message: demoMessages[selectedDemo],
          buttonText: 'Close Demo',
          enableRichContent: true,
          onFormAction: (action, data) {
            Navigator.of(context).pop();
            _showFormActionResult(action, data);
          },
        ),
      ),
    );
  }

  void _showFormActionResult(String action, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text(
          'Form Action Result',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Action: $action',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...data.entries.map(
              (entry) => Text(
                '${entry.key}: ${entry.value}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
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
      linkColor: Color(0xFF64B5F6),
      inputBorderColor: Color(0xFF5C6BC0),
      inputBackgroundColor: Color(0xFF283593),
      inputTextColor: Colors.white,
      mediaBorderRadius: 12.0,
      imageMaxHeight: 200.0,
      imageMaxWidth: double.infinity,
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
      linkColor: Color(0xFF81C784),
      inputBorderColor: Color(0xFF66BB6A),
      inputBackgroundColor: Color(0xFF2E7D32),
      inputTextColor: Colors.white,
      mediaBorderRadius: 8.0,
      imageMaxHeight: 200.0,
      imageMaxWidth: double.infinity,
    );
  }
}
