import 'package:flutter_application_1/models/laporan_models.dart';
import 'package:flutter_application_1/models/transaksi_models.dart';
import 'package:flutter_application_1/services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransaksiService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<TransaksiModel>> fetchTransaksi() async {
    final response = await _selectWithBestOrder('transaksi');

    return (response as List<dynamic>)
        .map(
          (e) => TransaksiModel.fromMap(
            Map<String, dynamic>.from(e as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  Future<LaporanData> fetchLaporanData() async {
    final transaksiResponse = await _client.from('transaksi').select('*');
    final riwayatResponse = await _selectWithBestOrder('detail_transaksi');

    final transaksiRows = (transaksiResponse as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
        .toList();
    final riwayatRows = (riwayatResponse as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
        .toList();

    final weeklySales = _buildWeeklySales(transaksiRows);
    final riwayat = riwayatRows.map(_mapRiwayatItem).toList();

    return LaporanData(weeklySales: weeklySales, riwayat: riwayat);
  }

  Future<List<RiwayatTransaksiItem>> fetchRiwayatDetailTransaksi() async {
    final response = await _selectWithBestOrder('detail_transaksi');

    return (response as List<dynamic>)
        .map(
          (e) => _mapRiwayatItem(
            Map<String, dynamic>.from(e as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  Future<dynamic> _selectWithBestOrder(String table) async {
    try {
      return await _client
          .from(table)
          .select('*')
          .order('created_at', ascending: false);
    } catch (_) {
      try {
        return await _client
            .from(table)
            .select('*')
            .order('id', ascending: false);
      } catch (_) {
        return await _client.from(table).select('*');
      }
    }
  }

  List<WeeklySalesPoint> _buildWeeklySales(List<Map<String, dynamic>> rows) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final totals = List<int>.filled(7, 0);

    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    for (final row in rows) {
      final createdAt = _extractDateTime(row);
      if (createdAt == null) continue;
      if (createdAt.isBefore(startOfWeek) || !createdAt.isBefore(endOfWeek)) {
        continue;
      }

      final dayIndex = createdAt.weekday - 1;
      if (dayIndex >= 0 && dayIndex <= 6) {
        totals[dayIndex] += _extractNominal(row);
      }
    }

    return List<WeeklySalesPoint>.generate(
      7,
      (index) => WeeklySalesPoint(day: days[index], total: totals[index]),
    );
  }

  RiwayatTransaksiItem _mapRiwayatItem(Map<String, dynamic> row) {
    final code = _extractKode(row);
    final createdAt = _extractDateTime(row);
    final nominal = _extractNominal(row);
    return RiwayatTransaksiItem(kode: code, waktu: createdAt, nominal: nominal);
  }

  String _extractKode(Map<String, dynamic> row) {
    final raw =
        row['kode'] ??
        row['kode_transaksi'] ??
        row['nomor_transaksi'] ??
        row['trx_code'] ??
        row['nama'];
    return raw?.toString() ?? '-';
  }

  DateTime? _extractDateTime(Map<String, dynamic> row) {
    final raw = row['created_at'] ?? row['tanggal'] ?? row['waktu'];
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  int _extractNominal(Map<String, dynamic> row) {
    final raw =
        row['total'] ??
        row['nominal'] ??
        row['grand_total'] ??
        row['total_harga'] ??
        row['jumlah'];

    if (raw is int) return raw;
    if (raw is num) return raw.toInt();

    final parsed = num.tryParse(raw?.toString() ?? '');
    return parsed?.toInt() ?? 0;
  }
}
