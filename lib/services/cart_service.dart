
import 'package:flutter/foundation.dart';
import '../models/flower_product.dart';

class CartItem {
  final FlowerProduct product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final Map<int, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);

  int get itemCount =>
      _items.values.fold(0, (total, item) => total + item.quantity);

  int get totalPrice => _items.values.fold(
        0,
        (total, item) => total + item.product.price * item.quantity,
      );

  bool get isEmpty => _items.isEmpty;

  void addProduct(FlowerProduct product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }

    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;

    item.quantity++;
    notifyListeners();
  }

  void removeProduct(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int quantityOf(int productId) => _items[productId]?.quantity ?? 0;
}
