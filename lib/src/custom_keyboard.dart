import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  const CustomKeyboard({
    super.key,
    required this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<List<String>> keyboardLayout = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keyboardLayout.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildKey(key),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    bool isBackspace = key == '⌫';

    return InkWell(
      onTap: () => onKeyPressed(key),
      child: Container(
        width: isBackspace ? 60 : 32,
        height: 40,
        decoration: BoxDecoration(
          color: isBackspace ? Colors.red[700] : Colors.grey[700],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Center(
          child: Text(
            key,
            style: TextStyle(
              color: Colors.white,
              fontSize: isBackspace ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
