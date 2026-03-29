import 'dart:typed_data';
import 'package:flutter_application_1/models/produk_models.dart';
import 'package:flutter_application_1/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<ProdukModel>> fetchProduk() async {
    final response = await _client
        .from('produk')
        .select('id,nama,harga,stok,kategori,foto_url')
        .order('id', ascending: true);

    return (response as List<dynamic>).map((item) {
      final map = Map<String, dynamic>.from(item as Map<String, dynamic>);
      map['foto_url'] = _buildImageUrl(map['foto_url'] as String?);
      return ProdukModel.fromMap(map);
    }).toList();
  }

  String? _buildImageUrl(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    final value = rawValue.trim();
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      return value;
    }

    final cleanPath = value.startsWith('/') ? value.substring(1) : value;
    final segments = cleanPath.split('/');
    if (segments.length > 1) {
      final bucket = segments.first;
      final path = segments.sublist(1).join('/');
      return _client.storage.from(bucket).getPublicUrl(path);
    }

    // Fallback default bucket untuk foto produk.
    return _client.storage.from('produk').getPublicUrl(cleanPath);
  }

  Future<void> updateProduk({
    required String id,
    required String nama,
    required num harga,
    required int stok,
    required String kategori,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    final updateData = <String, dynamic>{
      'nama': nama,
      'harga': harga,
      'stok': stok,
      'kategori': kategori,
    };

    if (imageBytes != null) {
      final storagePath = _buildStoragePath(
        produkId: id,
        fileName: imageFileName,
      );
      final contentType = _guessContentType(imageFileName);

      await _client.storage
          .from('produk')
          .uploadBinary(
            storagePath,
            imageBytes,
            fileOptions: FileOptions(upsert: true, contentType: contentType),
          );

      // Simpan path bucket-aware agar bisa dibentuk jadi public URL saat fetch.
      updateData['foto_url'] = 'produk/$storagePath';
    }

    await _client.from('produk').update(updateData).eq('id', id);
  }

  Future<void> deleteProduk(String id) async {
    await _client.from('produk').delete().eq('id', id);
  }

  String _buildStoragePath({required String produkId, String? fileName}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final ext = _extractFileExtension(fileName);
    return 'item_${produkId}_$now.$ext';
  }

  String _extractFileExtension(String? fileName) {
    if (fileName == null || !fileName.contains('.')) {
      return 'jpg';
    }

    final extension = fileName.split('.').last.toLowerCase().trim();
    if (extension.isEmpty) {
      return 'jpg';
    }
    return extension;
  }

  String _guessContentType(String? fileName) {
    final ext = _extractFileExtension(fileName);
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
