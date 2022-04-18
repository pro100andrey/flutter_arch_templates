import '../app_state.dart';
import 'models/forgot_password_state.dart';


/// returns waiting value
bool selectForgotPasswordIsWaiting(AppState state) =>
    state.wait.isWaitingFor(ForgotPasswordWaiting.wait);