import 'package:flutter/material.dart';

/// Configuration class for customizing the appearance of kill switch dialogs
class KillSwitchTheme {
  /// Background color of the dialog container
  final Color? backgroundColor;

  /// Primary color used for icons and buttons
  final Color? primaryColor;

  /// Text color for titles
  final Color? titleTextColor;

  /// Text color for body text
  final Color? bodyTextColor;

  /// Button background color
  final Color? buttonBackgroundColor;

  /// Button text color
  final Color? buttonTextColor;

  /// Border radius for the dialog
  final double? borderRadius;

  /// Border radius for buttons
  final double? buttonBorderRadius;

  /// Shadow color for the dialog
  final Color? shadowColor;

  /// Shadow blur radius
  final double? shadowBlurRadius;

  /// Shadow spread radius
  final double? shadowSpreadRadius;

  /// Title text style
  final TextStyle? titleTextStyle;

  /// Body text style
  final TextStyle? bodyTextStyle;

  /// Button text style
  final TextStyle? buttonTextStyle;

  /// Icon size
  final double? iconSize;

  /// Dialog padding
  final EdgeInsets? dialogPadding;

  /// Whether to use dark theme automatically based on system settings
  final bool? useDarkTheme;

  /// Border color for the dialog
  final Color? borderColor;

  /// Border width for the dialog
  final double? borderWidth;

  /// Link color for rich content
  final Color? linkColor;

  /// Rich content text style
  final TextStyle? richContentTextStyle;

  /// Form input border color
  final Color? inputBorderColor;

  /// Form input background color
  final Color? inputBackgroundColor;

  /// Form input text color
  final Color? inputTextColor;

  /// Media content border radius
  final double? mediaBorderRadius;

  /// Maximum height for images in rich content
  final double? imageMaxHeight;

  /// Maximum width for images in rich content
  final double? imageMaxWidth;

  const KillSwitchTheme({
    this.backgroundColor,
    this.primaryColor,
    this.titleTextColor,
    this.bodyTextColor,
    this.buttonBackgroundColor,
    this.buttonTextColor,
    this.borderRadius,
    this.buttonBorderRadius,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.buttonTextStyle,
    this.iconSize,
    this.dialogPadding,
    this.useDarkTheme,
    this.borderColor,
    this.borderWidth,
    this.linkColor,
    this.richContentTextStyle,
    this.inputBorderColor,
    this.inputBackgroundColor,
    this.inputTextColor,
    this.mediaBorderRadius,
    this.imageMaxHeight,
    this.imageMaxWidth,
  });

  /// Creates a light theme with default values
  factory KillSwitchTheme.light() {
    return const KillSwitchTheme(
      backgroundColor: Colors.white,
      primaryColor: Colors.red,
      titleTextColor: Colors.black,
      bodyTextColor: Color(0xFF424242),
      buttonBackgroundColor: Colors.red,
      buttonTextColor: Colors.white,
      borderRadius: 16.0,
      buttonBorderRadius: 8.0,
      shadowColor: Color(0x4D000000),
      shadowBlurRadius: 20.0,
      shadowSpreadRadius: 5.0,
      iconSize: 40.0,
      dialogPadding: EdgeInsets.all(24.0),
      useDarkTheme: false,
      linkColor: Colors.blue,
      inputBorderColor: Color(0xFFE0E0E0),
      inputBackgroundColor: Colors.white,
      inputTextColor: Colors.black,
      mediaBorderRadius: 8.0,
      imageMaxHeight: 200.0,
      imageMaxWidth: double.infinity,
      borderWidth: 0.0,
    );
  }

  /// Creates a dark theme with default values
  factory KillSwitchTheme.dark() {
    return const KillSwitchTheme(
      backgroundColor: Color(0xFF1E1E1E),
      primaryColor: Color(0xFFE53E3E),
      titleTextColor: Colors.white,
      bodyTextColor: Color(0xFFB3B3B3),
      buttonBackgroundColor: Color(0xFFE53E3E),
      buttonTextColor: Colors.white,
      borderRadius: 16.0,
      buttonBorderRadius: 8.0,
      shadowColor: Color(0x66000000),
      shadowBlurRadius: 20.0,
      shadowSpreadRadius: 5.0,
      iconSize: 40.0,
      dialogPadding: EdgeInsets.all(24.0),
      useDarkTheme: true,
      borderColor: Color(0xFF404040),
      borderWidth: 1.0,
      linkColor: Color(0xFF64B5F6),
      inputBorderColor: Color(0xFF404040),
      inputBackgroundColor: Color(0xFF2A2A2A),
      inputTextColor: Colors.white,
      mediaBorderRadius: 8.0,
      imageMaxHeight: 200.0,
      imageMaxWidth: double.infinity,
    );
  }

  /// Creates an auto theme that adapts to system brightness
  factory KillSwitchTheme.auto(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark
        ? KillSwitchTheme.dark()
        : KillSwitchTheme.light();
  }

  /// Creates a copy of this theme with the given fields replaced
  KillSwitchTheme copyWith({
    Color? backgroundColor,
    Color? primaryColor,
    Color? titleTextColor,
    Color? bodyTextColor,
    Color? buttonBackgroundColor,
    Color? buttonTextColor,
    double? borderRadius,
    double? buttonBorderRadius,
    Color? shadowColor,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
    TextStyle? buttonTextStyle,
    double? iconSize,
    EdgeInsets? dialogPadding,
    bool? useDarkTheme,
    Color? borderColor,
    double? borderWidth,
    Color? linkColor,
    TextStyle? richContentTextStyle,
    Color? inputBorderColor,
    Color? inputBackgroundColor,
    Color? inputTextColor,
    double? mediaBorderRadius,
    double? imageMaxHeight,
    double? imageMaxWidth,
  }) {
    return KillSwitchTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      buttonBackgroundColor:
          buttonBackgroundColor ?? this.buttonBackgroundColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      borderRadius: borderRadius ?? this.borderRadius,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      bodyTextStyle: bodyTextStyle ?? this.bodyTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      iconSize: iconSize ?? this.iconSize,
      dialogPadding: dialogPadding ?? this.dialogPadding,
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      linkColor: linkColor ?? this.linkColor,
      richContentTextStyle: richContentTextStyle ?? this.richContentTextStyle,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      mediaBorderRadius: mediaBorderRadius ?? this.mediaBorderRadius,
      imageMaxHeight: imageMaxHeight ?? this.imageMaxHeight,
      imageMaxWidth: imageMaxWidth ?? this.imageMaxWidth,
    );
  }

  /// Gets the effective text style for titles
  TextStyle getEffectiveTitleTextStyle() {
    return titleTextStyle ??
        TextStyle(
          color: titleTextColor ?? Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
  }

  /// Gets the effective text style for body text
  TextStyle getEffectiveBodyTextStyle() {
    return bodyTextStyle ??
        TextStyle(
          color: bodyTextColor ?? const Color(0xFF424242),
          fontSize: 16,
          height: 1.4,
        );
  }

  /// Gets the effective text style for buttons
  TextStyle getEffectiveButtonTextStyle() {
    return buttonTextStyle ??
        TextStyle(
          color: buttonTextColor ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        );
  }
}