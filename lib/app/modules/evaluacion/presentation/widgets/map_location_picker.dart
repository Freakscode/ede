import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class MapLocationPicker extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final Function(double, double) onLocationSelected;

  const MapLocationPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onLocationSelected,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  Set<Marker> _markers = {};

  static const CameraPosition _medellinPosition = CameraPosition(
    target: LatLng(6.2442, -75.5812),
    zoom: 13.5,
    tilt: 0,
    bearing: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedPosition = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedPosition!,
          infoWindow: const InfoWindow(title: 'Ubicación seleccionada'),
        ),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: widget.initialLatitude != null && widget.initialLongitude != null
                ? CameraPosition(
                    target: LatLng(widget.initialLatitude!, widget.initialLongitude!),
                    zoom: 17,
                  )
                : _medellinPosition,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
            onTap: _handleMapTap,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
        ),
        if (_selectedPosition != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Text(
                  'Coordenadas seleccionadas:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Latitud: ${_selectedPosition!.latitude.toStringAsFixed(4)}\n'
                  'Longitud: ${_selectedPosition!.longitude.toStringAsFixed(4)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onLocationSelected(
                      _selectedPosition!.latitude,
                      _selectedPosition!.longitude,
                    );
                  },
                  child: const Text('Confirmar ubicación'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _handleMapTap(LatLng position) {
    // Redondear a 4 decimales
    final latitudRedondeada = double.parse(position.latitude.toStringAsFixed(4));
    final longitudRedondeada = double.parse(position.longitude.toStringAsFixed(4));
    final posicionRedondeada = LatLng(latitudRedondeada, longitudRedondeada);

    setState(() {
      _selectedPosition = posicionRedondeada;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: posicionRedondeada,
          infoWindow: const InfoWindow(title: 'Ubicación seleccionada'),
        ),
      };
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
} 