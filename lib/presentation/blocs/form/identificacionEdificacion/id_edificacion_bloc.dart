import 'package:flutter_bloc/flutter_bloc.dart';
import 'id_edificacion_event.dart';
import 'id_edificacion_state.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class EdificacionBloc extends Bloc<EdificacionEvent, EdificacionState> {
  EdificacionBloc() : super(EdificacionState()) {
    on<SetNombreEdificacion>((event, emit) {
      emit(state.copyWith(nombreEdificacion: event.nombre));
      developer.log('SetNombreEdificacion: ${event.nombre}', name: 'EdificacionBloc');
    });

    on<SetDireccion>((event, emit) {
      emit(state.copyWith(direccion: event.direccion));
      developer.log('SetDireccion: ${event.direccion}', name: 'EdificacionBloc');
    });

    on<SetComuna>((event, emit) {
      emit(state.copyWith(comuna: event.comuna));
      developer.log('SetComuna: ${event.comuna}', name: 'EdificacionBloc');
    });

    on<SetBarrio>((event, emit) {
      emit(state.copyWith(barrio: event.barrio));
      developer.log('SetBarrio: ${event.barrio}', name: 'EdificacionBloc');
    });

    on<SetCodigoBarrio>((event, emit) {
      emit(state.copyWith(codigoBarrio: event.codigo));
      developer.log('SetCodigoBarrio: ${event.codigo}', name: 'EdificacionBloc');
    });

    // Manejadores para Identificación Catastral
    on<SetCBML>((event, emit) {
      emit(state.copyWith(cbml: event.cbml));
      developer.log('SetCBML: ${event.cbml}', name: 'EdificacionBloc');
    });

    on<SetMatriculaInmobiliaria>((event, emit) {
      emit(state.copyWith(matriculaInmobiliaria: event.matricula));
      developer.log('SetMatriculaInmobiliaria: ${event.matricula}', name: 'EdificacionBloc');
    });

    // Manejadores para Persona de Contacto
    on<SetNombreContacto>((event, emit) {
      emit(state.copyWith(nombreContacto: event.nombre));
      developer.log('SetNombreContacto: ${event.nombre}', name: 'EdificacionBloc');
    });

    on<SetTelefonoContacto>((event, emit) {
      emit(state.copyWith(telefonoContacto: event.telefono));
      developer.log('SetTelefonoContacto: ${event.telefono}', name: 'EdificacionBloc');
    });

    on<SetEmailContacto>((event, emit) {
      emit(state.copyWith(emailContacto: event.email));
      developer.log('SetEmailContacto: ${event.email}', name: 'EdificacionBloc');
    });

    on<SetOcupacion>((event, emit) {
      emit(state.copyWith(ocupacion: event.ocupacion));
      developer.log('SetOcupacion: ${event.ocupacion}', name: 'EdificacionBloc');
    });

    // Agregar nuevo evento para cargar datos temporales
    on<LoadTemporaryData>((event, emit) {
      if (state != EdificacionState()) {
        emit(state);
      }
    });

    on<SetCoordenadas>((event, emit) {
      emit(state.copyWith(
        latitud: event.latitud,
        longitud: event.longitud,
      ));
      developer.log(
        'SetCoordenadas: ${event.latitud}, ${event.longitud}',
        name: 'EdificacionBloc'
      );
    });

    on<SetNumeroVia>((event, emit) {
      emit(state.copyWith(numeroVia: event.numeroVia));
      developer.log('SetNumeroVia: ${event.numeroVia}', name: 'EdificacionBloc');
    });

    on<SetApendiceVia>((event, emit) {
      emit(state.copyWith(apendiceVia: event.apendiceVia));
      developer.log('SetApendiceVia: ${event.apendiceVia}', name: 'EdificacionBloc');
    });

    on<SetOrientacionVia>((event, emit) {
      final tipoVia = state.tipoVia;
      if (tipoVia != null) {
        if ((tipoVia == 'CL' && event.orientacionVia == 'ESTE') ||
            (tipoVia == 'CR' && event.orientacionVia == 'SUR')) {
          // Emitir estado con orientación vacía
          emit(state.copyWith(orientacionVia: ''));
          // Mostrar SnackBar con advertencia
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
        } else {
          emit(state.copyWith(orientacionVia: event.orientacionVia));
        }
      }
    });

    on<SetTipoVia>((event, emit) {
      emit(state.copyWith(tipoVia: event.tipoVia));
      developer.log('SetTipoVia: ${event.tipoVia}', name: 'EdificacionBloc');
    });

    on<SetNumeroCruce>((event, emit) {
      emit(state.copyWith(numeroCruce: event.numeroCruce));
      developer.log('SetNumeroCruce: ${event.numeroCruce}', name: 'EdificacionBloc');
    });

    on<SetApendiceCruce>((event, emit) {
      emit(state.copyWith(apendiceCruce: event.apendiceCruce));
      developer.log('SetApendiceCruce: ${event.apendiceCruce}', name: 'EdificacionBloc');
    });

    on<SetOrientacionCruce>((event, emit) {
      final tipoVia = state.tipoVia;
      if (tipoVia != null) {
        if ((tipoVia == 'CL' && event.orientacionCruce == 'ESTE') ||
            (tipoVia == 'CR' && event.orientacionCruce == 'SUR')) {
          // Emitir estado con orientación vacía
          emit(state.copyWith(orientacionCruce: ''));
          // Mostrar SnackBar con advertencia
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
        } else {
          emit(state.copyWith(orientacionCruce: event.orientacionCruce));
        }
      }
    });

    on<SetNumero>((event, emit) {
      emit(state.copyWith(numero: event.numero));
      developer.log('SetNumero: ${event.numero}', name: 'EdificacionBloc');
    });

    on<SetComplemento>((event, emit) {
      emit(state.copyWith(complemento: event.complemento));
      developer.log('SetComplemento: ${event.complemento}', name: 'EdificacionBloc');
    });
  }
} 