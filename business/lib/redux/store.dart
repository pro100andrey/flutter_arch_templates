import 'package:async_redux/async_redux.dart';
import 'package:logging/logging.dart';
import 'app_state.dart';
import 'models/localized_message.dart';

Store<AppState> newStore({
  UserErrorWrapperHandler? userErrorWrapper,
}) {
  WaitAction.reducer = _waitReducer;

  return Store<AppState>(
    initialState: AppState.initial(),
    errorObserver: _MyErrorObserver(),
    wrapError: _MyWrapError(customErrorWrapper: userErrorWrapper),
    actionObservers: [
      _ReduxActionLogger(),
    ],
    modelObserver: _DefaultModelObserver<dynamic>(),
  );
}

void _waitReducer(
  // ignore: avoid_annotating_with_dynamic
  dynamic state,
  WaitOperation operation,
  Object? flag,
  Object? ref,
) =>
// ignore: avoid_dynamic_calls
    state.copyWith(
      // ignore: avoid_dynamic_calls
      wait: state.wait.process(
        operation,
        flag: flag,
        ref: ref,
      ),
    );

class _MyErrorObserver implements ErrorObserver<AppState> {
  final _logger = Logger('Redux');

  @override
  bool observe(
    Object error,
    StackTrace stackTrace,
    ReduxAction<AppState> action,
    Store store,
  ) {
    _logger.shout('Error thrown during $action: $error');
    return false;
  }
}

typedef UserErrorWrapperHandler = LocalizedMessage? Function(Object? error);

class _MyWrapError extends WrapError<AppState> {
  _MyWrapError({this.customErrorWrapper});
  final UserErrorWrapperHandler? customErrorWrapper;

  bool _logoutProcessed = false;

  @override
  Object? wrap(Object error, StackTrace stackTrace, ReduxAction action) {
    if (_logoutProcessed) {
      return null;
    }

    if (customErrorWrapper != null) {
      final message = customErrorWrapper!(error);
      if (message != null) {
        return UserException(
          message.message,
          cause: message.title,
        );
      }
    }

    if (error is UserException) {
      return error;
    }

    return UserException('$error', cause: error);
  }
}

class _ReduxActionLogger extends ActionObserver<AppState> {
  final _logger = Logger('Redux');

  @override
  void observe(
    ReduxAction<AppState> action,
    int dispatchCount, {
    bool ini = false,
  }) {
    if (action is WaitAction<AppState>) {
      final iniString = ini ? 'start' : 'end';

      _logger.info(
        '$action [${action.flag}] '
        'O: ${action.operation} '
        'D: $dispatchCount - $iniString',
      );
      return;
    }

    _logger.info(
      '$action D: $dispatchCount - ${ini ? 'start' : 'end'}',
    );
  }
}

class _DefaultModelObserver<Model> implements ModelObserver<Model> {
  final _logger = Logger('Redux');

  @override
  void observe({
    required Model? modelPrevious,
    required Model? modelCurrent,
    bool? isDistinct,
    StoreConnectorInterface? storeConnector,
    int? reduceCount,
    int? dispatchCount,
  }) {
    _logger.info('D: $dispatchCount R: $reduceCount = '
        'Rebuild: $isDistinct, '
        '${storeConnector.runtimeType}');
  }
}