import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/produk_models.dart';
import 'package:flutter_application_1/services/produk_services.dart';

class ProdukScreen extends StatefulWidget {
  const ProdukScreen({super.key});

  @override
  State<ProdukScreen> createState() => _ProdukScreenState();
}

class _ProdukScreenState extends State<ProdukScreen> {
  final ProdukService _produkService = ProdukService();
  List<ProdukModel> _allProducts = [];
  List<ProdukModel> _filteredProducts = [];
  List<String> _selectedCategories = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await _produkService.fetchProduk();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _extractCategories(products);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat produk: $e';
        _isLoading = false;
      });
    }
  }

  void _extractCategories(List<ProdukModel> products) {
    final categories = products.map((p) => p.kategori).where((c) => c.isNotEmpty).toSet();
    _selectedCategories.clear();
    // Auto-select all initially
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    List<ProdukModel> temp = _allProducts;

    if (query.isNotEmpty) {
      temp = temp.where((p) =>
        p.nama.toLowerCase().contains(query) ||
        p.kategori.toLowerCase().contains(query)
      ).toList();
    }

    if (_selectedCategories.isNotEmpty) {
      temp = temp.where((p) => _selectedCategories.contains(p.kategori)).toList();
    }

    setState(() {
      _filteredProducts = temp;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filterProducts();
    });
  }

  Color _getStockColor(int stok) {
    if (stok > 10) return Colors.green;
    if (stok > 0) return Colors.orange;
    return Colors.red;
  }

  String _formatRupiah(num harga) {
    return 'Rp ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.') }';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text(
          "Daftar Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari produk atau kategori...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            // Filter Chips
            if (_allProducts.isNotEmpty)
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _selectedCategories.isEmpty,
                      onSelected: (_) => _toggleCategory(''), // 'all' toggle
                      selectedColor: Colors.blue[100],
                    ),
                    ..._allProducts
                        .map((p) => p.kategori)
                        .where((c) => c.isNotEmpty)
                        .toSet()
                        .map((cat) => ChoiceChip(
                              label: Text(cat),
                              selected: _selectedCategories.contains(cat),
                              onSelected: (_) => _toggleCategory(cat),
                              selectedColor: Colors.indigo[100],
                            )),
                  ],
                ),
              ),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(_error!, style: TextStyle(color: Colors.grey[600])),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadProducts,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : _filteredProducts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isNotEmpty || _selectedCategories.isNotEmpty
                                        ? 'Produk tidak ditemukan'
                                        : 'Belum ada produk',
                                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tambahkan produk melalui panel admin',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final produk = _filteredProducts[index];
                                return Card(
                                  elevation: 4,
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: produk.fotoUrl != null
                                                ? Image.network(
                                                    produk.fotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(Icons.image_not_supported),
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.grey[200],
                                                    child: const Icon(Icons.inventory_2, color: Colors.grey),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                produk.nama,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatRupiah(produk.harga),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.category,
                                                    size: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    produk.kategori,
                                                    style: TextStyle(color: Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStockColor(produk.stok).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.warehouse, size: 14, color: _getStockColor(produk.stok)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Stok: ${produk.stok}',
                                                      style: TextStyle(
                                                        color: _getStockColor(produk.stok),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
}
