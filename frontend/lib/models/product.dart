class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? categoryName;
  final String? manufacturerName;
  final int stockQuantity;
  final bool isPrescription;
  final bool isSocialProgram;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.categoryName,
    this.manufacturerName,
    required this.stockQuantity,
    required this.isPrescription,
    required this.isSocialProgram,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "",
      price: json['price'].toString(),
      categoryName: json['category_name'],
      manufacturerName: json['manufacturer_name'],
      stockQuantity: json['stock_quantity'] ?? 0,
      isPrescription: json['is_prescription'] ?? false,
      isSocialProgram: json['is_social_program'] ?? false,
    );
  }
}