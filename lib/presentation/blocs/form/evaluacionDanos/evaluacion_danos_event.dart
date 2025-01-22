abstract class EvaluacionDanosEvent {
  const EvaluacionDanosEvent();
}

class SetCondicionExistente extends EvaluacionDanosEvent {
  final String condicionId;
  final bool? valor;
  
  SetCondicionExistente(this.condicionId, this.valor);
}

class SetNivelElemento extends EvaluacionDanosEvent {
  final String elementoId;
  final String nivel;
  
  SetNivelElemento(this.elementoId, this.nivel);
}

class SetAlcanceEvaluacion extends EvaluacionDanosEvent {
  final String? alcanceExterior;
  final String? alcanceInterior;
  
  SetAlcanceEvaluacion({this.alcanceExterior, this.alcanceInterior});
}

class UpdateDanosEstructurales extends EvaluacionDanosEvent {
  final Map<String, dynamic>? danosEstructurales;
  const UpdateDanosEstructurales(this.danosEstructurales);
}

class UpdateDanosNoEstructurales extends EvaluacionDanosEvent {
  final Map<String, dynamic>? danosNoEstructurales;
  const UpdateDanosNoEstructurales(this.danosNoEstructurales);
}

class UpdateDanosGeotecnicos extends EvaluacionDanosEvent {
  final Map<String, dynamic>? danosGeotecnicos;
  const UpdateDanosGeotecnicos(this.danosGeotecnicos);
} 