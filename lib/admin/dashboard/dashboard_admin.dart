import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  static const Color _primary = Color(0xff2D4A8A);
  static const Color _background = Color(0xffEEF2FA);
  static const Color _card = Colors.white;
  static const Color _textPrimary = Color(0xff1C2A4A);
  static const Color _textSecondary = Color(0xff66738D);

  static const List<Map<String, dynamic>> _weeklySales = [
    {'day': 'Sen', 'total': 1250000},
    {'day': 'Sel', 'total': 1800000},
    {'day': 'Rab', 'total': 950000},
    {'day': 'Kam', 'total': 2100000},
    {'day': 'Jum', 'total': 1650000},
    {'day': 'Sab', 'total': 2400000},
    {'day': 'Min', 'total': 1300000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              _headerSection(),
              _chartSection(),
              _summarySection(),
              _productSection(),
              _stockSection(),
              _activitySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1F3870), Color(0xff2D4A8A), Color(0xff3A5CA3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(Icons.notifications_none_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo Andin,',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 6),
                Text(
                  'Selamat datang di Aplikasi Kasir TidurImpian',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartSection() {
    final maxValue =
        _weeklySales.map((e) => e['total'] as int).reduce((a, b) => a > b ? a : b);
    final totalMingguan =
        _weeklySales.fold<int>(0, (sum, e) => sum + (e['total'] as int));

    return _sectionCard(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Penjualan per Minggu',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total minggu ini: ${_formatRupiah(totalMingguan)}',
            style: const TextStyle(
              color: _primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _weeklySales
                  .map(
                    (data) => Expanded(
                      child: _weeklyBar(
                        day: data['day'] as String,
                        value: data['total'] as int,
                        maxValue: maxValue,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weeklyBar({
    required String day,
    required int value,
    required int maxValue,
  }) {
    final ratio = maxValue == 0 ? 0.0 : value / maxValue;
    final barHeight = 26 + (92 * ratio);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${(value / 1000000).toStringAsFixed(1)}jt',
            style: const TextStyle(fontSize: 10, color: _textSecondary),
          ),
          const SizedBox(height: 6),
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff4467B0), _primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: const TextStyle(
              fontSize: 11,
              color: _textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int value) {
    final valueStr = value.toString();
    final buffer = StringBuffer();
    int counter = 0;

    for (int i = valueStr.length - 1; i >= 0; i--) {
      buffer.write(valueStr[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  Widget _summarySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _metricCard(
              title: 'Total Transaksi',
              value: '145',
              subtitle: 'Transaksi',
              icon: Icons.receipt_long_rounded,
              iconColor: const Color(0xff2E7DFF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _metricCard(
              title: 'Total Laba',
              value: 'Rp 500.000',
              subtitle: 'Minggu ini',
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xff16A34A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return _sectionCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: _textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Produk Terlaris',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _productCard(
                  'Kasur Orthopedic Deluxe',
                  'Rp 3.200.000',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _productCard(
                  'Kasur Premium Comfort',
                  'Rp 4.500.000',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCard(String name, String price) {
    return _sectionCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(
              fontSize: 12,
              color: _primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xffE7ECF8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.bed_rounded, color: Color(0xff7C8FB5), size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stok Menipis',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _stockItem('Kasur Single', 'Rp 1.500.000', '5'),
          _stockItem('Kasur Pillow Top', 'Rp 155.000', '7'),
        ],
      ),
    );
  }

  Widget _stockItem(String name, String price, String qty) {
    return _sectionCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xffFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              qty,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activitySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terakhir',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Color(0xffDDE6F8),
                  child: Icon(Icons.person, color: Color(0xff55698E), size: 18),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Andin\nProses pemesanan',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '3 menit lalu',
                  style: TextStyle(
                    fontSize: 11,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
    required EdgeInsetsGeometry margin,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
