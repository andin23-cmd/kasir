import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_item_model.dart';

class KeranjangWidget extends StatefulWidget {
  final CartItem cartItem;
  final Function(CartItem) onUpdate;
  final VoidCallback onRemove;

  const KeranjangWidget({
    super.key,
    required this.cartItem,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<KeranjangWidget> createState() => _KeranjangWidgetState();
}

class _KeranjangWidgetState extends State<KeranjangWidget> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.cartItem.quantity;
  }

  void _updateQty(int qty) {
    widget.cartItem.updateQuantity(qty);
    widget.onUpdate(widget.cartItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cartItem.product.nama,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(
                  'Rp ${(widget.cartItem.product.harga.toDouble()).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Control
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _quantity > 1 ? () => _updateQty(_quantity - 1) : null,
                  icon: const Icon(Icons.remove, size: 18),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                ),
                Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _updateQty(_quantity + 1),
                  icon: const Icon(Icons.add, size: 18),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Subtotal
          Text(
            'Rp ${widget.cartItem.total.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Remove Button
          IconButton(
            onPressed: widget.onRemove,
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}

