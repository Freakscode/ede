import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  
  // Variables para Google Maps
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(4.609700, -74.081700);
  
  // Timer para debounce de coordenadas manuales
  Timer? _coordinateUpdateTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _currentLat = widget.initialLat!;
      _currentLng = widget.initialLng!;
      _currentPosition = LatLng(double.parse(_currentLat), double.parse(_currentLng));
    }
    _latController.text = _currentLat;
    _lngController.text = _currentLng;
    
    // Inicializar marcador
    _updateMarker();
    
    // Agregar listeners para actualizar el mapa cuando cambien las coordenadas manuales
    _latController.addListener(_onManualCoordinatesChanged);
    _lngController.addListener(_onManualCoordinatesChanged);
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _coordinateUpdateTimer?.cancel();
    super.dispose();
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
                       child: ClipRRect(
                         borderRadius: BorderRadius.circular(8),
                         child: GoogleMap(
                           onMapCreated: (GoogleMapController controller) {
                             _mapController = controller;
                           },
                           initialCameraPosition: CameraPosition(
                             target: _currentPosition,
                             zoom: 15.0,
                           ),
                           markers: _markers,
                           onTap: _isAutomaticSelected ? _onMapTapped : null,
                           mapType: MapType.normal,
                           myLocationEnabled: true,
                           myLocationButtonEnabled: false,
                           zoomControlsEnabled: true,
                           mapToolbarEnabled: false,
                         ),
                       ),
                    ),

                    // Campos de ubicación manual
                    if (!_isAutomaticSelected) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Campo Latitud
                            const Text(
                              'Latitud',
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontFamily: 'Work Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _latController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: '6.244747',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF232B48),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontFamily: 'Work Sans',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Campo Longitud
                            const Text(
                              'Longitud',
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontFamily: 'Work Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _lngController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: '-75.573553',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF232B48),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontFamily: 'Work Sans',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

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

  void _getCurrentLocation() async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Permisos de ubicación denegados');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar('Los permisos de ubicación están permanentemente denegados');
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLat = position.latitude.toString();
        _currentLng = position.longitude.toString();
        _currentPosition = LatLng(position.latitude, position.longitude);
        _latController.text = _currentLat;
        _lngController.text = _currentLng;
        _updateMarker();
      });

      // Mover cámara a la ubicación actual
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentPosition),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ubicación actual obtenida'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error al obtener ubicación: $e');
    }
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _currentPosition = location;
      _currentLat = location.latitude.toString();
      _currentLng = location.longitude.toString();
      _latController.text = _currentLat;
      _lngController.text = _currentLng;
      _updateMarker();
    });
  }

  void _onManualCoordinatesChanged() {
    // Solo actualizar si estamos en modo manual
    if (!_isAutomaticSelected) {
      // Cancelar timer anterior si existe
      _coordinateUpdateTimer?.cancel();
      
      // Crear nuevo timer con debounce de 1 segundo
      _coordinateUpdateTimer = Timer(const Duration(milliseconds: 1000), () {
        _updateMapFromManualCoordinates();
      });
    }
  }

  void _updateMapFromManualCoordinates() {
    try {
      final latText = _latController.text.trim();
      final lngText = _lngController.text.trim();
      
      // Verificar que ambos campos tengan valores válidos
      if (latText.isNotEmpty && lngText.isNotEmpty) {
        final lat = double.parse(latText);
        final lng = double.parse(lngText);
        
        // Validar rangos de coordenadas
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          final newPosition = LatLng(lat, lng);
          
          setState(() {
            _currentPosition = newPosition;
            _currentLat = latText;
            _currentLng = lngText;
            _updateMarker();
          });
          
          // Mover la cámara del mapa a la nueva ubicación
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(newPosition),
            );
          }
        }
      }
    } catch (e) {
      // Ignorar errores de parsing - el usuario puede estar escribiendo
      // Los valores se validarán cuando termine de escribir
    }
  }

  void _updateMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: const InfoWindow(
            title: 'Ubicación seleccionada',
            snippet: 'Toque para seleccionar esta ubicación',
          ),
        ),
      };
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _saveLocation() {
    // Si está en modo manual, usar los valores de los campos de entrada
    if (!_isAutomaticSelected) {
      _currentLat = _latController.text;
      _currentLng = _lngController.text;
    }

    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(_currentLat, _currentLng);
    }
    Navigator.of(context).pop();
  }
}
