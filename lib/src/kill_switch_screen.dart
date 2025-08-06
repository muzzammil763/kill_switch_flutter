import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'confirmation_dialog.dart';
import 'firebase_service.dart';

class FlutterKillSwitch extends StatefulWidget {
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
        
        // Show dialog when kill switch becomes true
        if (newState && !_showingDialog) {
          _showingDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showConfirmationDialog();
          });
        }
        
        // Hide dialog when kill switch becomes false
        if (!newState && _showingDialog) {
          _showingDialog = false;
          if (mounted) {
            Navigator.of(context).pop();
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
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationDialog(),
    );

    _showingDialog = false;
    
    if (result == true) {
      // User confirmed, keep the kill switch enabled
      // The state is already true from the database
    } else {
      // User cancelled, disable the kill switch
      await _firebaseService.setKillSwitchState(false);
    }
  }

  Future<void> _toggleKillSwitch() async {
    try {
      bool newState = !_killSwitchEnabled;
      await _firebaseService.setKillSwitchState(newState);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_killSwitchEnabled
                ? 'Kill Switch Enabled Successfully'
                : 'Kill Switch Disabled Successfully'),
            backgroundColor: _killSwitchEnabled ? Colors.red : Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCustomLoading() {
    return Container(
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
                    // Kill Switch Title
                    const Text(
                      'KILL SWITCH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 80),

                    // Cupertino Switch - Larger
                    Transform.scale(
                      scale: 3.5,
                      child: CupertinoSwitch(
                        value: _killSwitchEnabled,
                        onChanged: (value) {
                          if (value) {
                            // When user tries to enable, the database listener will handle showing the dialog
                            _firebaseService.setKillSwitchState(true);
                          } else {
                            _toggleKillSwitch();
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }
}
