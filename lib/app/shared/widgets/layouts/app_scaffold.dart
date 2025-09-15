import 'package:flutter/material.dart';
import 'app_main_bar.dart';

/// Scaffold global de la aplicación que incluye el AppMainBar
/// Se usa para rutas que necesitan header/layout global
class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onUserPressed;
  final bool showBackButton;
  final bool showInfoButton;
  final bool showUserButton;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onBackPressed,
    this.onInfoPressed,
    this.onUserPressed,
    this.showBackButton = true,
    this.showInfoButton = true,
    this.showUserButton = true,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.grey[50],
      appBar: AppMainBar(
        showBack: showBackButton,
        showInfo: showInfoButton,
        showProfile: showUserButton,
        onBack: onBackPressed,
        onInfo: onInfoPressed,
        onProfile: onUserPressed,
      ),
      floatingActionButton: floatingActionButton,
      body: child,
    );
  }
}
