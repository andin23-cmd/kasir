import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 🔥 Dummy data (nanti ganti dari database)
    final List<Map<String, dynamic>> transaksi = [
      {
        "id": "TRX001",
        "tanggal": "29 Maret 2026",
        "total": 150000,
        "items": [
          {"nama": "Indomie", "qty": 2, "harga": 3000},
          {"nama": "Teh Botol", "qty": 1, "harga": 5000},
        ]
      },
      {
        "id": "TRX002",
        "tanggal": "29 Maret 2026",
        "total": 200000,
        "items": [
          {"nama": "Gula", "qty": 2, "harga": 15000},
        ]
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        backgroundColor: Colors.indigo,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transaksi.length,
        itemBuilder: (context, index) {
          final trx = transaksi[index];

          return GestureDetector(
            onTap: () {
              _showDetail(context, trx);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [

                  // 🧾 Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long,
                        color: Colors.indigo),
                  ),

                  const SizedBox(width: 15),

                  // 📄 Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trx["id"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          trx["tanggal"],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // 💰 Total
                  Text(
                    "Rp ${trx["total"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔍 DETAIL TRANSAKSI (BOTTOM SHEET MODERN)
  void _showDetail(BuildContext context, Map<String, dynamic> trx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // 🔹 Header
              Text(
                "Detail ${trx["id"]}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text("Tanggal: ${trx["tanggal"]}"),

              const Divider(),

              // 📦 List item
              ...trx["items"].map<Widget>((item) {
                return ListTile(
                  title: Text(item["nama"]),
                  subtitle: Text("Qty: ${item["qty"]}"),
                  trailing:
                      Text("Rp ${item["harga"] * item["qty"]}"),
                );
              }).toList(),

              const Divider(),

              // 💰 Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "Rp ${trx["total"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}