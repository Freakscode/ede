import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_bloc.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/risk_threat_analysis_state.dart';
import 'package:caja_herramientas/app/modules/risk_threat_analysis/bloc/events/risk_threat_analysis_event.dart';

class LocationDialog extends StatefulWidget {
  final Function(String lat, String lng)? onLocationSelected;
  final String? initialLat;
  final String? initialLng;
  final int? imageIndex; // Para identificar qué imagen está siendo editada

  const LocationDialog({
    super.key,
    this.onLocationSelected,
    this.initialLat,
    this.initialLng,
    this.imageIndex,
  });

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  GoogleMapController? _mapController;
  Timer? _coordinateUpdateTimer;
  
  bool _isAutomaticSelected = true;
  LatLng _currentPosition = const LatLng(4.609700, -74.081700);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeCoordinates();
  }

  void _initializeCoordinates() {
    final lat = widget.initialLat ?? '4.609700';
    final lng = widget.initialLng ?? '-74.081700';
    
    _latController.text = lat;
    _lngController.text = lng;
    _currentPosition = LatLng(double.parse(lat), double.parse(lng));
    _updateMarker();
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
        // Sincronizar coordenadas desde el bloc si hay cambios
        if (widget.imageIndex != null) {
          final coordinates = state.imageCoordinates[widget.imageIndex!];
          if (coordinates != null) {
            _latController.text = coordinates['lat'] ?? '';
            _lngController.text = coordinates['lng'] ?? '';
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
            child: const Icon(
              Icons.close,
              color: Color(0xFF1E1E1E),
              size: 18,
            ),
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
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          onMapCreated: (controller) => _mapController = controller,
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      child: Column(
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Coordenadas actuales',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_latController.text}, ${_lngController.text}',
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _currentPosition = location;
      _latController.text = location.latitude.toString();
      _lngController.text = location.longitude.toString();
      _updateMarker();
    });
  }

  void _onManualCoordinatesChanged() {
    _coordinateUpdateTimer?.cancel();
    _coordinateUpdateTimer = Timer(const Duration(milliseconds: 1000), () {
      try {
        final lat = double.parse(_latController.text);
        final lng = double.parse(_lngController.text);
        
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          setState(() {
            _currentPosition = LatLng(lat, lng);
            _updateMarker();
          });
          
          if (_mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
          }
        }
      } catch (e) {
        // Ignorar errores de parsing
      }
    });
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

  void _getCurrentLocation() {
    // Usar el bloc existente para obtener ubicación
    if (widget.imageIndex != null) {
      context.read<RiskThreatAnalysisBloc>().add(
        GetCurrentLocationForImage(widget.imageIndex!),
      );
    }
  }

  void _saveLocation() {
    final lat = _isAutomaticSelected ? _latController.text : _latController.text;
    final lng = _isAutomaticSelected ? _lngController.text : _lngController.text;
    
    // Actualizar el bloc existente
    if (widget.imageIndex != null) {
      context.read<RiskThreatAnalysisBloc>().add(
        UpdateImageCoordinates(
          imageIndex: widget.imageIndex!,
          lat: lat,
          lng: lng,
        ),
      );
    }
    
    widget.onLocationSelected?.call(lat, lng);
    Navigator.of(context).pop();
  }
}
