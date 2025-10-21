import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:caja_herramientas/app/modules/webview/domain/entities/webview_entity.dart';
import 'package:caja_herramientas/app/modules/webview/domain/usecases/get_webview_config_usecase.dart';

/// Estados del WebView Bloc
abstract class WebViewState extends Equatable {
  const WebViewState();

  @override
  List<Object?> get props => [];
}

class WebViewInitial extends WebViewState {}

class WebViewLoading extends WebViewState {}

class WebViewLoaded extends WebViewState {
  final WebViewEntity config;

  const WebViewLoaded({required this.config});

  @override
  List<Object?> get props => [config];
}

class WebViewError extends WebViewState {
  final String message;

  const WebViewError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Eventos del WebView Bloc
abstract class WebViewEvent extends Equatable {
  const WebViewEvent();

  @override
  List<Object?> get props => [];
}

class LoadWebViewConfig extends WebViewEvent {
  final String webViewType;

  const LoadWebViewConfig({required this.webViewType});

  @override
  List<Object?> get props => [webViewType];
}

/// Bloc para manejar el estado de WebView
class WebViewBloc extends Bloc<WebViewEvent, WebViewState> {
  final GetWebViewConfigUseCase _getWebViewConfigUseCase;

  WebViewBloc({
    required GetWebViewConfigUseCase getWebViewConfigUseCase,
  })  : _getWebViewConfigUseCase = getWebViewConfigUseCase,
        super(WebViewInitial()) {
    on<LoadWebViewConfig>(_onLoadWebViewConfig);
  }

  Future<void> _onLoadWebViewConfig(
    LoadWebViewConfig event,
    Emitter<WebViewState> emit,
  ) async {
    emit(WebViewLoading());

    try {
      final config = await _getWebViewConfigUseCase.execute(event.webViewType);
      emit(WebViewLoaded(config: config));
    } catch (e) {
      emit(WebViewError(message: e.toString()));
    }
  }

  /// Cargar configuración del portal SIRMED
  void loadSirmedPortalConfig() {
    add(const LoadWebViewConfig(webViewType: 'sirmed_portal'));
  }
}
