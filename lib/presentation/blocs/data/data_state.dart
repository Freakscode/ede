import '../../../data/models/data_model.dart';

abstract class DataState {}

class DataInitial extends DataState {}
class DataLoading extends DataState {}
class DataLoaded extends DataState {
  final List<DataModel> data;
  final bool isOnline;
  
  DataLoaded(this.data, {this.isOnline = true});
}
class DataError extends DataState {
  final String message;
  
  DataError(this.message);
}