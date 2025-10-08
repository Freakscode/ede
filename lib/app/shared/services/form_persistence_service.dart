/*
SERVICIO TEMPORALMENTE DESHABILITADO

Este servicio necesita ser refactorizado para trabajar con la nueva estructura de FormDataModel
que ahora usa el patrón jerárquico de RiskEventModel en lugar de Maps planos.

TODO: Refactorizar para la nueva estructura cuando sea necesario implementar persistencia.
*/

import '../models/form_data_model.dart';

class FormPersistenceService {
  // Singleton pattern
  static final FormPersistenceService _instance = FormPersistenceService._internal();
  factory FormPersistenceService() => _instance;
  FormPersistenceService._internal();

  // Métodos temporalmente deshabilitados
  Future<void> saveForm(FormDataModel form) async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: saveForm deshabilitado temporalmente');
  }

  Future<FormDataModel?> getForm(String formId) async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: getForm deshabilitado temporalmente');
    return null;
  }

  Future<List<FormDataModel>> getAllForms() async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: getAllForms deshabilitado temporalmente');
    return [];
  }

  Future<void> deleteForm(String formId) async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: deleteForm deshabilitado temporalmente');
  }

  Future<void> setActiveFormId(String? formId) async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: setActiveFormId deshabilitado temporalmente');
  }

  Future<String?> getActiveFormId() async {
    // TODO: Implementar cuando sea necesario
    print('FormPersistenceService: getActiveFormId deshabilitado temporalmente');
    return null;
  }
}
