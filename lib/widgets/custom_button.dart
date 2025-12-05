import 'package:flutter/material.dart';
import '../views/app_styles.dart';

/// A customized button widget for authentication forms and actions.
///
/// Provides consistent styling with orange background and white text.
/// Supports disabled state and loading indicator.
class CustomButton extends StatelessWidget {
  /// Text displayed on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Whether to show loading indicator instead of text
  final bool isLoading;

  /// Background color (defaults to orange)
  final Color? backgroundColor;

  /// Text color (defaults to white)
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.orange,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: textColor ?? Colors.white,
          disabledForegroundColor: Colors.grey.shade600,
          elevation: isEnabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: normalText.copyWith(
                  color: isEnabled
                      ? (textColor ?? Colors.white)
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
