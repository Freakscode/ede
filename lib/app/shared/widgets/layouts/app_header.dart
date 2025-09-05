import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

/// Enum para los diferentes tipos de AppBar según la imagen
enum AppBarType {
  metodologiaAnalisis, // Header 1: Metodología de Análisis del Riesgo
  logosCompletos, // Header 2: Con logos institucionales completos
  logosSimples, // Header 3: Con logos institucionales simples
  logoSingle, // Header 4: Con un solo logo institucional
  cajaHerramientas, // Header 5: Caja de Herramientas DAGRD
}

/// AppBar personalizado que replica exactamente los diseños de la imagen
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType type;
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

  const AppHeader({
    super.key,
    required this.type,
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
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DAGRDColors.azulDAGRD, // Color azul DAGRD
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24), // ajusta el radio a tu diseño
        ),
      ),
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _buildAppBarContent(),
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    switch (type) {
      case AppBarType.metodologiaAnalisis:
        return _buildMetodologiaAnalisisAppBar();
      case AppBarType.logosCompletos:
        return _buildLogosCompletosAppBar();
      case AppBarType.logosSimples:
        return _buildLogosSimplestAppBar();
      case AppBarType.logoSingle:
        return _buildLogoSingleAppBar();
      case AppBarType.cajaHerramientas:
        return _buildCajaHerramientasAppBar();
    }
  }

  /// AppBar 1: Metodología de Análisis del Riesgo
  Widget _buildMetodologiaAnalisisAppBar() {
    return Row(
      children: [
        // Botón de retroceso amarillo
        if (showBackButton)
          _buildYellowCircleButton(
            icon: Icons.arrow_back,
            onPressed: onBackPressed,
          ),

        const SizedBox(width: 16),

        // Título en dos líneas
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? 'Metodología de',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle ?? 'Análisis del Riesgo',
                style: const TextStyle(
                  color: DAGRDColors.amarDAGRD,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Botón de guardar/archivo
        if (showSaveButton)
          _buildYellowCircleButton(
            icon: Icons.save,
            onPressed: onSavePressed,
          ),

        if (showSaveButton && showInfoButton) const SizedBox(width: 12),

        // Botón de información/pregunta
        if (showInfoButton)
          _buildYellowCircleButton(
            icon: Icons.help_outline,
            onPressed: onInfoPressed,
          ),
      ],
    );
  }

  /// AppBar 2: Logos institucionales completos con botones amarillos
  Widget _buildLogosCompletosAppBar() {
    return Row(
      children: [
        // Botón de retroceso
        if (showBackButton)
          _buildYellowCircleButton(
            icon: Icons.arrow_back,
            onPressed: onBackPressed,
          ),

        const SizedBox(width: 16),

        // Logos institucionales centrales
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInstitutionalLogo(48), // Logo 1
              const SizedBox(width: 20),
              _buildInstitutionalLogo(48), // Logo 2
              const SizedBox(width: 20),
              _buildInstitutionalLogo(48), // Logo 3
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Botón de información
        if (showInfoButton)
          _buildYellowCircleButton(
            icon: Icons.help_outline,
            onPressed: onInfoPressed,
          ),

        if (showInfoButton && showLogoutButton) const SizedBox(width: 12),

        // Botón de logout
        if (showLogoutButton)
          _buildYellowCircleButton(
            icon: Icons.logout,
            onPressed: onLogoutPressed,
          ),
      ],
    );
  }

  /// AppBar 3: Logos institucionales con botones simples (sin círculo amarillo)
  Widget _buildLogosSimplestAppBar() {
    return Row(
      children: [
        // Botón de retroceso simple
        if (showBackButton)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: onBackPressed,
          ),

        // Logos institucionales centrales
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInstitutionalLogo(40), // Logo 1
              const SizedBox(width: 16),
              _buildInstitutionalLogo(40), // Logo 2
              const SizedBox(width: 16),
              _buildInstitutionalLogo(40), // Logo 3
            ],
          ),
        ),

        // Botón de información simple
        if (showInfoButton)
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onInfoPressed,
          ),

        // Botón de logout simple
        if (showLogoutButton)
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onLogoutPressed,
          ),
      ],
    );
  }

  /// AppBar 4: Un solo logo institucional
  Widget _buildLogoSingleAppBar() {
    return Row(
      children: [
        // Botón de retroceso amarillo
        if (showBackButton)
          _buildYellowCircleButton(
            icon: Icons.arrow_back,
            onPressed: onBackPressed,
          ),

        const SizedBox(width: 16),

        // Logo institucional central
        Expanded(child: Center(child: _buildInstitutionalLogo(56))),

        const SizedBox(width: 16),

        // Botón de información
        if (showInfoButton)
          _buildYellowCircleButton(
            icon: Icons.help_outline,
            onPressed: onInfoPressed,
          ),
      ],
    );
  }

  /// AppBar 5: Caja de Herramientas DAGRD
  Widget _buildCajaHerramientasAppBar() {
    return Row(
      children: [
        // Botón de retroceso
        if (showBackButton)
          _buildYellowCircleButton(
            icon: Icons.arrow_back,
            onPressed: onBackPressed,
          ),

        const SizedBox(width: 16),

        // Título con "Herramientas" en amarillo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? 'Caja de',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: subtitle?.split(' ')[0] ?? 'Herramientas',
                      style: const TextStyle(
                        color: Color(0xFFFBBF24), // Amarillo DAGRD
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${subtitle?.split(' ').skip(1).join(' ') ?? 'DAGRD'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Botón de información
        if (showInfoButton)
          _buildYellowCircleButton(
            icon: Icons.help,
            onPressed: onInfoPressed,
          ),

        if (showInfoButton && showUserButton) const SizedBox(width: 12),

        // Botón de usuario
        if (showUserButton)
          _buildYellowCircleButton(
            icon: Icons.person,
            onPressed: onUserPressed,
          ),
      ],
    );
  }

  /// Widget para botones circulares amarillos
  Widget _buildYellowCircleButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFFBBF24), // Amarillo DAGRD
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: const Color(0xFF232B48), // Azul DAGRD
          size: 18,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Widget para logos institucionales
  Widget _buildInstitutionalLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Icon(
          Icons.abc_outlined, // Placeholder para logo institucional
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
