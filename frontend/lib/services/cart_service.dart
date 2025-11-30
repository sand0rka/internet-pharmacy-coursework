import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() => _instance;

  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        return;
      }
    }
    _items.add(CartItem(product: product));
  }

  void removeOne(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          _items.remove(item);
        }
        return;
      }
    }
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void clear() {
    _items.clear();
  }

  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += double.parse(item.product.price) * item.quantity;
    }
    return total;
  }
}