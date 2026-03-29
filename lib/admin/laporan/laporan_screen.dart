import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/laporan_models.dart';
import 'package:flutter_application_1/services/transaksi_services.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final TransaksiService _transaksiService = TransaksiService();
  late Future<LaporanData> _laporanFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2FA),
      appBar: AppBar(
        title: const Text('Laporan'),
        backgroundColor: const Color(0xff2D4A8A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<LaporanData>(
        future: _laporanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat laporan: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final laporan =
              snapshot.data ??
              const LaporanData(
                weeklySales: <WeeklySalesPoint>[],
                riwayat: <RiwayatTransaksiItem>[],
              );
          final weekly = laporan.weeklySales;
          final max = weekly.isEmpty
              ? 0
              : weekly.map((e) => e.total).reduce((a, b) => a > b ? a : b);
          final total = weekly.fold<int>(0, (acc, item) => acc + item.total);

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analitik Penjualan',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total: ${_rupiah(total)}',
                        style: const TextStyle(
                          color: Color(0xff2D4A8A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 140,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: weekly.map((item) {
                            final ratio = max == 0 ? 0.0 : item.total / max;
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 24 + (80 * ratio),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff2D4A8A),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.day,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                if (laporan.riwayat.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Center(child: Text('Belum ada riwayat transaksi')),
                  ),
                ...laporan.riwayat.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xffDDE6F8),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xff2D4A8A),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.kode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatWaktu(item.waktu),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _rupiah(item.nominal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2D4A8A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _reload() {
    setState(() {
      _laporanFuture = _transaksiService.fetchLaporanData();
    });
  }

  String _rupiah(int value) {
    final raw = value.toString();
    final buf = StringBuffer();
    int c = 0;
    for (int i = raw.length - 1; i >= 0; i--) {
      buf.write(raw[i]);
      c++;
      if (c % 3 == 0 && i != 0) {
        buf.write('.');
      }
    }
    return 'Rp ${buf.toString().split('').reversed.join()}';
  }

  String _formatWaktu(DateTime? value) {
    if (value == null) return '-';
    final dd = value.day.toString().padLeft(2, '0');
    final mm = value.month.toString().padLeft(2, '0');
    final yy = value.year.toString();
    final hh = value.hour.toString().padLeft(2, '0');
    final mn = value.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yy $hh:$mn';
  }
}
