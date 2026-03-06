import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:notas_equipo_app/features/auth/presentation/bloc/auth_state.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final AuthRepository repository;

  StreamSubscription<bool>? _authSub;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.repository,
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<AuthStatusChanged>(_onAuthStatusChanged);

    _authSub = repository.authStateChanges().listen(
      (isAuth) => add(AuthStatusChanged(isAuth)),
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signIn(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signUp(email: event.email, password: event.password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await signOut();
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    emit(event.isAuthenticated ? Authenticated() : Unauthenticated());
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
