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
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
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
                    child: Column(
                      children: [
                        Text(
                          'Ubicación',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isAutomaticSelected
                                ? const Color(0xFF232B48) // color: var(--AzulDAGRD, #232B48)
                                : const Color(0xFF6B7280),
                            fontFamily: 'Work Sans', // font-family: "Work Sans"
                            fontSize: 14, // font-size: 14px
                            fontStyle: FontStyle.normal, // font-style: normal
                            fontWeight: FontWeight.w500, // font-weight: 500
                            height: 22 / 14, // line-height: 22px (157.143%)
                          ),
                        ),
                        Text(
                          'Automática',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isAutomaticSelected
                                ? const Color(0xFF232B48) // color: var(--AzulDAGRD, #232B48)
                                : const Color(0xFF6B7280),
                            fontFamily: 'Work Sans', // font-family: "Work Sans"
                            fontSize: 14, // font-size: 14px
                            fontStyle: FontStyle.normal, // font-style: normal
                            fontWeight: FontWeight.w500, // font-weight: 500
                            height: 22 / 14, // line-height: 22px (157.143%)
                            decoration: _isAutomaticSelected
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () => setState(() => _isAutomaticSelected = false),
                    child: Column(
                      children: [
                        Text(
                          'Ubicación',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isAutomaticSelected
                                ? const Color(0xFF232B48) // color: var(--AzulDAGRD, #232B48)
                                : const Color(0xFF6B7280),
                            fontFamily: 'Work Sans', // font-family: "Work Sans"
                            fontSize: 14, // font-size: 14px
                            fontStyle: FontStyle.normal, // font-style: normal
                            fontWeight: FontWeight.w500, // font-weight: 500
                            height: 22 / 14, // line-height: 22px (157.143%)
                          ),
                        ),
                        Text(
                          'manual',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isAutomaticSelected
                                ? const Color(0xFF232B48) // color: var(--AzulDAGRD, #232B48)
                                : const Color(0xFF6B7280),
                            fontFamily: 'Work Sans', // font-family: "Work Sans"
                            fontSize: 14, // font-size: 14px
                            fontStyle: FontStyle.normal, // font-style: normal
                            fontWeight: FontWeight.w500, // font-weight: 500
                            height: 22 / 14, // line-height: 22px (157.143%)
                            decoration: !_isAutomaticSelected
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                            borderRadius: BorderRadius.all(Radius.circular(4)),
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
                            borderRadius: BorderRadius.all(Radius.circular(4)),
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Coordenadas actuales
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Coordenadas actuales',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$_currentLat, $_currentLng',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontFamily: 'Work Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
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
                          color: Colors.white,
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
