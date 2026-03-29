class PelangganModel {
  final String id;
  final String nama;
  final String noHp;
  final String alamat;
  final DateTime? createdAt;

  PelangganModel({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.createdAt,
  });

  factory PelangganModel.fromMap(Map<String, dynamic> map) {
    return PelangganModel(
      id: map['id']?.toString() ?? '',
      nama: map['nama']?.toString() ?? '',
      noHp: map['no_hp']?.toString() ?? '',
      alamat: map['alamat']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
    );
  }
}
