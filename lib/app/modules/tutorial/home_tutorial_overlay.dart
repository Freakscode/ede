import 'dart:ui';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';

/// Colores DAGRD (ajústalos si ya los tienes en tu theme)
class _Dagrd {
  static const azul = Color(0xFF1E2B4A);
  static const amarillo = Color(0xFFFFCC00);
  static const grisFondo = Color(0xFFF7F7F7);
}

/// Llama esto desde tu HomeScreen cuando quieras abrir el tutorial.
/// Ejemplo: WidgetsBinding.instance.addPostFrameCallback((_) => _showPosterTutorial(context));
Future<void> _showPosterTutorial(BuildContext context) async {
  final entry = OverlayEntry(
    builder: (_) => const TutorialPosterOverlayScreen(),
  );
  Overlay.of(context).insert(entry);
}

/// ---------------------------
/// Overlay tipo "póster" + labels
/// ---------------------------
class TutorialPosterOverlayScreen extends StatefulWidget {
  const TutorialPosterOverlayScreen();

  @override
  State<TutorialPosterOverlayScreen> createState() =>
      _TutorialPosterOverlayState();
}

class _TutorialPosterOverlayState extends State<TutorialPosterOverlayScreen> {
  // Posiciones relativas (en porcentaje) sobre la imagen para los puntos de anclaje
  // (ajusta estos valores según la imagen real)
  final _labelData = [
    // _LabelData(
    //   textTop: 'Bienvenidos a la aplicación',
    //   textBottom: 'Caja de Herramientas DAGRD',
    //   position: Offset(0.5, 0.08), // arriba del header
    // ),
    // _LabelData(
    //   textTop: 'Botón\nir atrás',
    //   position: Offset(0.13, 0.13),
    //   align: Alignment.centerRight,
    // ),
    // _LabelData(
    //   textTop: 'Botón información\nde ayuda para cada sección',
    //   position: Offset(0.5, 0.13),
    //   align: Alignment.bottomCenter,
    // ),
    _LabelData(
      textTop: 'Botón\ninicio\nde sesión\nUsuarios\nDAGRD',
      position: Offset(1.2, 0.25),
      align: Alignment.centerLeft,
    ),
    // _LabelData(
    //   textTop: 'Menú de acciones principales',
    //   position: Offset(0.5, 0.93),
    //   align: Alignment.bottomCenter,
    // ),
  ];

  final _lineData = [
    // from: punto en la imagen (relativo), to: punto del label (relativo)
    // _Line(from: Offset(0.13, 0.13), to: Offset(0.13, 0.08)), // back
    _Line(from: Offset(0.7, 0.15), to: Offset(0.82, 0.15)), // info (más corta)
    // _Line(from: Offset(0.87, 0.13), to: Offset(0.87, 0.08)), // profile
    // _Line(from: Offset(0.13, 0.93), to: Offset(0.5, 0.93)), // nav1
    // _Line(from: Offset(0.5, 0.93), to: Offset(0.5, 0.93)), // nav2
    // _Line(from: Offset(0.87, 0.93), to: Offset(0.5, 0.93)), // nav3
  ];

  bool _dontShowAgain = false;

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final posterWidth = size.width * 0.78;
    final posterHeight = posterWidth * 1.65;

