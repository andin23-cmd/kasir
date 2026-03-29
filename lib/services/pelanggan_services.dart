import 'package:flutter_application_1/models/pelanggan_models.dart';
import 'package:flutter_application_1/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<PelangganModel>> fetchPelanggan() async {
    final response = await _selectWithBestOrder();

    return (response as List<dynamic>)
        .map(
          (item) => PelangganModel.fromMap(
            Map<String, dynamic>.from(item as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  Future<dynamic> _selectWithBestOrder() async {
    const selectFields = 'id,nama,no_hp,alamat,created_at';
    try {
      return await _client
          .from('pelanggan')
          .select(selectFields)
          .order('created_at', ascending: false);
    } catch (_) {
      try {
        return await _client
            .from('pelanggan')
            .select(selectFields)
            .order('id', ascending: false);
      } catch (_) {
        return await _client.from('pelanggan').select(selectFields);
      }
    }
  }
}
