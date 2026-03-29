class TransaksiModel {
  final String id;
  final String kode;
  final int total;
  final String pelanggan;
  final DateTime? createdAt;

  const TransaksiModel({
    required this.id,
    required this.kode,
    required this.total,
    required this.pelanggan,
    required this.createdAt,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      id: (map['id'] ?? '').toString(),
      kode: _extractKode(map),
      total: _extractTotal(map),
      pelanggan: _extractPelanggan(map),
      createdAt: DateTime.tryParse(
        (map['created_at'] ?? map['tanggal'] ?? map['waktu'] ?? '').toString(),
      ),
    );
  }

  static String _extractKode(Map<String, dynamic> map) {
    final raw =
        map['kode'] ??
        map['kode_transaksi'] ??
        map['nomor_transaksi'] ??
        map['trx_code'] ??
        map['nama'];
    return raw?.toString() ?? '-';
  }

  static int _extractTotal(Map<String, dynamic> map) {
    final raw =
        map['total'] ??
        map['nominal'] ??
        map['grand_total'] ??
        map['total_harga'] ??
        map['jumlah'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return num.tryParse(raw?.toString() ?? '')?.toInt() ?? 0;
  }

  static String _extractPelanggan(Map<String, dynamic> map) {
    final raw =
        map['pelanggan_nama'] ??
        map['nama_pelanggan'] ??
        map['pelanggan'] ??
        map['customer_name'];
    return raw?.toString() ?? 'Pelanggan';
  }
}
