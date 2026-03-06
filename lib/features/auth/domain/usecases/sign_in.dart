import 'package:notas_equipo_app/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<void> call({required String email, required String password}) {
    return repository.signIn(email, password);
  }
}
