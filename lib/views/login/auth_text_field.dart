import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final bool isPasswordField;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode; // 👈 added

  const AuthTextField({
    super.key,
    required this.hintText,
    this.inputFormatters,
    this.prefixIcon,
    this.isPasswordField = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled, // 👈 default
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final ValueNotifier<bool> _obscureTextNotifier;

  @override
  void initState() {
    super.initState();
    _obscureTextNotifier = ValueNotifier<bool>(widget.isPasswordField);
  }

  @override
  void dispose() {
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldTextColor = isDark ? Colors.white : const Color(0xFF374151);
    final fillColor = isDark ? const Color(0xFF23272F) : const Color(0xFFF9FAFB);
    final hintColor = isDark ? Colors.grey[400] : const Color(0xFF9CA3AF);
    final borderColor = isDark ? Colors.grey.shade700 : const Color(0xFFE5E7EB);
    final focusColor = const Color(0xFF6366F1);
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, isObscured, _) {
        return TextFormField(
          autovalidateMode: widget.autovalidateMode,
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: isObscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(
            fontSize: 15,
            color: fieldTextColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 15,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      _obscureTextNotifier.value = !_obscureTextNotifier.value;
                    },
                    icon: Icon(
                      isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      size: 20,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 26,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: focusColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        );
      },
    );
  }
}
