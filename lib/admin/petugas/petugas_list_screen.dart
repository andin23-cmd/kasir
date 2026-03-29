import 'package:flutter/material.dart';

class PetugasListPage extends StatefulWidget {
  const PetugasListPage({super.key});

  @override
  State<PetugasListPage> createState() => _PetugasListPageState();
}

class _PetugasListPageState extends State<PetugasListPage> {
  final List<Map<String, String>> _petugas = [
    {'nama': 'Andin', 'role': 'Admin', 'telepon': '081234567890'},
    {'nama': 'Rina', 'role': 'Kasir', 'telepon': '082233445566'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2FA),
      appBar: AppBar(
        title: const Text('CRUD Petugas'),
        backgroundColor: const Color(0xff2D4A8A),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2D4A8A),
        onPressed: _tambahPetugas,
        child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _petugas.length,
        itemBuilder: (context, index) {
          final item = _petugas[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xffDDE6F8),
                  child: Icon(Icons.person_rounded, color: Color(0xff2D4A8A)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama']!,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(item['role']!, style: const TextStyle(fontSize: 12)),
                      Text(
                        item['telepon']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editPetugas(item);
                    } else if (value == 'hapus') {
                      setState(() => _petugas.remove(item));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _tambahPetugas() async {
    final nama = TextEditingController();
    final role = TextEditingController();
    final telp = TextEditingController();
    final ok = await _showForm(
      nama: nama,
      role: role,
      telp: telp,
      title: 'Tambah Petugas',
    );
    if (ok == true) {
      setState(() {
        _petugas.add({
          'nama': nama.text.trim(),
          'role': role.text.trim(),
          'telepon': telp.text.trim(),
        });
      });
    }
  }

  Future<void> _editPetugas(Map<String, String> item) async {
    final nama = TextEditingController(text: item['nama']);
    final role = TextEditingController(text: item['role']);
    final telp = TextEditingController(text: item['telepon']);
    final ok = await _showForm(
      nama: nama,
      role: role,
      telp: telp,
      title: 'Edit Petugas',
    );
    if (ok == true) {
      setState(() {
        item['nama'] = nama.text.trim();
        item['role'] = role.text.trim();
        item['telepon'] = telp.text.trim();
      });
    }
  }

  Future<bool?> _showForm({
    required TextEditingController nama,
    required TextEditingController role,
    required TextEditingController telp,
    required String title,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nama,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: role,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: telp,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telepon'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
