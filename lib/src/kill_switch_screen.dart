import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'confirmation_dialog.dart';
import 'firebase_service.dart';

/// A Flutter widget that provides an admin interface for controlling
/// the kill switch functionality of your application.
///
/// This widget displays a toggle switch that allows administrators to
/// enable or disable the kill switch state, which is synchronized with
/// Firebase Firestore in real-time.
///
/// ## Features
///
/// * **Real-time synchronization**: Changes are instantly reflected across all app instances
/// * **Confirmation dialog**: Prevents accidental enabling with a confirmation step
/// * **Dark theme design**: Matches modern app aesthetics
/// * **Responsive UI**: Adapts to different screen sizes
/// * **Error handling**: Gracefully handles network and Firebase errors
///
/// ## Usage
///
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const FlutterKillSwitch(),
///   ),
/// );
/// ```
///
/// ## Firebase Configuration
///
/// Ensure your Firebase project is configured with Firestore and the
/// necessary security rules are in place. The widget uses a specific
/// collection path for storing the kill switch state.
///
/// ## State Management
///
/// The widget maintains the following internal states:
/// * `_killSwitchEnabled`: Current state of the kill switch
/// * `_isLoading`: Whether the widget is loading the initial state
/// * `_showingDialog`: Whether the confirmation dialog is currently displayed
///
/// See also:
///
/// * [KillSwitchWrapper], which wraps your app to show blocking dialogs
/// * [KillSwitchDialog], the dialog shown to end users when kill switch is active
/// * [FirebaseService], the service that handles Firestore operations
class FlutterKillSwitch extends StatefulWidget {
  /// Creates a kill switch admin interface.
  ///
  /// This widget should typically be used in admin or settings screens
  /// where authorized users can control the kill switch functionality.
  const FlutterKillSwitch({super.key});

  @override
  FlutterKillSwitchState createState() => FlutterKillSwitchState();
}

class FlutterKillSwitchState extends State<FlutterKillSwitch> {
  bool _killSwitchEnabled = false;
  bool _isLoading = true;
  bool _showingDialog = false;
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<bool>? _killSwitchSubscription;

  @override
  void initState() {
    super.initState();
    _setupKillSwitchListener();
  }

  @override
  void dispose() {
    _killSwitchSubscription?.cancel();
    super.dispose();
  }

  void _setupKillSwitchListener() {
    _killSwitchSubscription = _firebaseService.listenToKillSwitchState().listen(
      (bool newState) {
        setState(() {
          _killSwitchEnabled = newState;
          _isLoading = false;
        });

        // Hide Dialog When Kill Switch Becomes False
        if (!newState && _showingDialog) {
          if (mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
            _showingDialog = false;
          }
        }
      },
      onError: (error) {
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _showConfirmationDialog() async {
    if (!mounted) return;

    _showingDialog = true;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(),
    );

    _showingDialog = false;

    if (result == true) {
      // User confirmed - set to true
      await _setKillSwitchState(true);
    } else {
      // User cancelled - ensure it's false (this will trigger listener to hide dialog)
      await _setKillSwitchState(false);
    }
  }

  Future<void> _setKillSwitchState(bool desiredState) async {
    try {
      await _firebaseService.setKillSwitchState(desiredState);

      debugPrint(desiredState
          ? 'Kill Switch Enabled Successfully'
          : 'Kill Switch Disabled Successfully');
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  Widget _buildCustomLoading() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1,
        strokeCap: StrokeCap.round,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2E),
      body: _isLoading
          ? Center(
              child: _buildCustomLoading(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    const Text(
                      'KILL SWITCH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    Transform.scale(
                      scale: 3,
                      child: CupertinoSwitch(
                        value: _killSwitchEnabled,
                        onChanged: (value) {
                          if (value) {
                            // Ask Confirmation First, Only Then Set TRUE
                            _showConfirmationDialog();
                          } else {
                            // Disable immediately
                            _setKillSwitchState(false);
                          }
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
    );
  }
}
