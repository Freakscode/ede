import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'app_header.dart';

/// Scaffold global de la aplicación que incluye el AppHeader
/// Se usa para rutas que necesitan header/layout global
class AppScaffold extends StatelessWidget {
  final Widget child;
  final AppBarType headerType;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSavePressed;
  final VoidCallback? onInfoPressed;
  final VoidCallback? onUserPressed;
  final VoidCallback? onLogoutPressed;
  final bool showBackButton;
  final bool showSaveButton;
  final bool showInfoButton;
  final bool showUserButton;
  final bool showLogoutButton;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.child,
    this.headerType = AppBarType.metodologiaAnalisis,
    this.title,
    this.subtitle,
    this.onBackPressed,
    this.onSavePressed,
    this.onInfoPressed,
    this.onUserPressed,
    this.onLogoutPressed,
    this.showBackButton = true,
    this.showSaveButton = false,
    this.showInfoButton = true,
    this.showUserButton = true,
    this.showLogoutButton = false,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: backgroundColor ?? DAGRDColors.azulDAGRD,
      appBar: AppHeader(
        type: headerType,
        title: title,
        subtitle: subtitle,
        onBackPressed: onBackPressed,
        onSavePressed: onSavePressed,
        onInfoPressed: onInfoPressed,
        onUserPressed: onUserPressed,
        onLogoutPressed: onLogoutPressed,
        showBackButton: showBackButton,
        showSaveButton: showSaveButton,
        showInfoButton: showInfoButton,
        showUserButton: showUserButton,
        showLogoutButton: showLogoutButton,
      ),
      floatingActionButton: floatingActionButton,
      body: child,
    );
  }
}
