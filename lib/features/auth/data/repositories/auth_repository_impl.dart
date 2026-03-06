import 'package:notas_equipo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notas_equipo_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> signIn(String email, String password) =>
      remoteDatasource.signIn(email: email, password: password);

  @override
  Future<void> signUp(String email, String password) =>
      remoteDatasource.signUp(email: email, password: password);

  @override
  Future<void> signOut() => remoteDatasource.signOut();

  @override
  Stream<bool> authStateChanges() => remoteDatasource.authStateChanges();
}
