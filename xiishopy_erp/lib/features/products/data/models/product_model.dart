/// Xiishopy ERP - Product Data Model
/// Matches Firestore products collection in seed-data.json
library;

import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_utils.dart';

class ProductModel extends Equatable {
  final String id;
  final String sku;
  final String name;
  final String category;
  final int stockLevel;
  final double wholesalePriceUSD;
  final String unit;
  final double? retailPriceLocal;
  final String? imageUrl;
  final int reorderLevel;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.stockLevel,
    required this.wholesalePriceUSD,
    required this.unit,
    this.retailPriceLocal,
    this.imageUrl,
    this.reorderLevel = 20,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return ProductModel(
      id: docId,
      sku: data['SKU'] as String? ?? data['sku'] as String? ?? '',
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      stockLevel: (data['stockLevel'] as num?)?.toInt() ?? 0,
      wholesalePriceUSD: (data['wholesalePriceUSD'] as num?)?.toDouble() ?? 0.0,
      unit: data['unit'] as String? ?? 'piece',
      retailPriceLocal: (data['retailPriceLocal'] as num?)?.toDouble(),
      imageUrl: data['imageUrl'] as String?,
      reorderLevel: (data['reorderLevel'] as num?)?.toInt() ?? 20,
      createdAt: safeToDate(data['createdAt']),
      updatedAt: safeToDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'SKU': sku,
    'name': name,
    'category': category,
    'stockLevel': stockLevel,
    'wholesalePriceUSD': wholesalePriceUSD,
    'unit': unit,
    'retailPriceLocal': retailPriceLocal,
    'imageUrl': imageUrl,
    'reorderLevel': reorderLevel,
    'updatedAt': DateTime.now(),
  };

  ProductModel copyWith({
    String? name,
    String? category,
    int? stockLevel,
    double? wholesalePriceUSD,
    double? retailPriceLocal,
    String? imageUrl,
    int? reorderLevel,
  }) => ProductModel(
    id: id,
    sku: sku,
    name: name ?? this.name,
    category: category ?? this.category,
    stockLevel: stockLevel ?? this.stockLevel,
    wholesalePriceUSD: wholesalePriceUSD ?? this.wholesalePriceUSD,
    unit: unit,
    retailPriceLocal: retailPriceLocal ?? this.retailPriceLocal,
    imageUrl: imageUrl ?? this.imageUrl,
    reorderLevel: reorderLevel ?? this.reorderLevel,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  bool get isLowStock => stockLevel <= reorderLevel;

  @override
  List<Object?> get props => [id, sku, name, category, stockLevel, wholesalePriceUSD, unit];
}