import 'package:flutter_bloc/flutter_bloc.dart';
import 'id_edificacion_event.dart';
import 'id_edificacion_state.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class EdificacionBloc extends Bloc<EdificacionEvent, EdificacionState> {
  EdificacionBloc() : super(EdificacionState()) {
    on<SetNombreEdificacion>(_onSetNombreEdificacion);
    on<SetDireccion>(_onSetDireccion);
    on<SetComuna>(_onSetComuna);
    on<SetBarrio>(_onSetBarrio);
    on<SetCodigoBarrio>(_onSetCodigoBarrio);
    on<SetCBML>(_onSetCBML);
    on<SetNombreContacto>(_onSetNombreContacto);
    on<SetTelefonoContacto>(_onSetTelefonoContacto);
    on<SetEmailContacto>(_onSetEmailContacto);
    on<SetOcupacion>(_onSetOcupacion);
    on<LoadTemporaryData>(_onLoadTemporaryData);
    on<SetCoordenadas>(_onSetCoordenadas);
    on<SetDepartamento>(_onSetDepartamento);
    on<SetMunicipio>(_onSetMunicipio);
    on<SetTipoVia>(_onSetTipoVia);
    on<SetNumeroVia>(_onSetNumeroVia);
    on<SetApendiceVia>(_onSetApendiceVia);
    on<SetOrientacionVia>(_onSetOrientacionVia);
    on<SetNumeroCruce>(_onSetNumeroCruce);
    on<SetApendiceCruce>(_onSetApendiceCruce);
    on<SetOrientacionCruce>(_onSetOrientacionCruce);
    on<SetNumero>(_onSetNumero);
    on<SetComplemento>(_onSetComplemento);
    on<SetLatitud>(_onSetLatitud);
    on<SetLongitud>(_onSetLongitud);
  }

  void _onSetNombreEdificacion(SetNombreEdificacion event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(nombreEdificacion: event.nombre));
    developer.log('SetNombreEdificacion: ${event.nombre}', name: 'EdificacionBloc');
  }

  void _onSetDireccion(SetDireccion event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(direccion: event.direccion));
    developer.log('SetDireccion: ${event.direccion}', name: 'EdificacionBloc');
  }

  void _onSetComuna(SetComuna event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(comuna: event.comuna));
    developer.log('SetComuna: ${event.comuna}', name: 'EdificacionBloc');
  }

  void _onSetBarrio(SetBarrio event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(barrio: event.barrio));
    developer.log('SetBarrio: ${event.barrio}', name: 'EdificacionBloc');
  }

  void _onSetCodigoBarrio(SetCodigoBarrio event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(codigoBarrio: event.codigo));
    developer.log('SetCodigoBarrio: ${event.codigo}', name: 'EdificacionBloc');
  }

  void _onSetCBML(SetCBML event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(cbml: event.cbml));
    developer.log('SetCBML: ${event.cbml}', name: 'EdificacionBloc');
  }

  void _onSetNombreContacto(SetNombreContacto event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(nombreContacto: event.nombre));
    developer.log('SetNombreContacto: ${event.nombre}', name: 'EdificacionBloc');
  }

  void _onSetTelefonoContacto(SetTelefonoContacto event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(telefonoContacto: event.telefono));
    developer.log('SetTelefonoContacto: ${event.telefono}', name: 'EdificacionBloc');
  }

  void _onSetEmailContacto(SetEmailContacto event, Emitter<EdificacionState> emit) {
    if (!event.email.contains('@')) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese un email válido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    emit(state.copyWith(emailContacto: event.email));
    developer.log('SetEmailContacto: ${event.email}', name: 'EdificacionBloc');
  }

  void _onSetOcupacion(SetOcupacion event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(ocupacion: event.ocupacion));
    developer.log('SetOcupacion: ${event.ocupacion}', name: 'EdificacionBloc');
  }

  void _onLoadTemporaryData(LoadTemporaryData event, Emitter<EdificacionState> emit) {
    if (state != EdificacionState()) {
      emit(state);
      developer.log('LoadTemporaryData: Loaded', name: 'EdificacionBloc');
    }
  }

  void _onSetCoordenadas(SetCoordenadas event, Emitter<EdificacionState> emit) {
    if (event.latitud < -90 || event.latitud > 90 || event.longitud < -180 || event.longitud > 180) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Coordenadas inválidas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    emit(state.copyWith(
      latitud: event.latitud.toString(),
      longitud: event.longitud.toString(),
    ));
    developer.log(
      'SetCoordenadas: ${event.latitud}, ${event.longitud}',
      name: 'EdificacionBloc'
    );
  }

  void _onSetDepartamento(SetDepartamento event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(
      departamento: event.departamento,
      municipio: null, // Resetear municipio cuando cambia el departamento
    ));
    developer.log('SetDepartamento: ${event.departamento}', name: 'EdificacionBloc');
  }

  void _onSetMunicipio(SetMunicipio event, Emitter<EdificacionState> emit) {
    if (state.departamento == null) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar primero un departamento'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    emit(state.copyWith(municipio: event.municipio));
    developer.log('SetMunicipio: ${event.municipio}', name: 'EdificacionBloc');
  }

  String _construirDireccion(EdificacionState state) {
    final List<String> partes = [];

    // Vía principal
    if (state.tipoVia != null) {
      partes.add(state.tipoVia!);
      if (state.numeroVia != null) partes.add(state.numeroVia!);
      if (state.apendiceVia != null && state.apendiceVia!.isNotEmpty) partes.add(state.apendiceVia!);
      if (state.orientacionVia != null && state.orientacionVia!.isNotEmpty) {
        if ((state.tipoVia == 'CL' && state.orientacionVia == 'SUR') ||
            (state.tipoVia == 'CR' && state.orientacionVia == 'ESTE')) {
          partes.add(state.orientacionVia!);
        }
      }
    }

    // Cruce
    if (state.numeroCruce != null) {
      partes.add('#');
      partes.add(state.numeroCruce!);
      if (state.apendiceCruce != null && state.apendiceCruce!.isNotEmpty) partes.add(state.apendiceCruce!);
      if (state.orientacionCruce != null && state.orientacionCruce!.isNotEmpty) {
        if ((state.tipoVia == 'CL' && state.orientacionCruce == 'SUR') ||
            (state.tipoVia == 'CR' && state.orientacionCruce == 'ESTE')) {
          partes.add(state.orientacionCruce!);
        }
      }
    }

    // Número y complemento
    if (state.numero != null) {
      partes.add('-');
      partes.add(state.numero!);
      if (state.complemento != null && state.complemento!.isNotEmpty) {
        partes.add('(${state.complemento})');
      }
    }

    return partes.join(' ');
  }

  void _actualizarDireccionCompleta(EdificacionState newState, Emitter<EdificacionState> emit) {
    final direccion = _construirDireccion(newState);
    if (direccion != newState.direccion) {
      emit(newState.copyWith(direccion: direccion));
    }
  }

  void _onSetTipoVia(SetTipoVia event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(tipoVia: event.tipoVia);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetTipoVia: ${event.tipoVia}', name: 'EdificacionBloc');
  }

  void _onSetNumeroVia(SetNumeroVia event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(numeroVia: event.numeroVia);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetNumeroVia: ${event.numeroVia}', name: 'EdificacionBloc');
  }

  void _onSetApendiceVia(SetApendiceVia event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(apendiceVia: event.apendiceVia);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetApendiceVia: ${event.apendiceVia}', name: 'EdificacionBloc');
  }

  void _onSetOrientacionVia(SetOrientacionVia event, Emitter<EdificacionState> emit) {
    final tipoVia = state.tipoVia;
    if (tipoVia != null) {
      if ((tipoVia == 'CL' && event.orientacionVia == 'ESTE') ||
          (tipoVia == 'CR' && event.orientacionVia == 'SUR')) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(
              tipoVia == 'CL' 
                ? 'Las Calles solo pueden tener orientación SUR'
                : 'Las Carreras solo pueden tener orientación ESTE'
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      final newState = state.copyWith(orientacionVia: event.orientacionVia);
      emit(newState);
      _actualizarDireccionCompleta(newState, emit);
      developer.log('SetOrientacionVia: ${event.orientacionVia}', name: 'EdificacionBloc');
    }
  }

  void _onSetNumeroCruce(SetNumeroCruce event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(numeroCruce: event.numeroCruce);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetNumeroCruce: ${event.numeroCruce}', name: 'EdificacionBloc');
  }

  void _onSetApendiceCruce(SetApendiceCruce event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(apendiceCruce: event.apendiceCruce);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetApendiceCruce: ${event.apendiceCruce}', name: 'EdificacionBloc');
  }

  void _onSetOrientacionCruce(SetOrientacionCruce event, Emitter<EdificacionState> emit) {
    final tipoVia = state.tipoVia;
    if (tipoVia != null) {
      if ((tipoVia == 'CL' && event.orientacionCruce == 'ESTE') ||
          (tipoVia == 'CR' && event.orientacionCruce == 'SUR')) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(
              tipoVia == 'CL' 
                ? 'Las Calles solo pueden tener orientación SUR'
                : 'Las Carreras solo pueden tener orientación ESTE'
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      final newState = state.copyWith(orientacionCruce: event.orientacionCruce);
      emit(newState);
      _actualizarDireccionCompleta(newState, emit);
      developer.log('SetOrientacionCruce: ${event.orientacionCruce}', name: 'EdificacionBloc');
    }
  }

  void _onSetNumero(SetNumero event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(numero: event.numero);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetNumero: ${event.numero}', name: 'EdificacionBloc');
  }

  void _onSetComplemento(SetComplemento event, Emitter<EdificacionState> emit) {
    final newState = state.copyWith(complemento: event.complemento);
    emit(newState);
    _actualizarDireccionCompleta(newState, emit);
    developer.log('SetComplemento: ${event.complemento}', name: 'EdificacionBloc');
  }

  void _onSetLatitud(SetLatitud event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(latitud: event.latitud));
  }

  void _onSetLongitud(SetLongitud event, Emitter<EdificacionState> emit) {
    emit(state.copyWith(longitud: event.longitud));
  }
} 