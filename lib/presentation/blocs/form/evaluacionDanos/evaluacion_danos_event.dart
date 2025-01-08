abstract class EvaluacionDanosEvent {}

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