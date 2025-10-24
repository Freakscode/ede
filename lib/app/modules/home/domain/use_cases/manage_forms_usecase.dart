import '../entities/form_entity.dart';
import '../repositories/home_repository_interface.dart';

/// Caso de uso para gestionar formularios
/// Encapsula la lógica de negocio para operaciones con formularios
class ManageFormsUseCase {
  final HomeRepositoryInterface _repository;

  const ManageFormsUseCase(this._repository);

  /// Obtener todos los formularios
  Future<List<FormEntity>> getAllForms() async {
    try {
      return await _repository.getSavedForms();
    } catch (e) {
      // En caso de error, devolver lista vacía
      return [];
    }
  }

  /// Obtener formularios por estado
  Future<List<FormEntity>> getFormsByStatus(FormStatus status) async {
    try {
      return await _repository.getFormsByStatus(status);
    } catch (e) {
      return [];
    }
  }

  /// Crear un nuevo formulario
  Future<FormEntity> createForm({
    required String eventName,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Generar ID único para el formulario
      final formId = _generateFormId(eventName);
      
      // Crear la entidad del formulario
      final form = FormEntity.create(
        id: formId,
        eventName: eventName,
        data: data,
      );
      
      // Validar el formulario antes de guardarlo
      if (!form.isValid()) {
        throw Exception('Formulario inválido');
      }
      
      // Guardar el formulario
      await _repository.saveForm(form);
      
      // Establecer como formulario activo
      await _repository.setActiveFormId(formId);
      
      return form;
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar un formulario existente
  Future<FormEntity> updateForm({
    required String formId,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Obtener el formulario existente
      final existingForm = await _repository.getFormById(formId);
      
      if (existingForm == null) {
        throw Exception('Formulario no encontrado');
      }
      
      // Crear una copia actualizada
      final updatedForm = existingForm.copyWith(
        data: data,
        lastModified: DateTime.now(),
      );
      
      // Validar el formulario actualizado
      if (!updatedForm.isValid()) {
        throw Exception('Formulario actualizado inválido');
      }
      
      // Guardar el formulario actualizado
      await _repository.saveForm(updatedForm);
      
      return updatedForm;
    } catch (e) {
      rethrow;
    }
  }

  /// Completar un formulario
  Future<FormEntity> completeForm({
    required String formId,
    Map<String, dynamic>? finalData,
  }) async {
    try {
      // Obtener el formulario existente
      final existingForm = await _repository.getFormById(formId);
      
      if (existingForm == null) {
        throw Exception('Formulario no encontrado');
      }
      
      // Verificar que el formulario puede ser completado
      if (!existingForm.canBeCompleted) {
        throw Exception('El formulario no puede ser completado');
      }
      
      // Crear una copia completada
      final completedForm = existingForm.copyWith(
        status: FormStatus.completed,
        data: finalData ?? existingForm.data,
        lastModified: DateTime.now(),
        isExplicitlyCompleted: true,
      );
      
      // Guardar el formulario completado
      await _repository.saveForm(completedForm);
      
      return completedForm;
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar un formulario
  Future<void> deleteForm(String formId) async {
    try {
      // Obtener el formulario existente
      final existingForm = await _repository.getFormById(formId);
      
      if (existingForm == null) {
        throw Exception('Formulario no encontrado');
      }
      
      // Verificar que el formulario puede ser eliminado
      if (!existingForm.canBeDeleted) {
        throw Exception('El formulario no puede ser eliminado');
      }
      
      // Eliminar el formulario
      await _repository.deleteForm(formId);
      
      // Si era el formulario activo, limpiarlo
      final activeFormId = await _repository.getActiveFormId();
      if (activeFormId == formId) {
        await _repository.clearActiveFormId();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener formulario activo
  Future<FormEntity?> getActiveForm() async {
    try {
      final activeFormId = await _repository.getActiveFormId();
      
      if (activeFormId == null) {
        return null;
      }
      
      return await _repository.getFormById(activeFormId);
    } catch (e) {
      return null;
    }
  }

  /// Establecer formulario activo
  Future<void> setActiveForm(String formId) async {
    try {
      // Verificar que el formulario existe
      final form = await _repository.getFormById(formId);
      
      if (form == null) {
        throw Exception('Formulario no encontrado');
      }
      
      // Establecer como activo
      await _repository.setActiveFormId(formId);
    } catch (e) {
      rethrow;
    }
  }

  /// Limpiar formulario activo
  Future<void> clearActiveForm() async {
    try {
      await _repository.clearActiveFormId();
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener estadísticas de formularios
  Future<Map<String, int>> getFormStatistics() async {
    try {
      return await _repository.getFormStatistics();
    } catch (e) {
      return {
        'total': 0,
        'inProgress': 0,
        'completed': 0,
      };
    }
  }

  /// Lógica de negocio: Generar ID único para formulario
  String _generateFormId(String eventName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final eventId = eventName.replaceAll(' ', '_').toLowerCase();
    return '${eventId}_form_$timestamp';
  }
}
