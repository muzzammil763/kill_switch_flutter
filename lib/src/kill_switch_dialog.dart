import 'package:flutter/material.dart';
import 'kill_switch_theme.dart';

class KillSwitchDialog extends StatelessWidget {
  final VoidCallback onClose;
  final KillSwitchTheme? theme;
  final String? title;
  final String? message;
  final String? buttonText;

  const KillSwitchDialog({
    super.key,
    required this.onClose,
    this.theme,
    this.title,
    this.message,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? KillSwitchTheme.auto(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: effectiveTheme.dialogPadding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: effectiveTheme.backgroundColor ?? Colors.white,
          borderRadius:
              BorderRadius.circular(effectiveTheme.borderRadius ?? 16),
          border: effectiveTheme.borderWidth != null &&
                  effectiveTheme.borderWidth! > 0
              ? Border.all(
                  color: effectiveTheme.borderColor ?? Colors.transparent,
                  width: effectiveTheme.borderWidth!,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: effectiveTheme.shadowColor ??
                  Colors.black.withValues(alpha: 0.3),
              blurRadius: effectiveTheme.shadowBlurRadius ?? 20,
              spreadRadius: effectiveTheme.shadowSpreadRadius ?? 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: effectiveTheme.primaryColor ?? Colors.red,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.lock,
                color: effectiveTheme.buttonTextColor ?? Colors.white,
                size: effectiveTheme.iconSize ?? 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title ?? 'Currently Unavailable',
              style: effectiveTheme.getEffectiveTitleTextStyle(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message ??
                    'Please Try Again Later Or Contact Support For Assistance.',
                style: effectiveTheme.getEffectiveBodyTextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      effectiveTheme.buttonBackgroundColor ?? Colors.red,
                  foregroundColor:
                      effectiveTheme.buttonTextColor ?? Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        effectiveTheme.buttonBorderRadius ?? 8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText ?? 'Close App',
                  style: effectiveTheme.getEffectiveButtonTextStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
