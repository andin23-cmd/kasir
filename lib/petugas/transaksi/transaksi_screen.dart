import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item_model.dart';
import 'package:flutter_application_1/models/produk_models.dart';
import 'package:flutter_application_1/petugas/transaksi/keranjang_widget.dart';
import 'package:flutter_application_1/petugas/transaksi/pembayaran_screen.dart';
import 'package:flutter_application_1/services/produk_services.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<CartItem> _cart = [];
  final ProdukService _produkService = ProdukService();
  List<ProdukModel> _allProducts = [];
  List<ProdukModel> _filteredProducts = [];
  double _grandTotal = 0.0;

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
    try {
      final products = await _produkService.fetchProduk();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) =>
        product.nama.toLowerCase().contains(query) ||
        product.kategori.toLowerCase().contains(query)
      ).toList();
    });
  }

  void _addToCart(ProdukModel product) {
    final existingIndex = _cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      _cart[existingIndex].updateQuantity(_cart[existingIndex].quantity + 1);
    } else {
      _cart.add(CartItem(product: product));
    }
    _calculateGrandTotal();
  }

  void _removeFromCart(CartItem item) {
    _cart.remove(item);
    _calculateGrandTotal();
  }

  void _updateCartItem(CartItem updatedItem) {
    final index = _cart.indexOf(updatedItem);
    if (index != -1) {
      _cart[index] = updatedItem;
      _calculateGrandTotal();
    }
  }

  void _calculateGrandTotal() {
    _grandTotal = _cart.fold(0.0, (sum, item) => sum + item.total);
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      _grandTotal = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Transaksi Penjualan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Product List
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Produk Tersedia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              product.kategori[0].toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(product.nama, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rp ${(product.harga as double).toStringAsFixed(0)}'),
                              Text('Stok: ${product.stok}', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _addToCart(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Tambah'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Cart & Summary
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Keranjang', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Total: Rp ${_grandTotal.toStringAsFixed(0)}', 
                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _cart.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Keranjang kosong', style: TextStyle(fontSize: 16, color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              return KeranjangWidget(
                                cartItem: item,
                                onUpdate: (updatedItem) => _updateCartItem(updatedItem),
                                onRemove: () => _removeFromCart(item),
                              );
                            },
                          ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Bersihkan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _cart.isEmpty ? null : _clearCart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          onPressed: _grandTotal > 0 ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PembayaranScreen(
                                  cartItems: _cart,
                                  grandTotal: _grandTotal,
                                  onSuccess: _clearCart,
                                ),
                              ),
                            );
                          } : null,
                          child: Text(
                            'Pembayaran (${_grandTotal.toStringAsFixed(0)})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

