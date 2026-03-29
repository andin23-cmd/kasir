import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/petugas/petugas_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifAktif = true;
  final bool _darkMode = false;
  bool _autoBackup = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE9EDF5),
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: const Color(0xff2D4A8A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.store,
                    size: 50,
                    color: Color(0xff2D4A8A),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text("Ubah Logo"),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Informasi Toko",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.store,
            title: "Nama Toko",
            subtitle: "Mimpi Indah",
          ),
          _settingsTile(
            icon: Icons.location_on,
            title: "Alamat",
            subtitle: "Malang, Jawa Timur",
          ),
          _settingsTile(
            icon: Icons.phone,
            title: "Nomor Telepon",
            subtitle: "08123456789",
          ),
          const SizedBox(height: 20),
          const Text(
            "Akun",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.lock,
            title: "Ubah Password",
            subtitle: "Ganti password akun",
          ),
          _settingsTile(
            icon: Icons.dark_mode,
            title: "Mode Gelap",
            subtitle: _darkMode ? "Aktif" : "Nonaktif",
          ),
          const SizedBox(height: 20),
          const Text(
            "Tambahan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          _settingsTile(
            icon: Icons.manage_accounts_rounded,
            title: "CRUD Petugas",
            subtitle: "Tambah, edit, dan hapus petugas",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PetugasListPage(),
                ),
              );
            },
          ),
          _switchTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifikasi',
            subtitle: 'Aktifkan notifikasi transaksi',
            value: _notifAktif,
            onChanged: (value) => setState(() => _notifAktif = value),
          ),
          _switchTile(
            icon: Icons.backup_outlined,
            title: 'Auto Backup',
            subtitle: 'Simpan data otomatis ke cloud',
            value: _autoBackup,
            onChanged: (value) => setState(() => _autoBackup = value),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xff2D4A8A),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xff2D4A8A),
        secondary: Icon(icon, color: const Color(0xff2D4A8A)),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
