import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://ixynsawhcrvpjppudidj.supabase.co',
      anonKey: 'sb_publishable_5lQ1VCwgzsr32vTj7xLXxQ_Qkum2Eak',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}