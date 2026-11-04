import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

enum AlertType { success, error, warning, info }

/// Centralized, beautifully themed alerts and notifications for CareCampus.
/// Provides consistent floating bottom footer banners and modal popups.
class AppAlerts {
  /// Displays a floating bottom footer banner (SnackBar) with icon, styled colors,
  /// and clear typography.
  static void showFooterBanner(
    BuildContext context, {
    required String message,
    AlertType type = AlertType.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    final isDark = AppTheme.isDark(context);
    Color accentColor;
    Color iconBg;
    IconData icon;

    switch (type) {
      case AlertType.success:
        accentColor = AppTheme.alertGreen;
        iconBg = isDark ? AppTheme.alertGreen.withValues(alpha: 0.2) : const Color(0xFFE8F8F0);
        icon = Icons.check_circle_rounded;
        break;
      case AlertType.error:
        accentColor = AppTheme.alertRed;
        iconBg = isDark ? AppTheme.alertRed.withValues(alpha: 0.2) : const Color(0xFFFFF3F3);
        icon = Icons.error_rounded;
        break;
      case AlertType.warning:
        accentColor = AppTheme.alertAmber;
        iconBg = isDark ? AppTheme.alertAmber.withValues(alpha: 0.2) : const Color(0xFFFFF8E1);
        icon = Icons.warning_rounded;
        break;
      case AlertType.info:
        accentColor = AppTheme.tealBlue;
        iconBg = isDark ? AppTheme.tealBlue.withValues(alpha: 0.2) : AppTheme.cloudBlue;
        icon = Icons.info_rounded;
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: isDark ? 0 : 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        backgroundColor: AppTheme.cardBg(context),
        duration: duration,
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.nunito(
                  color: AppTheme.textPrimary(context),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: accentColor,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  /// Shorthands for footer banners
  static void success(BuildContext context, String message) =>
      showFooterBanner(context, message: message, type: AlertType.success);

  static void error(BuildContext context, String message) =>
      showFooterBanner(context, message: message, type: AlertType.error);

  static void warning(BuildContext context, String message) =>
      showFooterBanner(context, message: message, type: AlertType.warning);

  static void info(BuildContext context, String message) =>
      showFooterBanner(context, message: message, type: AlertType.info);

  /// Shows a modal popup dialog for crucial alerts, errors, or confirmations.
  static Future<bool?> showPopupDialog(
    BuildContext context, {
    required String title,
    required String message,
    AlertType type = AlertType.info,
    String confirmText = 'OK',
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    final isDark = AppTheme.isDark(context);
    Color accentColor;
    Color iconBg;
    IconData icon;

    switch (type) {
      case AlertType.success:
        accentColor = AppTheme.alertGreen;
        iconBg = isDark ? AppTheme.alertGreen.withValues(alpha: 0.2) : const Color(0xFFE8F8F0);
        icon = Icons.check_circle_rounded;
        break;
      case AlertType.error:
        accentColor = AppTheme.alertRed;
        iconBg = isDark ? AppTheme.alertRed.withValues(alpha: 0.2) : const Color(0xFFFFF3F3);
        icon = Icons.error_rounded;
        break;
      case AlertType.warning:
        accentColor = AppTheme.alertAmber;
        iconBg = isDark ? AppTheme.alertAmber.withValues(alpha: 0.2) : const Color(0xFFFFF8E1);
        icon = Icons.warning_rounded;
        break;
      case AlertType.info:
        accentColor = AppTheme.tealBlue;
        iconBg = isDark ? AppTheme.tealBlue.withValues(alpha: 0.2) : AppTheme.cloudBlue;
        icon = Icons.info_rounded;
        break;
    }

    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.cardBg(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: isDark ? 0 : 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary(ctx),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: AppTheme.textSecondary(ctx),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary(ctx),
                          side: BorderSide(color: AppTheme.borderColor(ctx), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(
                          cancelText,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        confirmText,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
