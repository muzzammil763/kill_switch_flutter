import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that renders interactive forms and buttons in kill switch dialogs
class InteractiveFormsWidget extends StatefulWidget {
  final String content;
  final Function(String action, Map<String, dynamic> data)? onAction;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final Color? textColor;

  const InteractiveFormsWidget({
    super.key,
    required this.content,
    this.onAction,
    this.padding,
    this.buttonColor,
    this.textColor,
  });

  @override
  State<InteractiveFormsWidget> createState() => _InteractiveFormsWidgetState();
}

class _InteractiveFormsWidgetState extends State<InteractiveFormsWidget> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: _buildInteractiveContent(context),
    );
  }

  Widget _buildInteractiveContent(BuildContext context) {
    List<Widget> widgets = [];
    String remainingContent = widget.content;

    // Process buttons
    while (remainingContent.contains(RegExp(
        r'\[button:([^\]]+)\]([^\[]+)\[/button\]',
        caseSensitive: false))) {
      final buttonMatch = RegExp(r'\[button:([^\]]+)\]([^\[]+)\[/button\]',
              caseSensitive: false)
          .firstMatch(remainingContent);

      if (buttonMatch == null) break;

      // Add text before button
      final beforeButton = remainingContent.substring(0, buttonMatch.start);
      if (beforeButton.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeButton, context));
      }

      // Add button widget
      final action = buttonMatch.group(1) ?? '';
      final buttonText = buttonMatch.group(2) ?? '';
      widgets.add(_buildButton(action, buttonText, context));

      // Update remaining content
      remainingContent = remainingContent.substring(buttonMatch.end);
    }

    // Process input fields
    while (remainingContent.contains(RegExp(
        r'\[input:([^\]]+)\]([^\[]+)\[/input\]',
        caseSensitive: false))) {
      final inputMatch =
          RegExp(r'\[input:([^\]]+)\]([^\[]+)\[/input\]', caseSensitive: false)
              .firstMatch(remainingContent);

      if (inputMatch == null) break;

      // Add text before input
      final beforeInput = remainingContent.substring(0, inputMatch.start);
      if (beforeInput.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeInput, context));
      }

      // Add input widget
      final fieldName = inputMatch.group(1) ?? '';
      final placeholder = inputMatch.group(2) ?? '';
      widgets.add(_buildInputField(fieldName, placeholder, context));

      // Update remaining content
      remainingContent = remainingContent.substring(inputMatch.end);
    }

    // Process checkboxes
    while (remainingContent.contains(RegExp(
        r'\[checkbox:([^\]]+)\]([^\[]+)\[/checkbox\]',
        caseSensitive: false))) {
      final checkboxMatch = RegExp(
              r'\[checkbox:([^\]]+)\]([^\[]+)\[/checkbox\]',
              caseSensitive: false)
          .firstMatch(remainingContent);

      if (checkboxMatch == null) break;

      // Add text before checkbox
      final beforeCheckbox = remainingContent.substring(0, checkboxMatch.start);
      if (beforeCheckbox.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeCheckbox, context));
      }

      // Add checkbox widget
      final fieldName = checkboxMatch.group(1) ?? '';
      final label = checkboxMatch.group(2) ?? '';
      widgets.add(_buildCheckbox(fieldName, label, context));

      // Update remaining content
      remainingContent = remainingContent.substring(checkboxMatch.end);
    }

    // Process dropdown/select fields
    while (remainingContent.contains(RegExp(
        r'\[select:([^\]]+)\]([^\[]+)\[/select\]',
        caseSensitive: false))) {
      final selectMatch = RegExp(r'\[select:([^\]]+)\]([^\[]+)\[/select\]',
              caseSensitive: false)
          .firstMatch(remainingContent);

      if (selectMatch == null) break;

      // Add text before select
      final beforeSelect = remainingContent.substring(0, selectMatch.start);
      if (beforeSelect.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeSelect, context));
      }

      // Add select widget
      final fieldName = selectMatch.group(1) ?? '';
      final optionsString = selectMatch.group(2) ?? '';
      final options = optionsString.split(',').map((e) => e.trim()).toList();
      widgets.add(_buildDropdown(fieldName, options, context));

      // Update remaining content
      remainingContent = remainingContent.substring(selectMatch.end);
    }

    // Add any remaining text
    if (remainingContent.trim().isNotEmpty) {
      widgets.add(_buildTextContent(remainingContent, context));
    }

    // If no interactive content found, return original content as text
    if (widgets.isEmpty) {
      return _buildTextContent(widget.content, context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget _buildTextContent(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: widget.textColor,
            ),
      ),
    );
  }

  Widget _buildButton(String action, String buttonText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          widget.onAction?.call(action, Map.from(_formData));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor ?? Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String fieldName, String placeholder, BuildContext context) {
    if (!_controllers.containsKey(fieldName)) {
      _controllers[fieldName] = TextEditingController();
      _controllers[fieldName]!.addListener(() {
        _formData[fieldName] = _controllers[fieldName]!.text;
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controllers[fieldName],
        decoration: InputDecoration(
          hintText: placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.buttonColor ?? Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: TextStyle(color: widget.textColor),
      ),
    );
  }

  Widget _buildCheckbox(String fieldName, String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: _formData[fieldName] ?? false,
            onChanged: (value) {
              setState(() {
                _formData[fieldName] = value ?? false;
              });
            },
            activeColor: widget.buttonColor ?? Theme.of(context).primaryColor,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _formData[fieldName] = !(_formData[fieldName] ?? false);
                });
              },
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.textColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String fieldName, List<String> options, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: _formData[fieldName],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.buttonColor ?? Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        hint: Text(
          'Select an option',
          style: TextStyle(color: widget.textColor?.withValues(alpha: 0.6)),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: TextStyle(color: widget.textColor),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _formData[fieldName] = value;
          });
        },
        dropdownColor: DialogThemeData().backgroundColor,
      ),
    );
  }
}

/// Data class for form actions
class FormAction {
  final String action;
  final Map<String, dynamic> data;

  const FormAction({
    required this.action,
    required this.data,
  });

  @override
  String toString() {
    return 'FormAction(action: $action, data: $data)';
  }
}
