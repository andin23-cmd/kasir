import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item_model.dart';
import 'package:flutter_application_1/models/transaksi_models.dart';
import 'package:flutter_application_1/services/transaksi_services.dart';

class PembayaranScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double grandTotal;
  final VoidCallback onSuccess;

  const PembayaranScreen({
    super.key,
    required this.cartItems,
    required this.grandTotal,
    required this.onSuccess,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final TextEditingController _bayarController = TextEditingController();
  String selectedMetode = 'tunai';
  double kembalian = 0.0;
  bool isProcessing = false;

  final List<String> metodePembayaran = ['tunai', 'debit', 'qris', 'transfer'];

  @override
  void dispose() {
    _bayarController.dispose();
    super.dispose();
  }

  void _calculateKembalian() {
    final bayar = double.tryParse(_bayarController.text) ?? 0.0;
    kembalian = bayar - widget.grandTotal;
  }

  Future<void> _prosesPembayaran() async {
    if (selectedMetode == 'tunai' && (double.tryParse(_bayarController.text) ?? 0.0) < widget.grandTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal pembayaran kurang!')),
      );
      return;
    }

    setState(() => isProcessing = true);

    try {
      final transaksiService = TransaksiService();
      final kodeTransaksi = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
      
      // TODO: Save to Supabase
      await Future.delayed(const Duration(seconds: 2)); // Simulate network call

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaksi $kodeTransaksi berhasil!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') }';
  }

  @override
  Widget build(BuildContext context) {
    _calculateKembalian();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Jumlah Item', style: TextStyle(fontSize: 16)),
                          Text('${widget.cartItems.length} item', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            _formatRupiah(widget.grandTotal),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Metode Pembayaran
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...metodePembayaran.map((metode) => RadioListTile<String>(
                        title: Text(metode.toUpperCase()),
                        value: metode,
                        groupValue: selectedMetode,
                        onChanged: (value) {
                          setState(() {
                            selectedMetode = value!;
                          });
                          _bayarController.clear();
                        },
                      )).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input Bayar
              if (selectedMetode == 'tunai') ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _bayarController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nominal Bayar',
                            prefixIcon: const Icon(Icons.money),
                            prefixText: 'Rp ',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Kembali: ${_formatRupiah(kembalian.clamp(0.0, double.infinity))}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kembalian > 0 ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),

              // Bayar Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 8,
                  ),
                  onPressed: isProcessing ? null : _prosesPembayaran,
                  child: isProcessing
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Proses Pembayaran (${_formatRupiah(widget.grandTotal)})',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

