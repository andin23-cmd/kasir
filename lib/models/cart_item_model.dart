import 'package:flutter_application_1/models/produk_models.dart';

class CartItem {
  final ProdukModel product;
  int quantity;
  double total;

  CartItem({
    required this.product,
    this.quantity = 1,
  }) : total = 1.0 * (product.harga.toDouble());

  CartItem copyWith({
    ProdukModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    )..updateTotal();
  }

  void updateQuantity(int newQty) {
    quantity = newQty;
    updateTotal();
  }

  void updateTotal() {
    total = quantity * product.harga.toDouble();
  }

  Map<String, dynamic> toDetailMap(String transaksiId) {
    return {
      'transaksi_id': transaksiId,
      'produk_id': product.id,
      'quantity': quantity,
      'harga': product.harga,
      'subtotal': total,
    };
  }
}

