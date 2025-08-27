import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'kill_switch_theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final KillSwitchTheme? theme;
  final String? title;
  final String? message;
  final String? confirmButtonText;
  final String? cancelButtonText;

  const ConfirmationDialog({
    super.key,
    this.theme,
    this.title,
    this.message,
    this.confirmButtonText,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? KillSwitchTheme.auto(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: effectiveTheme.dialogPadding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: effectiveTheme.backgroundColor ?? Colors.grey.shade900,
          borderRadius:
              BorderRadius.circular(effectiveTheme.borderRadius ?? 16),
          border: Border.all(
            color: effectiveTheme.borderColor ??
                effectiveTheme.primaryColor?.withValues(alpha: 0.5) ??
                Colors.red.withValues(alpha: 0.5),
            width: effectiveTheme.borderWidth ?? 1,
          ),
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: (effectiveTheme.primaryColor ?? Colors.red)
                    .withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_circle,
                color: effectiveTheme.primaryColor ?? Colors.red,
                size: effectiveTheme.iconSize ?? 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title ?? 'WARNING',
              style: effectiveTheme.titleTextStyle ??
                  TextStyle(
                    color: effectiveTheme.titleTextColor ?? Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              message ??
                  'Please Confirm That You Know What You Are Doing. This Action Will Enable The Kill Switch. Once The Kill Switch Turned On, The Only Way To Turn This of is From Database Manually',
              style: effectiveTheme.bodyTextStyle ??
                  TextStyle(
                    color: effectiveTheme.bodyTextColor ?? Colors.white70,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: effectiveTheme.backgroundColor
                              ?.withValues(alpha: 0.1) ??
                          Colors.white12,
                      foregroundColor:
                          effectiveTheme.bodyTextColor ?? Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            effectiveTheme.buttonBorderRadius ?? 8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      cancelButtonText ?? 'Cancel',
                      style: TextStyle(
                        color: effectiveTheme.bodyTextColor ?? Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: effectiveTheme.buttonBackgroundColor ??
                          Colors.red.shade700,
                      foregroundColor:
                          effectiveTheme.buttonTextColor ?? Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            effectiveTheme.buttonBorderRadius ?? 8),
                      ),
                    ),
                    child: Text(
                      confirmButtonText ?? 'Confirm',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
