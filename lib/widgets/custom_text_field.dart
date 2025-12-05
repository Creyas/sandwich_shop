import 'package:flutter/material.dart';
import '../views/app_styles.dart';

/// A customized text input field widget for authentication forms.
///
/// Provides consistent styling, validation feedback, and optional password visibility toggle.
/// Designed to match the app's visual design with orange accents.
class CustomTextField extends StatefulWidget {
  /// Label text displayed above the field
  final String label;

  /// Placeholder text shown when field is empty
  final String hint;

  /// Controller for managing the text input
  final TextEditingController controller;

  /// Type of keyboard to display
  final TextInputType keyboardType;

  /// Whether this is a password field (shows toggle button)
  final bool isPassword;

  /// Optional icon to display at the start of the field
  final IconData? prefixIcon;

  /// Error message to display (null if no error)
  final String? errorText;

  /// Callback fired when text changes
  final Function(String)? onChanged;

  /// Whether the field should auto-focus when displayed
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.errorText,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: normalText.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Text Field
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && _obscureText,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          style: normalText,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: normalText.copyWith(color: Colors.grey),

            // Prefix icon
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: Colors.grey)
                : null,

            // Password visibility toggle
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,

            // Border styling
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.errorText != null
                    ? Colors.red
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.errorText != null ? Colors.red : Colors.orange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            // Padding
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        // Error message
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: normalText.copyWith(
              color: Colors.red,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
