import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:flutter/material.dart';
import 'widgets/label_bubble.dart';
import 'widgets/lines_painter.dart';
import 'widgets/line_model.dart';


/// ---------------------------
/// Overlay tipo "póster" + labels
/// ---------------------------
class TutorialPosterOverlayScreen extends StatelessWidget {
  TutorialPosterOverlayScreen({super.key});

  final _labelData = [
    _LabelData(
      textTop: 'Botón\nir atrás',
      position: Offset(0.4, 0.18),
      align: Alignment.centerRight,
    ),
    _LabelData(
      textTop: 'Botón información\nde ayuda para cada sección',
      position: Offset(0.78, 0.18),
      align: Alignment.bottomCenter,
    ),
    _LabelData(
      textTop: 'Botón\ninicio\nde sesión\nUsuarios\nDAGRD',
      position: Offset(1.2, 0.35),
      align: Alignment.centerLeft,
    ),
    _LabelData(
      textTop: 'Menú de acciones principales',
      position: Offset(0.38, 1.28),
      align: Alignment.bottomCenter,
    ),
  ];

  final _lineData = [
    // from: punto en la imagen (relativo), to: punto del label (relativo)
    // Line(from: Offset(0.13, 0.13), to: Offset(0.13, 0.08)), // back
    Line(from: Offset(0.65, 0.24), to: Offset(0.82, 0.24)), // info (más corta)
    Line(from: Offset(0.52, 0.17), to: Offset(0.52, 0.08)), // profile

    // Menú de acciones principales (línea amarilla con 3 puntos y esquinas)
    // Ajusta estos valores para que coincidan visualmente con tu póster
    // Línea horizontal inferior
    Line(from: Offset(0.1, 1.05), to: Offset(0.62, 1.05)),
    // Línea vertical izquierda
    Line(from: Offset(0.1, 1.05), to: Offset(0.1, 0.97)),
    // // Línea vertical centro
    Line(from: Offset(0.28, 1.05), to: Offset(0.28, 0.97)),
    Line(from: Offset(0.45, 1.05), to: Offset(0.45, 0.97)),
    Line(from: Offset(0.62, 1.05), to: Offset(0.62, 0.97)),
    // // Línea vertical derecha
  ];


  void _close(BuildContext context) => Navigator.of(context).pop();

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
              onPressed: () => _close(context),
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
            padding: const EdgeInsets.only(top: 240, left: 54),
            child: Container(
              height: 450,
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
                  painter: LinesPainter(
                    lines: _lineData
                        .map(
                          (l) => Line(
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
              child: LabelBubble(
                top: l.textTop,
                bottom: l.textBottom,
                align: l.align,
              ),
            ),
          ),

          // Checkbox “No volver a mostrar” (solo visual, deshabilitado)
          Positioned(
            bottom: 18 + MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Color(0xFFAAAAAA), width: 1),
                    ),
                    child: Checkbox(
                      value: false,
                      onChanged: null, // Deshabilitado
                      activeColor: DAGRDColors.azulDAGRD,
                      checkColor: Colors.white,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'No volver a mostrar',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Metropolis',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.0, // 13px line-height for 13px font-size
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