    return Material(
      color: Colors.black.withOpacity(0.68),
      child: Stack(
        children: [
          // Botón cerrar
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 8,
            child: IconButton(
              onPressed: _close,
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),

          // Textos de bienvenida y título arriba del póster
          Positioned(
            top: 80,
            left: 98,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenidos a la aplicación',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 16 / 14, // 114.286%
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Caja de\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'Herramientas\n',
                        style: TextStyle(
                          color: Color(0xFFFFCC00),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'DAGRD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Póster (imagen del home) centrado
          Padding(
            padding: const EdgeInsets.only(top: 182, left: 54),
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/home_poster.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // Líneas amarillas
          Center(
            child: SizedBox(
              width: posterWidth,
              height: posterHeight,
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _LinesPainter(
                    lines: _lineData
                        .map(
                          (l) => _Line(
                            from: Offset(
                              l.from.dx * posterWidth,
                              l.from.dy * posterHeight,
                            ),
                            to: Offset(
                              l.to.dx * posterWidth,
                              l.to.dy * posterHeight,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),

          // Labels
          ..._labelData.map(
            (l) => Positioned(
              left: size.width * 0.11 + l.position.dx * posterWidth - 110,
              top: size.height * 0.13 + l.position.dy * posterHeight - 34,
              child: _LabelBubble(
                top: l.textTop,
                bottom: l.textBottom,
                align: l.align,
              ),
            ),
          ),

          // Checkbox “No volver a mostrar”
          Positioned(
            bottom: 18 + MediaQuery.of(context).padding.bottom,
            left: 20,
            right: 20,
            child: Row(
              children: [
                StatefulBuilder(
                  builder: (ctx, setSt) {
                    return Checkbox(
                      value: _dontShowAgain,
                      onChanged: (v) =>
                          setSt(() => _dontShowAgain = v ?? false),
                      activeColor: _Dagrd.azul,
                      checkColor: Colors.white,
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'No volver a mostrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------
/// Mini "imagen" del Home (maqueta)
/// ---------------------------
class _MiniHomeMock extends StatelessWidget {
  final GlobalKey kBack, kInfo, kProfile, kNav1, kNav2, kNav3, kNav4;
  const _MiniHomeMock({
    required this.kBack,
    required this.kInfo,
    required this.kProfile,
    required this.kNav1,
    required this.kNav2,
    required this.kNav3,
    required this.kNav4,
  });

  @override
  Widget build(BuildContext context) {
    // Usa los mismos colores, fuentes e íconos que HomeScreen
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // AppBar maqueta
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B4A),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  _RoundButton(key: kBack, icon: Icons.arrow_back),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Caja de',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Work Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Herramientas',
                          style: TextStyle(
                            color: Color(0xFFFFCC00),
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'DAGRD',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Work Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RoundButton(key: kInfo, icon: Icons.help_outline),
                  const SizedBox(width: 10),
                  _RoundButton(key: kProfile, icon: Icons.person_outline),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),
          Center(
            child: const Text(
              'Seleccione una herramienta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E2B4A),
                fontFamily: 'Work Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tarjeta 1
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1E2B4A),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icono SVG maqueta
                Container(
                  width: 40,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23305A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Metodología de Análisis del Riesgo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tarjeta 2
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1E2B4A),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23305A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Evaluación del daño en edificaciones EDE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tarjeta 3
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1E2B4A),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23305A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Formulario de caracterización de movimientos en masa',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Botón SIRMED maqueta
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFFFCC00), width: 1),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E2B4A),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Ir a portal SIRMED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.71,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom bar maqueta
          Container(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2B4A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavDot(key: kNav1),
                _NavDot(key: kNav2),
                _NavDot(key: kNav3),
                _NavDot(key: kNav4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  const _RoundButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: _Dagrd.amarillo,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: _Dagrd.azul, size: 18),
    );
  }
}

class _NavDot extends StatelessWidget {
  const _NavDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.25),
        border: Border.all(color: Colors.white, width: 1.6),
      ),
    );
  }
}

/// ---------------------------
/// Labels + líneas
/// ---------------------------
class _LabelData {
  final String textTop;
  final String? textBottom;
  final Offset position; // centro aproximado de la burbuja
  final Alignment align;
  _LabelData({
    required this.textTop,
    this.textBottom,
    required this.position,
    this.align = Alignment.centerLeft,
  });
}

class _Line {
  final Offset from; // punto del póster
  final Offset to; // punto cercano a la burbuja de texto
  _Line({required this.from, required this.to});
}

class _LinesPainter extends CustomPainter {
  final List<_Line> lines;
  _LinesPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _Dagrd.amarillo
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dot = Paint()..color = _Dagrd.amarillo;

    for (final l in lines) {
      final path = Path()
        ..moveTo(l.from.dx, l.from.dy)
        ..lineTo(l.to.dx, l.to.dy);
      canvas.drawPath(path, p);
      // Quitar el círculo al inicio de la línea
      // canvas.drawCircle(l.from, 3.5, dot);
      canvas.drawCircle(l.to, 3.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _LinesPainter oldDelegate) =>
      oldDelegate.lines != lines;
}

class _LabelBubble extends StatelessWidget {
  final String top;
  final String? bottom;
  final Alignment align;

  const _LabelBubble({
    super.key,
    required String top,
    String? bottom,
    this.align = Alignment.centerLeft,
  }) : top = top,
       bottom = bottom;

  @override
  Widget build(BuildContext context) {
    final isLoginLabel = top
        .trim()
        .replaceAll('\n', ' ')
        .contains('inicio de sesión Usuarios DAGRD');
    return Align(
      alignment: align,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0C2340),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              top,
              style: isLoginLabel
                  ? const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Metropolis',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    )
                  : const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
            ),
            if (bottom != null) ...[
              const SizedBox(height: 2),
              Text(
                bottom!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
