class ProdukModel {
  final String id;
  final String nama;
  final num harga;
  final int stok;
  final String kategori;
  final String? fotoUrl;

  ProdukModel({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.kategori,
    this.fotoUrl,
  });

  factory ProdukModel.fromMap(Map<String, dynamic> map) {
    return ProdukModel(
      id: map['id'].toString(), // UUID -> String
      nama: map['nama']?.toString() ?? '',
      harga: map['harga'] is num
          ? map['harga']
          : num.tryParse(map['harga'].toString()) ?? 0,
      stok: map['stok'] is num
          ? (map['stok'] as num).toInt()
          : int.tryParse(map['stok'].toString()) ??
                num.tryParse(map['stok'].toString())?.toInt() ??
                0,
      kategori: map['kategori']?.toString() ?? '',
      fotoUrl: map['foto_url']?.toString(),
    );
  }
}
