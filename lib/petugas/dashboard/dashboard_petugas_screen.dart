import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👋 Header
            const Text(
              "Halo, Andin 👋",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Berikut ringkasan hari ini",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 💰 Ringkasan Penjualan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Penjualan Hari Ini",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Rp 1.500.000",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "15 Transaksi",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⚡ Tombol Cepat Transaksi
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/transaksi');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shopping_cart, color: Colors.blue, size: 30),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Mulai Transaksi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ⚠️ Notifikasi Stok Menipis
            const Text(
              "Stok Menipis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _stokItem("Indomie Goreng", 3),
            _stokItem("Teh Botol", 5),
            _stokItem("Gula 1kg", 2),
          ],
        ),
      ),
    );
  }

  // 🔻 Widget Stok Menipis
  Widget _stokItem(String nama, int stok) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.orange),
        title: Text(nama),
        subtitle: Text("Sisa stok: $stok"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}