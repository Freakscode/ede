import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/data_repository.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository repository;

  DataBloc({required this.repository}) : super(DataInitial()) {
    on<FetchData>((event, emit) async {
      emit(DataLoading());
      try {
        final data = await repository.getData();
        emit(DataLoaded(data, isOnline: true));
      } catch (e) {
        // Try to load from local if remote fails
        try {
          final localData = await repository.getLocalData();
          emit(DataLoaded(localData, isOnline: false));
        } catch (e) {
          emit(DataError(e.toString()));
        }
      }
    });

    on<SyncData>((event, emit) async {
      final currentState = state;
      if (currentState is DataLoaded) {
        try {
          await repository.syncData();
          add(FetchData()); // Refresh data after sync
        } catch (e) {
          emit(DataLoaded(currentState.data, isOnline: false));
        }
      }
    });
  }
}