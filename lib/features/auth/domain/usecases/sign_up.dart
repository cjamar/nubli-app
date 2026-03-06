import 'package:notas_equipo_app/features/auth/domain/repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<void> call({required String email, required String password}) {
    return repository.signUp(email, password);
  }
}
