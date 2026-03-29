class WeeklySalesPoint {
  final String day;
  final int total;

  const WeeklySalesPoint({required this.day, required this.total});
}

class RiwayatTransaksiItem {
  final String kode;
  final DateTime? waktu;
  final int nominal;

  const RiwayatTransaksiItem({
    required this.kode,
    required this.waktu,
    required this.nominal,
  });
}

class LaporanData {
  final List<WeeklySalesPoint> weeklySales;
  final List<RiwayatTransaksiItem> riwayat;

  const LaporanData({required this.weeklySales, required this.riwayat});
}
