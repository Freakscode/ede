import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_state.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/presentation/bloc/risk_threat_analysis_event.dart';

class LocationDialog extends StatefulWidget {
  final Function(String lat, String lng)? onLocationSelected;
  final String? initialLat;
  final String? initialLng;
  final int? imageIndex; // Para identificar qué imagen está siendo editada
  final String? category; // Categoría de la imagen (amenaza/vulnerabilidad)

  const LocationDialog({
    super.key,
    this.onLocationSelected,
    this.initialLat,
    this.initialLng,
    this.imageIndex,
    this.category,
  });

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  MapController? _mapController;
  Timer? _coordinateUpdateTimer;

  bool _isAutomaticSelected = true;
  bool _isCurrentLocationObtained = false;
  LatLng _currentPosition = const LatLng(4.609700, -74.081700);
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeCoordinates();
  }

  void _initializeCoordinates() async {
    // Siempre intentar obtener ubicación GPS como inicial
    try {
      // Verificar permisos rápidamente
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setDefaultCoordinates();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Solicitar permisos si no están concedidos
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setDefaultCoordinates();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setDefaultCoordinates();
        return;
      }

      // Intentar obtener ubicación GPS con timeout corto
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      // Usar coordenadas GPS como iniciales
      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      _latController.text = lat;
      _lngController.text = lng;
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isCurrentLocationObtained = true;
      _updateMarker(isCurrentLocation: _isCurrentLocationObtained);

      // Mover el mapa a la ubicación GPS
      if (_mapController != null) {
        _mapController!.move(_currentPosition, 15.0);
      }
    } catch (e) {
      // Si falla, usar coordenadas por defecto
      _setDefaultCoordinates();
    }
  }

  void _setDefaultCoordinates() {
    const lat = '4.609700'; // Bogotá por defecto
    const lng = '-74.081700';

    _latController.text = lat;
    _lngController.text = lng;
    _currentPosition = const LatLng(4.609700, -74.081700);
    _isCurrentLocationObtained = false;
    _updateMarker(isCurrentLocation: _isCurrentLocationObtained);

    // Mostrar mensaje informativo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No se pudo obtener tu ubicación GPS. Usando ubicación por defecto.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade600,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Intentar GPS',
              textColor: Colors.white,
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ),
        );
      }
    });
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
    return BlocConsumer<RiskThreatAnalysisBloc, RiskThreatAnalysisState>(
      listener: (context, state) {
        // Manejar estados de carga y errores
        if (state.isLoading) {
          // El loading ya se maneja en _showLocationLoading()
          return;
        }

        if (state.error?.isNotEmpty == true) {
          _showLocationError(state.error!);
          return;
        }

        // Sincronizar coordenadas desde el bloc si hay cambios
        if (widget.imageIndex != null && widget.category != null) {
          final categoryCoordinates =
              state.evidenceCoordinates[widget.category!];
          if (categoryCoordinates != null) {
            final coordinates = categoryCoordinates[widget.imageIndex!];
            if (coordinates != null) {
              final lat = coordinates['lat'] ?? '';
              final lng = coordinates['lng'] ?? '';

              if (lat.isNotEmpty && lng.isNotEmpty) {
                // Verificar si las coordenadas cambiaron
                final currentLat = _latController.text;
                final currentLng = _lngController.text;

                if (currentLat != lat || currentLng != lng) {
                  _latController.text = lat;
                  _lngController.text = lng;

                  // Actualizar posición en el mapa
                  try {
                    final newPosition = LatLng(
                      double.parse(lat),
                      double.parse(lng),
                    );
                    setState(() {
                      _currentPosition = newPosition;
                      _isCurrentLocationObtained =
                          true; // Marcar como ubicación GPS
                      _updateMarker(
                        isCurrentLocation: _isCurrentLocationObtained,
                      );
                    });

                    // Mover el mapa a la nueva posición
                    if (_mapController != null) {
                      _mapController!.move(newPosition, 15.0);
                    }

                    // Mostrar mensaje de éxito
                    _showLocationSuccess();
                  } catch (e) {
                    _showLocationError('Error al procesar coordenadas: $e');
                  }
                }
              }
            }
          }
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              minHeight: 400,
            ),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLocationModeSelector(),
                        const SizedBox(height: 20),
                        _buildMapWidget(),
                        if (!_isAutomaticSelected) ...[
                          const SizedBox(height: 20),
                          _buildManualCoordinatesWidget(),
                        ],
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Ubicación',
              style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 1.125,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Color(0xFF1E1E1E), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAutomaticSelected = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _isAutomaticSelected
                          ? const Color(0xFF232B48)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Ubicación\n',
                        style: TextStyle(
                          color: Color(0xFF232B48),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                        ),
                      ),
                      TextSpan(
                        text: 'Automática',
                        style: TextStyle(
                          color: const Color(0xFF232B48),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                          decoration: _isAutomaticSelected
                              ? TextDecoration.underline
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isAutomaticSelected = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: !_isAutomaticSelected
                          ? const Color(0xFF232B48)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Ubicación\n',
                        style: TextStyle(
                          color: Color(0xFF232B48),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                        ),
                      ),
                      TextSpan(
                        text: 'manual',
                        style: TextStyle(
                          color: const Color(0xFF232B48),
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          height: 1.57,
                          decoration: !_isAutomaticSelected
                              ? TextDecoration.underline
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    return Container(
      height: 194,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: ThemeColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FlutterMap(
          mapController: _mapController ??= MapController(),
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: 15.0,
            onTap: _isAutomaticSelected
                ? (tapPosition, point) => _onMapTapped(point)
                : null,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.caja_herramientas',
            ),
            MarkerLayer(markers: _markers),
          ],
        ),
      ),
    );
  }

  Widget _buildManualCoordinatesWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '6.244747',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF232B48)),
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
            onChanged: (value) => _onManualCoordinatesChanged(),
          ),
          const SizedBox(height: 16),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '-75.573553',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFF232B48)),
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
            onChanged: (value) => _onManualCoordinatesChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(
                  Icons.my_location,
                  color: Color(0xFF232B48),
                  size: 20,
                ),
                label: const Text(
                  'Obtener ubicación actual',
                  style: TextStyle(
                    color: Color(0xFF232B48),
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.57,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: const Color(0xFF232B48),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Coordenadas actuales',
              style: TextStyle(
                color: ThemeColors.grisMedio,
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Latitud',
              style: TextStyle(
                color: ThemeColors.azulDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.33333,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.blancoDAGRD,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.grisMedio, width: 1),
                ),
                child: Text(
                  _latController.text.isEmpty
                      ? 'No definida'
                      : _latController.text,
                  style: TextStyle(
                    color: _latController.text.isEmpty
                        ? const Color(0xFFCCCCCC)
                        : Colors.black,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Longitud',
              style: TextStyle(
                color: ThemeColors.azulDAGRD,
                fontFamily: 'Work Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.33333,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ThemeColors.blancoDAGRD,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThemeColors.grisMedio, width: 1),
                ),
                child: Text(
                  _lngController.text.isEmpty
                      ? 'No definida'
                      : _lngController.text,
                  style: TextStyle(
                    color: _lngController.text.isEmpty
                        ? const Color(0xFFCCCCCC)
                        : Colors.black,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveLocation,
                icon: const Icon(Icons.save, color: Colors.white, size: 20),
                label: const Text(
                  'Guardar ubicación',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.71,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF232B48),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _currentPosition = location;
      _latController.text = location.latitude.toString();
      _lngController.text = location.longitude.toString();
      _isCurrentLocationObtained = false; // Ya no es ubicación automática
      _updateMarker(isCurrentLocation: _isCurrentLocationObtained);
    });
  }

  void _onManualCoordinatesChanged() {
    // Actualización inmediata para coordenadas válidas
    _updateMarkerFromControllers();

    // Actualización con delay para evitar demasiadas actualizaciones
    _coordinateUpdateTimer?.cancel();
    _coordinateUpdateTimer = Timer(const Duration(milliseconds: 1000), () {
      _updateMarkerFromControllers();
    });
  }

  void _updateMarkerFromControllers() {
    try {
      final lat = double.parse(_latController.text);
      final lng = double.parse(_lngController.text);

      if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
        setState(() {
          _currentPosition = LatLng(lat, lng);
          _isCurrentLocationObtained = false; // Ya no es ubicación automática
          _updateMarker(isCurrentLocation: _isCurrentLocationObtained);
        });

        if (_mapController != null) {
          _mapController!.move(_currentPosition, 15.0);
        }
      }
    } catch (e) {
      // Ignorar errores de parsing
    }
  }

  void _updateMarker({bool isCurrentLocation = false}) {
    setState(() {
      _markers = [
        Marker(
          point: _currentPosition,
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Efecto de pulso para ubicación actual
              if (isCurrentLocation)
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Container(
                      width: 40 + (value * 20),
                      height: 40 + (value * 20),
                      decoration: BoxDecoration(
                        color: ThemeColors.success.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              // Marcador principal
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCurrentLocation
                      ? ThemeColors.success
                      : ThemeColors.azulDAGRD,
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.blancoDAGRD, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isCurrentLocation ? Icons.my_location : Icons.location_on,
                  color: ThemeColors.blancoDAGRD,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ];
    });
  }

  void _getCurrentLocation() async {
    try {
      setState(() {
        _isCurrentLocationObtained = true;
      });

      // Mostrar indicador de carga
      _showLocationLoading();

      // Usar el bloc existente para obtener ubicación
      if (widget.imageIndex != null) {
        context.read<RiskThreatAnalysisBloc>().add(
          GetCurrentLocationForImage(
            imageIndex: widget.imageIndex!,
            category: widget.category ?? '',
          ),
        );
      }
    } catch (e) {
      _showLocationError('Error al obtener ubicación: $e');
    }
  }

  void _showLocationLoading() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Obteniendo ubicación GPS...'),
          ],
        ),
        backgroundColor: ThemeColors.azulDAGRD,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Configurar',
          textColor: Colors.white,
          onPressed: () {
            // Abrir configuración de ubicación
            // Esto requeriría el paquete app_settings
          },
        ),
      ),
    );
  }

  void _showLocationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Ubicación GPS obtenida exitosamente'),
          ],
        ),
        backgroundColor: ThemeColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveLocation() {
    final lat = _isAutomaticSelected
        ? _latController.text
        : _latController.text;
    final lng = _isAutomaticSelected
        ? _lngController.text
        : _lngController.text;

    // Actualizar el bloc existente
    if (widget.imageIndex != null && widget.category != null) {
      context.read<RiskThreatAnalysisBloc>().add(
        UpdateEvidenceCoordinates(
          category: widget.category!,
          imageIndex: widget.imageIndex!,
          coordinates: {'lat': lat, 'lng': lng},
        ),
      );
    }

    widget.onLocationSelected?.call(lat, lng);
    Navigator.of(context).pop();
  }
}
