import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/laporan_models.dart';
import 'package:flutter_application_1/services/transaksi_services.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  final TransaksiService _transaksiService = TransaksiService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<RiwayatTransaksiItem>> _riwayatFuture;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2FA),
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: const Color(0xff2D4A8A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _keyword = value.toLowerCase().trim());
              },
              decoration: InputDecoration(
                hintText: 'Cari kode transaksi...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<RiwayatTransaksiItem>>(
                future: _riwayatFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Gagal memuat riwayat:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final items = snapshot.data ?? <RiwayatTransaksiItem>[];
                  final filtered = items.where((item) {
                    if (_keyword.isEmpty) return true;
                    return item.kode.toLowerCase().contains(_keyword);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Riwayat transaksi kosong'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _reload(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final row = filtered[index];
                        return _rowCard(row);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowCard(RiwayatTransaksiItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xffDDE6F8),
            child: Icon(Icons.history_rounded, color: Color(0xff2D4A8A)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.kode,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  item.waktu == null ? '-' : _formatDateTime(item.waktu!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _rupiah(item.nominal),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xff2D4A8A),
            ),
          ),
        ],
      ),
    );
  }

  void _reload() {
    setState(() {
      _riwayatFuture = _transaksiService.fetchRiwayatDetailTransaksi();
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

  String _formatDateTime(DateTime value) {
    final d = value.day.toString().padLeft(2, '0');
    final m = value.month.toString().padLeft(2, '0');
    final y = value.year;
    final h = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }
}
