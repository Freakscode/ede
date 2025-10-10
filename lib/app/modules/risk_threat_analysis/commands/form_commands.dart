import 'command_result.dart';
import '../models/domain/form_data.dart';
import '../interfaces/form_data_interface.dart';

/// Comando abstracto
abstract class FormCommand {
  Future<CommandResult> execute();
}

/// Comando para guardar datos de formulario
class SaveFormDataCommand extends FormCommand {
  final FormData formData;
  final FormDataInterface formDataService;
  
  SaveFormDataCommand({
    required this.formData,
    required this.formDataService,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Validar datos antes de guardar
      if (!formData.isValid) {
        return CommandResult.failure(
          message: 'Datos de formulario inválidos',
        );
      }

      // Guardar datos
      await formDataService.saveFormData(formData);
      
      return CommandResult.success(
        message: 'Formulario guardado exitosamente',
        data: formData,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al guardar formulario: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}

/// Comando para cargar datos de formulario
class LoadFormDataCommand extends FormCommand {
  final String eventName;
  final String classificationType;
  final FormDataInterface formDataService;
  
  LoadFormDataCommand({
    required this.eventName,
    required this.classificationType,
    required this.formDataService,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Verificar si existe el formulario
      final exists = await formDataService.formDataExists(eventName, classificationType);
      if (!exists) {
        return CommandResult.failure(
          message: 'Formulario no encontrado',
        );
      }

      // Cargar datos
      final formData = await formDataService.loadFormData(eventName, classificationType);
      
      if (formData == null) {
        return CommandResult.failure(
          message: 'No se pudieron cargar los datos del formulario',
        );
      }

      return CommandResult.success(
        message: 'Formulario cargado exitosamente',
        data: formData,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al cargar formulario: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}

/// Comando para limpiar datos de formulario
class ClearFormDataCommand extends FormCommand {
  final String eventName;
  final String classificationType;
  final FormDataInterface formDataService;
  
  ClearFormDataCommand({
    required this.eventName,
    required this.classificationType,
    required this.formDataService,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Limpiar datos
      await formDataService.clearFormData(eventName, classificationType);
      
      return CommandResult.success(
        message: 'Formulario limpiado exitosamente',
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al limpiar formulario: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}

/// Comando para obtener todos los formularios
class GetAllFormDataCommand extends FormCommand {
  final FormDataInterface formDataService;
  
  GetAllFormDataCommand({
    required this.formDataService,
  });

  @override
  Future<CommandResult> execute() async {
    try {
      // Obtener todos los formularios
      final formDataList = await formDataService.getAllFormData();
      
      return CommandResult.success(
        message: 'Formularios obtenidos exitosamente',
        data: formDataList,
      );
    } catch (e) {
      return CommandResult.failure(
        message: 'Error al obtener formularios: $e',
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
