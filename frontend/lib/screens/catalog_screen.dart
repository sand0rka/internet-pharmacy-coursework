import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class CatalogTab extends StatefulWidget {
  const CatalogTab({super.key});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  final ApiService apiService = ApiService();

  String _searchQuery = "";
  bool _onlyNonPrescription = false; // Змінили логіку тут
  bool _onlyInStock = false;
  double? _minPrice;
  double? _maxPrice;

  Timer? _debounce;

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  void _applyPriceFilter() {
    setState(() {
      _minPrice = double.tryParse(_minPriceController.text);
      _maxPrice = double.tryParse(_maxPriceController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: "Пошук ліків...",
                      prefixIcon: Icon(Icons.search, color: kPrimaryColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterChip(
                      label: const Text("Без рецепта"),
                      selected: _onlyNonPrescription,
                      onSelected: (val) =>
                          setState(() => _onlyNonPrescription = val),
                      selectedColor: kSecondaryColor,
                      checkmarkColor: kPrimaryColor,
                      labelStyle: TextStyle(
                        color: _onlyNonPrescription
                            ? kPrimaryColor
                            : kTextColor,
                        fontSize: 12,
                        fontWeight: _onlyNonPrescription
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    const SizedBox(width: 5),
                    Container(width: 1, height: 20, color: Colors.grey[300]),
                    const SizedBox(width: 5),
                    FilterChip(
                      label: const Text("В наявності"),
                      selected: _onlyInStock,
                      onSelected: (val) => setState(() => _onlyInStock = val),
                      selectedColor: Colors.green[50],
                      checkmarkColor: Colors.green,
                      labelStyle: TextStyle(
                        color: _onlyInStock ? Colors.green : kTextColor,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 15),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    const Text("Ціна:", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _applyPriceFilter(),
                        decoration: const InputDecoration(
                          hintText: "0",
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          fillColor: kSecondaryColor,
                          filled: false,
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const Text("-", style: TextStyle(color: kTextLightColor)),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _applyPriceFilter(),
                        decoration: const InputDecoration(
                          hintText: "Max",
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.check_circle, color: kPrimaryColor, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _applyPriceFilter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Product>>(
            future: apiService.getProducts(
              searchQuery: _searchQuery,
              isPrescription: _onlyNonPrescription ? false : null,
              inStock: _onlyInStock ? true : null,
              minPrice: _minPrice,
              maxPrice: _maxPrice,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor));
              } else if (snapshot.hasError) {
                return Center(child: Text("Помилка: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: kTextLightColor),
                      SizedBox(height: 10),
                      Text("Товарів не знайдено",
                          style: TextStyle(color: kTextLightColor)),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                    kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: snapshot.data![index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}