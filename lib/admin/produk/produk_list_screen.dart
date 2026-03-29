import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/produk/edit_produk_screen.dart';
import 'package:flutter_application_1/models/produk_models.dart';
import 'package:flutter_application_1/services/produk_services.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final ProdukService _produkService = ProdukService();
  final TextEditingController _searchController = TextEditingController();
  final Color _primary = const Color(0xff2D4A8A);

  late Future<List<ProdukModel>> _produkFuture;
  String _keyword = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _reloadProduk(updateUi: false);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primary,
        onPressed: () {},
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topSection(),
            Expanded(child: _productList()),
          ],
        ),
      ),
    );
  }

  Widget _topSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffD8E0F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _keyword = value.toLowerCase().trim();
                      });
                    },
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.search_rounded,
                        color: Color(0xff8391AB),
                      ),
                      hintText: 'Cari produk atau kategori...',
                      hintStyle: TextStyle(fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _showCategoryFilter,
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 38,
                      minHeight: 38,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          if (_selectedCategory != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffE8EEFA),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    size: 14,
                    color: Color(0xff2D4A8A),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedCategory!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff2D4A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Color(0xff2D4A8A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _productList() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _listHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<ProdukModel>>(
              future: _produkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _stateInfo(
                    icon: Icons.error_outline_rounded,
                    title: 'Gagal memuat produk',
                    subtitle: '${snapshot.error}',
                  );
                }

                final items = snapshot.data ?? <ProdukModel>[];
                final filtered = items.where((produk) {
                  final keywordMatch =
                      _keyword.isEmpty ||
                      produk.nama.toLowerCase().contains(_keyword) ||
                      produk.kategori.toLowerCase().contains(_keyword);
                  final categoryMatch =
                      _selectedCategory == null ||
                      produk.kategori.toLowerCase() ==
                          _selectedCategory!.toLowerCase();
                  return keywordMatch && categoryMatch;
                }).toList();

                if (filtered.isEmpty) {
                  return _stateInfo(
                    icon: Icons.search_off_rounded,
                    title: 'Produk tidak ditemukan',
                    subtitle: 'Coba kata kunci lain',
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final produk = filtered[index];
                    return ProductItem(
                      produk: produk,
                      onEdit: () {
                        Navigator.push<bool>(
                          context,
                          MaterialPageRoute<bool>(
                            builder: (_) => EditProdukPage(produk: produk),
                          ),
                        ).then((updated) {
                          if (updated == true && mounted) {
                            _reloadProduk();
                          }
                        });
                      },
                      onDelete: () => _confirmDelete(produk),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          const Text(
            'Semua Produk',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff132547),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffECF1FA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Terbaru',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xff4B5A7A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stateInfo({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: const Color(0xff8B97AD)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xff132547),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xff6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _showCategoryFilter() async {
    try {
      final items = await _produkFuture;
      if (!mounted) return;

      final categories =
          items
              .map((e) => e.kategori.trim())
              .where((e) => e.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Kategori',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Semua kategori'),
                    trailing: _selectedCategory == null
                        ? Icon(Icons.check_rounded, color: _primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ...categories.map((kategori) {
                    final selected =
                        _selectedCategory?.toLowerCase() ==
                        kategori.toLowerCase();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(kategori),
                      trailing: selected
                          ? Icon(Icons.check_rounded, color: _primary)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = kategori;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori belum bisa dimuat')),
      );
    }
  }

  Future<void> _confirmDelete(ProdukModel produk) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Anda yakin ingin menghapus produk?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _produkService.deleteProduk(produk.id);
        if (!mounted) return;
        _reloadProduk();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus produk: $e')));
      }
    }
  }

  void _reloadProduk({bool updateUi = true}) {
    final nextFuture = _produkService.fetchProduk();
    if (updateUi) {
      setState(() {
        _produkFuture = nextFuture;
      });
    } else {
      _produkFuture = nextFuture;
    }
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.produk,
    required this.onEdit,
    required this.onDelete,
  });

  final ProdukModel produk;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xffF8FAFF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _productImage(produk.fotoUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produk.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xff1B2A4D),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatRupiah(produk.harga),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff2D4A8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _infoChip(
                          icon: Icons.inventory_2_outlined,
                          label: 'Stok: ${produk.stok}',
                        ),
                        _infoChip(
                          icon: Icons.sell_outlined,
                          label: produk.kategori,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 20),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'hapus') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffDCE4F3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xff62718E)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff4B5A7A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImage(String? fotoUrl) {
    if (fotoUrl == null || fotoUrl.isEmpty) {
      return Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: const Color(0xffE5EAF5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.image_rounded,
          size: 20,
          color: Color(0xff8B97AD),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        fotoUrl,
        width: 62,
        height: 62,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            width: 62,
            height: 62,
            color: const Color(0xffE5EAF5),
            child: const Icon(
              Icons.broken_image_rounded,
              size: 20,
              color: Color(0xff8B97AD),
            ),
          );
        },
      ),
    );
  }

  String _formatRupiah(num number) {
    final value = number.round().toString();
    final buffer = StringBuffer();
    int counter = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      buffer.write(value[i]);
      counter++;
      if (counter % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }
}
