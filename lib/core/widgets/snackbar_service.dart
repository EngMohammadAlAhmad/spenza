import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_radius.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class SnackbarConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const SnackbarConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });
}

class SnackbarService {
  static final Map<SnackbarType, SnackbarConfig> _configs = {
    SnackbarType.success: const SnackbarConfig(
      backgroundColor: Color(0xFF10B981), // Green
      foregroundColor: Colors.white,
      icon: Icons.check_circle_outline,
    ),
    SnackbarType.error: const SnackbarConfig(
      backgroundColor: Color(0xFFEF4444), // Red
      foregroundColor: Colors.white,
      icon: Icons.error_outline,
    ),
    SnackbarType.warning: const SnackbarConfig(
      backgroundColor: Color(0xFFF59E0B), // Orange
      foregroundColor: Colors.white,
      icon: Icons.warning_amber_outlined,
    ),
    SnackbarType.info: const SnackbarConfig(
      backgroundColor: Color(0xFF3B82F6), // Blue
      foregroundColor: Colors.white,
      icon: Icons.info_outline,
    ),
  };

  /// Show a snackbar with full customization
  static void show(
      BuildContext context, {
        required String message,
        SnackbarType type = SnackbarType.success,
        String? title,
        Duration duration = const Duration(seconds: 3),
        bool showCloseButton = true,
        Color? backgroundColor,
        Color? foregroundColor,
        IconData? icon,
        VoidCallback? onTap,
      }) {
    final config = _configs[type]!;
    final effectiveBackgroundColor = backgroundColor ?? config.backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? config.foregroundColor;
    final effectiveIcon = icon ?? config.icon;

    // Get the overlay to show snackbar on top of everything
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _SnackbarOverlay(
        message: message,
        title: title,
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        icon: effectiveIcon,
        duration: duration,
        showCloseButton: showCloseButton,
        onTap: onTap,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// Convenience method for success snackbar
  static void showSuccess(
      BuildContext context, {
        required String message,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  /// Convenience method for error snackbar
  static void showError(
      BuildContext context, {
        required String message,
        String? title,
        Duration duration = const Duration(seconds: 4),
      }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  /// Convenience method for warning snackbar
  static void showWarning(
      BuildContext context, {
        required String message,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  /// Convenience method for info snackbar
  static void showInfo(
      BuildContext context, {
        required String message,
        String? title,
        Duration duration = const Duration(seconds: 3),
      }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackbarType.info,
      duration: duration,
    );
  }
}

class _SnackbarOverlay extends StatefulWidget {
  final String message;
  final String? title;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final Duration duration;
  final bool showCloseButton;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _SnackbarOverlay({
    required this.message,
    this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.duration,
    required this.showCloseButton,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<_SnackbarOverlay> createState() => _SnackbarOverlayState();
}

class _SnackbarOverlayState extends State<_SnackbarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: AppRadius.medium,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 600
                          ? (MediaQuery.of(context).size.width - 600) / 2
                          : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: AppRadius.medium,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: widget.foregroundColor.withValues(alpha: 0.2),
                            borderRadius: AppRadius.small,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.foregroundColor,
                            size: 22.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),

                        // Message Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.title != null) ...[
                                Text(
                                  widget.title!,
                                  style: TextStyle(
                                    color: widget.foregroundColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                              ],
                              Text(
                                widget.message,
                                style: TextStyle(
                                  color: widget.foregroundColor
                                      .withValues(alpha: 0.95),
                                  fontSize: 14.0,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Close Button
                        if (widget.showCloseButton) ...[
                          const SizedBox(width: 8.0),
                          InkWell(
                            onTap: _dismiss,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.close,
                                color: widget.foregroundColor
                                    .withValues(alpha: 0.8),
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}