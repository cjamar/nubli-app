import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  final SupabaseClient client;

  AuthRemoteDatasource(this.client);

  Future<void> signIn({required String email, required String password}) async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.user == null) {
      throw Exception('Credenciales inválidas');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    await client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Stream<bool> authStateChanges() =>
      client.auth.onAuthStateChange.map((event) => event.session != null);
}
