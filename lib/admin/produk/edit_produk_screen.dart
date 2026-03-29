import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/produk_models.dart';
import 'package:flutter_application_1/services/produk_services.dart';
import 'package:image_picker/image_picker.dart';

class EditProdukPage extends StatefulWidget {
  const EditProdukPage({super.key, required this.produk});

  final ProdukModel produk;

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final _picker = ImagePicker();
  final _produkService = ProdukService();

  late final TextEditingController _namaController;
  late final TextEditingController _hargaController;
  late final TextEditingController _stokController;
  late final TextEditingController _kategoriController;

  Uint8List? _pickedImageBytes;
  XFile? _pickedImageFile;
  String? _networkImageUrl;
  double _imageWidth = 220;
  double _imageHeight = 140;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.produk.nama);
    _hargaController = TextEditingController(
      text: widget.produk.harga.round().toString(),
    );
    _stokController = TextEditingController(
      text: widget.produk.stok.toString(),
    );
    _kategoriController = TextEditingController(text: widget.produk.kategori);
    _networkImageUrl = widget.produk.fotoUrl;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF2F8),
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _imageEditor(),
                      const SizedBox(height: 18),
                      _label('Nama Produk'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _namaController,
                        hint: 'Masukkan nama produk',
                      ),
                      const SizedBox(height: 14),
                      _label('Harga'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _hargaController,
                        hint: 'Masukkan harga',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _label('Stok'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _stokController,
                        hint: 'Masukkan stok',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _label('Kategori'),
                      const SizedBox(height: 6),
                      _textInput(
                        controller: _kategoriController,
                        hint: 'Masukkan kategori',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2F4C8C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF2F4C8C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Edit Produk',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _imageEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: _imageWidth,
            height: _imageHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD5DEEF)),
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildImagePreview(),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined, size: 18),
              label: const Text('Penyimpanan/Galeri'),
            ),
            OutlinedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Kamera'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Ukuran Gambar',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(
              width: 52,
              child: Text('Lebar', style: TextStyle(fontSize: 12)),
            ),
            Expanded(
              child: Slider(
                value: _imageWidth,
                min: 140,
                max: 300,
                onChanged: (value) => setState(() => _imageWidth = value),
              ),
            ),
            SizedBox(
              width: 42,
              child: Text(
                _imageWidth.round().toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 52,
              child: Text('Tinggi', style: TextStyle(fontSize: 12)),
            ),
            Expanded(
              child: Slider(
                value: _imageHeight,
                min: 100,
                max: 220,
                onChanged: (value) => setState(() => _imageHeight = value),
              ),
            ),
            SizedBox(
              width: 42,
              child: Text(
                _imageHeight.round().toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_pickedImageBytes != null) {
      return Image.memory(_pickedImageBytes!, fit: BoxFit.cover);
    }

    if (_networkImageUrl == null || _networkImageUrl!.isEmpty) {
      return const Center(
        child: Icon(Icons.image_rounded, color: Color(0xFF7A869C), size: 28),
      );
    }

    return Image.network(
      _networkImageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return const Center(
          child: Icon(Icons.broken_image_rounded, color: Color(0xFF7A869C)),
        );
      },
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF394256),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4F6FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5DEEF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD5DEEF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2F4C8C)),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 90);

      if (picked == null) return;
      final bytes = await picked.readAsBytes();

      if (!mounted) return;
      setState(() {
        _pickedImageFile = picked;
        _pickedImageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('Image picker error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  void _save() {
    final nama = _namaController.text.trim();
    final kategori = _kategoriController.text.trim();
    final harga = _parseNumberInput(_hargaController.text);
    final stok = _parseStokInput(_stokController.text);

    if (nama.isEmpty || kategori.isEmpty || harga == null || stok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi data produk dengan benar')),
      );
      return;
    }

    _submitUpdate(nama: nama, kategori: kategori, harga: harga, stok: stok);
  }

  num? _parseNumberInput(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9,\.]'), '').trim();
    if (cleaned.isEmpty) return null;
    final normalized = cleaned.replaceAll(',', '.');
    return num.tryParse(normalized);
  }

  int? _parseStokInput(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9\-]'), '').trim();
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  Future<void> _submitUpdate({
    required String nama,
    required String kategori,
    required num harga,
    required int stok,
  }) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _produkService.updateProduk(
        id: widget.produk.id,
        nama: nama,
        harga: harga,
        stok: stok,
        kategori: kategori,
        imageBytes: _pickedImageBytes,
        imageFileName: _pickedImageFile?.name,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan produk disimpan')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
