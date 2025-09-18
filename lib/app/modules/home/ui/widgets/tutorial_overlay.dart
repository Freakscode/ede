import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/label_bubble.dart';
import 'package:caja_herramientas/app/modules/home/models/line_model.dart';
import 'package:caja_herramientas/app/modules/home/ui/widgets/lines_painter.dart';
import 'package:flutter/material.dart';


/// ---------------------------
/// Overlay tipo "póster" + labels
/// ---------------------------
class TutorialPosterOverlay extends StatelessWidget {
  TutorialPosterOverlay({super.key});

  final _labelData = [
    _LabelData(
      textTop: 'Botón\nir atrás',
      position: Offset(0.38, 0),
      align: Alignment.centerRight,
    ),
    _LabelData(
      textTop: 'Botón información\nde ayuda para cada sección',
      position: Offset(0.69, 0),
      align: Alignment.bottomCenter,
    ),
    _LabelData(
      textTop: 'Botón\ninicio\nde sesión\nUsuarios\nDAGRD',
      position: Offset(1.12, 0.15),
      align: Alignment.centerLeft,
    ),
    _LabelData(
      textTop: 'Menú de acciones principales',
      position: Offset(0.38, 0.98),
      align: Alignment.bottomCenter,
    ),
  ];

  final _lineData = [

    // Line(from: Offset(0.13, 0.13), to: Offset(0.13, 0.08)), // back
    Line(from: Offset(0.65, 0.15), to: Offset(0.78, 0.15)), // profile 
    Line(from: Offset(0.51, 0.10), to: Offset(0.51, 0.02)), // info (más corta)

    
    // Línea horizontal inferior
    Line(from: Offset(0.13, 0.9), to: Offset(0.6, 0.9)),
    // Línea vertical izquierda
    Line(from: Offset(0.13, 0.9), to: Offset(0.13, 0.82)),
    Line(from: Offset(0.28, 0.9), to: Offset(0.28, 0.82)),
    Line(from: Offset(0.45, 0.9), to: Offset(0.45, 0.82)),
    Line(from: Offset(0.6, 0.9), to: Offset(0.6, 0.82)),
    // // Línea vertical derecha
  ];


  void _close(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.black.withOpacity(0.68),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => _close(context),
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
              // Título centrado
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenidos a la aplicación',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 16 / 14,
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
              SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final posterWidth = constraints.maxWidth * 0.78 > 400 ? 400.0 : constraints.maxWidth * 0.9;
                  final posterHeight = posterWidth * 1.7;
                  final stackHeight = posterHeight * 1.20; // más alto para labels arriba/abajo
                  return SizedBox(
                    width: posterWidth,
                    height: stackHeight,
                    child: Stack(
                      children: [
                        // Imagen del póster centrada verticalmente
                        Positioned(
                          left: 0,
                          right: 100,
                          top: (stackHeight - posterHeight) / 1.25,
                          child: Container(
                            // width: posterWidth,
                            height: posterHeight * 0.78,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/home_poster.jpeg',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        // Líneas amarillas
                        Positioned(
                          left: 0,
                          right: 0,
                          top: (stackHeight - posterHeight) / 2,
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
                            left: l.position.dx * posterWidth - 110,
                            top: (stackHeight - posterHeight) / 2 + l.position.dy * posterHeight - 34,
                            child: LabelBubble(
                              top: l.textTop,
                              bottom: l.textBottom,
                              align: l.align,
                            ),
                          ),
                        ),
                        // Checkbox “No volver a mostrar” centrado abajo del póster
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 50,
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
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // const SizedBox(height: 15),
              // Checkbox “No volver a mostrar” (solo visual, deshabilitado)
             
            ],
          ),
        ),
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




