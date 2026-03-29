import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_services.dart';

class LoginResult {
  const LoginResult({
    required this.response,
    required this.role,
  });

  final AuthResponse response;
  final String role;
}

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  Future<LoginResult> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('User tidak ditemukan setelah login.');
    }

    final role = await _fetchRoleFromProfile(user.id);

    if (role == null) {
      throw Exception(
        'Role user tidak ditemukan. Pastikan role admin/petugas ada di tabel profiles.',
      );
    }

    return LoginResult(response: response, role: role);
  }

  Future<String?> _fetchRoleFromProfile(String userId) async {
    try {
      final data = await _client
          .from('users')
          .select('role')
          .eq('id', userId)
          .maybeSingle();

      final role = (data?['role'] as String?)?.toLowerCase().trim();

      if (role == 'admin' || role == 'petugas') {
        return role;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}