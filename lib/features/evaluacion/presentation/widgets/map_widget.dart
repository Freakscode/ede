// ignore_for_file: unused_import

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/form/identificacionEdificacion/id_edificacion_bloc.dart';
import '../bloc/form/identificacionEdificacion/id_edificacion_event.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialPosition;
  
  const MapWidget({
    super.key, 
    this.initialPosition,
  });

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  Set<Marker> _markers = {};

  static const CameraPosition _medellinPosition = CameraPosition(
    target: LatLng(6.2442, -75.5812),
    zoom: 13.5,
    tilt: 0,
    bearing: 0,
  );

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: widget.initialPosition != null
                ? CameraPosition(
                    target: widget.initialPosition!,
                    zoom: 17,
                  )
                : _medellinPosition,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            markers: _markers,
            onTap: _onMapTap,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
        ),
        if (_selectedPosition != null) ...[
          const SizedBox(height: 8),
          Text(
            'Coordenadas seleccionadas:\n'
            'Latitud: ${_selectedPosition!.latitude.toStringAsFixed(6)}\n'
            'Longitud: ${_selectedPosition!.longitude.toStringAsFixed(6)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  void _onMapTap(LatLng position) {
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
          infoWindow: const InfoWindow(
            title: 'Ubicación seleccionada',
          ),
        ),
      };
    });

    context.read<EdificacionBloc>().add(SetCoordenadas(
      latitud: latitudRedondeada,
      longitud: longitudRedondeada,
      context: context,
    ));
  }

  @override
  void initState() {
    super.initState();
    // Inicializar el mapa con la posición del bloc si existe
    if (widget.initialPosition != null) {
      _selectedPosition = widget.initialPosition;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: widget.initialPosition!,
          infoWindow: const InfoWindow(
            title: 'Ubicación seleccionada',
          ),
        ),
      };
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
} 