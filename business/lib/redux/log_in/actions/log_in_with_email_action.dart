import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/redux/log_in/models/waiting.dart';

import '../../app_state.dart';
import '../log_in_selectors.dart';

class LogInWithEmailAction extends ReduxAction<AppState> {
  @override
  void before() => dispatch(WaitAction.add(LogInWarning.wait));

  @override
  void after() => dispatch(WaitAction.remove(LogInWarning.wait));

  @override
  Future<AppState?> reduce() async {
    // ignore: unused_local_variable
    final email = selectLogInEmail(state);
    // ignore: unused_local_variable
    final password = selectLogInPassword(state);
    // async login request ...
    return null;
  }
}