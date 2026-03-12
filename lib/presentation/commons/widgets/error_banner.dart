import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorBanner({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CustomColors.errorBannerBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.errorBannerBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: CustomColors.errorRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: CustomColors.errorBannerText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                size: 18,
                color: CustomColors.errorRed,
              ),
            ),
        ],
      ),
    );
  }
}
