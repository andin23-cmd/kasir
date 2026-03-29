import 'package:flutter/material.dart';
import 'package:flutter_application_1/petugas/dashboard/dashboard_petugas_screen.dart';
import 'package:flutter_application_1/petugas/transaksi/transaksi_screen.dart';
import 'package:flutter_application_1/petugas/produk/produk_view_screen.dart';
import 'package:flutter_application_1/petugas/riwayat/riwayat_screen.dart';
import 'package:flutter_application_1/petugas/pengaturan/pengaturan_petugas.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const [
      DashboardScreen(),
      TransaksiScreen(),
      ProdukScreen(),
      RiwayatScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex], // ✅ FIX DI SINI

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10)
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex, // ✅ FIX
            selectedItemColor: const Color(0xFF2F4A8A),
            unselectedItemColor: Colors.grey,

            onTap: (index) {
              setState(() {
                selectedIndex = index; // ✅ FIX
              });
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_checkout),
                label: "Transaksi",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2),
                label: "Produk",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: "Riwayat",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}