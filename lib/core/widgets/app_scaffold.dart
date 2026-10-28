import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_header.dart';

/// A ready-to-use page template widget for Spenza app.
///
/// Features:
/// - Standard [Scaffold] with configurable background color.
/// - Wraps the [body] inside a [SafeArea].
/// - Optional standard [appBar] parameter (for custom `PreferredSizeWidget`).
/// - Integrates the exact app header design (title, subtitle, custom back button, actions)
///   matching the majority of headers across the app when no custom `appBar` is provided.
class AppScaffold extends StatelessWidget {
  /// The main content/child widget of the page.
  final Widget body;

  /// Optional page title displayed in the standard header.
  final String? title;

  /// Optional custom title widget.
  final Widget? titleWidget;

  /// Optional subtitle displayed under the title in the standard header.
  final String? subtitle;

  /// Optional custom subtitle widget.
  final Widget? subtitleWidget;

  /// Whether to display the custom back button in the header (default: true).
  final bool showBackButton;

  /// Custom callback for the back button. Defaults to popping the router.
  final VoidCallback? onBackPressed;

  /// Action widgets displayed on the trailing side of the header.
  final List<Widget>? headerActions;

  /// Trailing widget in the header.
  final Widget? headerTrailingWidget;

  /// Bottom child widget in the header (e.g. search bar).
  final Widget? headerBottomChild;

  /// Style of the header ([AppHeaderStyle.light], [AppHeaderStyle.gradient], or [AppHeaderStyle.transparent]).
  final AppHeaderStyle headerStyle;

  /// Standard Flutter [PreferredSizeWidget] app bar. If provided, overrides the standard header.
  final PreferredSizeWidget? appBar;

  /// Background color of the Scaffold (default: [AppColors.neutralBackground]).
  final Color? backgroundColor;

  /// Floating Action Button for the Scaffold.
  final Widget? floatingActionButton;

  /// Floating Action Button location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom Navigation Bar widget.
  final Widget? bottomNavigationBar;

  /// Whether the body should resize when the keyboard appears (default: true).
  final bool resizeToAvoidBottomInset;

  /// Safe area top padding toggle (default: true).
  final bool safeAreaTop;

  /// Safe area bottom padding toggle (default: true).
  final bool safeAreaBottom;

  /// Optional padding around the [body].
  final EdgeInsetsGeometry? bodyPadding;

  /// Automatically wraps the [body] in a [SingleChildScrollView] if true.
  final bool isScrollable;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.headerActions,
    this.headerTrailingWidget,
    this.headerBottomChild,
    this.headerStyle = AppHeaderStyle.light,
    this.appBar,
    this.backgroundColor = AppColors.neutralBackground,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.bodyPadding,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasHeader = title != null ||
        titleWidget != null ||
        subtitle != null ||
        subtitleWidget != null ||
        headerBottomChild != null ||
        showBackButton;

    Widget content = bodyPadding != null
        ? Padding(padding: bodyPadding!, child: body)
        : body;

    if (isScrollable) {
      content = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    final safeAreaBody = SafeArea(
      top: safeAreaTop && (appBar == null && !hasHeader),
      bottom: safeAreaBottom,
      child: content,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        children: [
          if (appBar == null && hasHeader)
            AppHeader(
              title: title,
              titleWidget: titleWidget,
              subtitle: subtitle,
              subtitleWidget: subtitleWidget,
              showBackButton: showBackButton,
              onBackPressed: onBackPressed,
              trailingActions: headerActions,
              trailingWidget: headerTrailingWidget,
              bottomChild: headerBottomChild,
              style: headerStyle,
            ),
          Expanded(child: safeAreaBody),
        ],
      ),
    );
  }
}
