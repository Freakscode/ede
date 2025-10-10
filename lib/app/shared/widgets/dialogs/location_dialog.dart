import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class LocationDialog extends StatefulWidget {
  final Function(String lat, String lng)? onLocationSelected;
  final String? initialLat;
  final String? initialLng;

  const LocationDialog({
    super.key,
    this.onLocationSelected,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  bool _isAutomaticSelected = true;
  String _currentLat = '4.609700';
  String _currentLng = '-74.081700';

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _currentLat = widget.initialLat!;
      _currentLng = widget.initialLng!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: 400,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ubicación',
                      style: TextStyle(
                        color: Color(0xFF000000), // color: #000
                        fontFamily: 'Work Sans', // font-family: "Work Sans"
                        fontSize: 16, // font-size: 16px
                        fontStyle: FontStyle.normal, // font-style: normal
                        fontWeight: FontWeight.w500, // font-weight: 500
                        height: 18 / 16, // line-height: 18px (112.5%)
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF1E1E1E), // stroke: #1E1E1E
                      size: 18, // stroke-width: 2px (ajustado para el tamaño)
                    ),
                  ),
                ],
              ),
            ),

            // Opciones de ubicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isAutomaticSelected = true),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ubicación\n',
                            style: TextStyle(
                              color: _isAutomaticSelected
                                  ? const Color(0xFF232B48)
                                  : const Color(0xFF6B7280),
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Automática',
                            style: TextStyle(
                              color: _isAutomaticSelected
                                  ? const Color(0xFF232B48)
                                  : const Color(0xFF6B7280),
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                              decoration: _isAutomaticSelected
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () => setState(() => _isAutomaticSelected = false),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ubicación\n',
                            style: TextStyle(
                              color: !_isAutomaticSelected
                                  ? const Color(0xFF232B48)
                                  : const Color(0xFF6B7280),
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                            ),
                          ),
                          TextSpan(
                            text: 'manual',
                            style: TextStyle(
                              color: !_isAutomaticSelected
                                  ? const Color(0xFF232B48)
                                  : const Color(0xFF6B7280),
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              height: 22 / 14,
                              decoration: !_isAutomaticSelected
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contenido principal scrolleable
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mapa simulado
                    Container(
                      height: 194, // height: 194px
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, // padding: 13px 16px (horizontal)
                        vertical: 13, // padding: 13px 16px (vertical)
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Stack(
                        children: [
                          // Mapa simulado
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.map,
                                  size: 64,
                                  color: Color(0xFF6B7280),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Mapa interactivo',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontFamily: 'Work Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Calle 55, Carrera 65',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontFamily: 'Work Sans',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Marcador rojo
                          Positioned(
                            top: 100,
                            left: 120,
                            child: Icon(
                              Icons.location_on,
                              color: const Color(0xFFEF4444),
                              size: 32,
                            ),
                          ),
                          // Controles de zoom
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF374151),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Color(0xFF374151),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botones y coordenadas
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Botón "Obtener ubicación actual"
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DAGRDColors.amarDAGRD,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () => _getCurrentLocation(),
                              icon: const Icon(
                                Icons.my_location,
                                color: Color(0xFF1E1E1E),
                                size: 20,
                              ),
                              label: const Text(
                                'Obtener ubicación actual',
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontFamily: 'Work Sans',
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Coordenadas actuales
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Coordenadas actuales',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF1E1E1E),
                                      fontFamily: 'Work Sans',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$_currentLat, $_currentLng',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF1E1E1E),
                                      fontFamily: 'Work Sans',
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Botón "Guardar ubicación"
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF232B48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () => _saveLocation(),
                              icon: const Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                'Guardar ubicación',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'Work Sans',
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    // Simular obtención de ubicación actual
    setState(() {
      _currentLat = '4.609700';
      _currentLng = '-74.081700';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ubicación actual obtenida'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveLocation() {
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(_currentLat, _currentLng);
    }
    Navigator.of(context).pop();
  }
}
