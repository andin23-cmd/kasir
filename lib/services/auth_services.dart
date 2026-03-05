import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_services.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  Future<AuthResponse> login(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}