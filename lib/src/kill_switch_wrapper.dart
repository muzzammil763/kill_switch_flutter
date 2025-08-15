import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_service.dart';
import 'kill_switch_dialog.dart';

/// A wrapper widget that monitors the kill switch state and automatically
/// displays a blocking dialog when the kill switch is activated.
///
/// This widget should wrap your main app content to provide kill switch
/// functionality. When the kill switch is enabled in Firebase Firestore,
/// it will immediately show a [KillSwitchDialog] that prevents users from
/// accessing the app.
///
/// ## Features
///
/// * **Real-time monitoring**: Listens to Firebase Firestore for kill switch changes
/// * **Instant response**: Shows/hides dialog immediately when state changes
/// * **App blocking**: Completely blocks app access when kill switch is active
/// * **Graceful handling**: Properly manages dialog lifecycle and state
///
/// ## Usage
///
/// Wrap your main app widget with [KillSwitchWrapper]:
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: KillSwitchWrapper(
///         child: YourMainScreen(), // Your app's content
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Behavior
///
/// * When kill switch is **false**: Displays the child widget normally
/// * When kill switch is **true**: Shows blocking dialog and loading screen
/// * Dialog cannot be dismissed by user (barrierDismissible: false)
/// * Only way to close is through the "Close App" button which exits the app
///
/// See also:
///
/// * [FlutterKillSwitch], the admin interface for controlling the kill switch
/// * [KillSwitchDialog], the blocking dialog shown to users
/// * [FirebaseService], the service that handles Firestore operations
class KillSwitchWrapper extends StatefulWidget {
  /// The child widget to display when the kill switch is inactive.
  ///
  /// This is typically your main app content or home screen.
  final Widget child;

  /// Creates a kill switch wrapper.
  ///
  /// The [child] parameter is required and represents the widget to display
  /// when the kill switch is not active.
  const KillSwitchWrapper({
    super.key,
    required this.child,
  });

  @override
  KillSwitchWrapperState createState() => KillSwitchWrapperState();
}

class KillSwitchWrapperState extends State<KillSwitchWrapper> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isKillSwitchActive = false;
  bool _isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _firebaseService.listenToKillSwitchState().listen((isActive) {
      if (isActive && !_isDialogShown) {
        _showKillSwitchDialog();
      } else if (!isActive && _isDialogShown) {
        _hideKillSwitchDialog();
      }
      setState(() {
        _isKillSwitchActive = isActive;
      });
    });
  }

  void _showKillSwitchDialog() {
    if (!_isDialogShown) {
      setState(() {
        _isDialogShown = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopScope(
            canPop: false,
            child: KillSwitchDialog(
              onClose: () {
                SystemNavigator.pop();
              },
            ),
          ),
        );
      });
    }
  }

  void _hideKillSwitchDialog() {
    if (_isDialogShown && mounted) {
      setState(() {
        _isDialogShown = false;
      });
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isKillSwitchActive && _isDialogShown) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return widget.child;
  }
}
