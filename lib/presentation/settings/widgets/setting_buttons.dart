
import 'package:flutter/material.dart';

class SettingsButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isMobile;

  const SettingsButtons({
    Key? key,
    required this.onSave,
    required this.onCancel,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildElevatedButton('Save', onSave),
          // const SizedBox(height: 12),
          // _buildOutlinedButton('Cancel', onCancel, isDark: isDark),
        ],
      );
    } else {
      return Row(
        children: [
          // _buildOutlinedButton('Cancel', onCancel, isDark: isDark),
          // const SizedBox(width: 16),
          _buildElevatedButton('Save', onSave),
        ],
      );
    }
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        backgroundColor: const Color(0xFF6366F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.save_outlined, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildOutlinedButton(String text, VoidCallback onPressed,
  //     {bool isDark = false}) {
  //   return OutlinedButton(
  //     onPressed: onPressed,
  //     style: OutlinedButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
  //       side: const BorderSide(color: Color(0xFFD1D5DB)),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         if (text != "Cancel") ...[
  //           const Icon(Icons.save_outlined, size: 18, color: Colors.white),
  //           const SizedBox(width: 8),
  //         ],
  //         Text(
  //           text,
  //           style: TextStyle(
  //             color: isDark ? Colors.white : Colors.grey,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
