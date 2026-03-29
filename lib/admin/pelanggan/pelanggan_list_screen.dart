import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pelanggan_models.dart';
import 'package:flutter_application_1/services/pelanggan_services.dart';

class PelangganListPage extends StatefulWidget {
  const PelangganListPage({super.key});

  @override
  State<PelangganListPage> createState() => _PelangganListPageState();
}

class _PelangganListPageState extends State<PelangganListPage> {
  final PelangganService _pelangganService = PelangganService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<PelangganModel>> _pelangganFuture;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _reloadPelanggan();
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
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(child: _listSection()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xff2D4A8A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.group_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Data Pelanggan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _keyword = value.toLowerCase().trim());
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Cari nama, no hp, atau alamat...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: FutureBuilder<List<PelangganModel>>(
        future: _pelangganFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _stateInfo(
              title: 'Gagal memuat pelanggan',
              subtitle: '${snapshot.error}',
              icon: Icons.error_outline_rounded,
            );
          }

          final items = snapshot.data ?? <PelangganModel>[];
          final filtered = items.where((pelanggan) {
            if (_keyword.isEmpty) return true;
            return pelanggan.nama.toLowerCase().contains(_keyword) ||
                pelanggan.noHp.toLowerCase().contains(_keyword) ||
                pelanggan.alamat.toLowerCase().contains(_keyword);
          }).toList();

          if (filtered.isEmpty) {
            return _stateInfo(
              title: 'Pelanggan tidak ditemukan',
              subtitle: 'Coba kata kunci lain',
              icon: Icons.search_off_rounded,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reloadPelanggan(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _pelangganCard(filtered[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _pelangganCard(PelangganModel pelanggan) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xffDDE6F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_rounded, color: Color(0xff2D4A8A)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelanggan.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1D2D4E),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_android_rounded,
                      size: 13,
                      color: Color(0xff6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pelanggan.noHp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xff6B7280),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pelanggan.alamat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (pelanggan.createdAt != null)
            Text(
              _shortDate(pelanggan.createdAt!),
              style: const TextStyle(fontSize: 11, color: Color(0xff8A94A8)),
            ),
        ],
      ),
    );
  }

  Widget _stateInfo({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: const Color(0xff8A94A8)),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff1D2D4E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xff6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  void _reloadPelanggan() {
    setState(() {
      _pelangganFuture = _pelangganService.fetchPelanggan();
    });
  }

  String _shortDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}
