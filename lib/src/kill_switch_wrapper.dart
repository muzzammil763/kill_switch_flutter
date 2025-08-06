import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_service.dart';
import 'kill_switch_dialog.dart';

class KillSwitchWrapper extends StatefulWidget {
  final Widget child;

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
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
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
