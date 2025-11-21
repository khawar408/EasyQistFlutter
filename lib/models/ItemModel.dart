// product_response.dart
class ProductResponse {
  final String? message;
  final bool? status;
  final List<ItemModel>? data;

  ProductResponse({this.message, this.status, this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<ItemModel> parsedData = [];

    // Handle list or single map
    if (data is List) {
      parsedData = data
          .where((e) => e != null) // Skip null entries
          .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      parsedData = [ItemModel.fromJson(data)];
    }

    return ProductResponse(
      message: json['message'],
      status: json['status'],
      data: parsedData,
    );
  }
}

// ----------------------------------------------------------------

class ItemModel {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? price;
  final int? discount;
  final String? discountType;
  final String? status;
  final String? description;
  final String? installment;
  final int? brandId;
  final String? special;
  final int? trending;
  final String? categoryName;
  final List<ProductImage>? productImage;
  final String? thumbnail;
  final String? advance;
  final List<ProductType>? productType;
  final int count;
  final int productTypeSelectIndex;
  final int installIndex;
  final String? detailDescription;

  ItemModel({
    this.id,
    this.name,
    this.categoryId,
    this.price,
    this.discount,
    this.discountType,
    this.status,
    this.description,
    this.installment,
    this.brandId,
    this.special,
    this.trending,
    this.categoryName,
    this.productImage,
    this.thumbnail,
    this.advance,
    this.productType,
    this.count = 0,
    this.productTypeSelectIndex = -1,
    this.installIndex = -1,
    this.detailDescription,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'],
    name: json['name'],
    categoryId: json['category_id'],
    price: json['price']?.toString(),
    discount: json['discount'],
    discountType: json['discount_type'],
    status: json['status'],
    description: json['description'],
    installment: json['installment'],
    brandId: json['brand_id'],
    special: json['special'],
    trending: json['trending'],
    categoryName: json['category_name'],
    productImage: (json['product_image'] is List)
        ? (json['product_image'] as List)
        .where((e) => e != null)
        .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
    thumbnail: json['thumbnail'],
    advance: json['advance'],
    productType: (json['product_type'] is List)
        ? (json['product_type'] as List)
        .where((e) => e != null)
        .map((e) => ProductType.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
    detailDescription: json['detail_description'],
  );
}

// ----------------------------------------------------------------

class ProductImage {
  final int? id;
  final int? productId;
  final String? imageName;

  ProductImage({this.id, this.productId, this.imageName});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json['id'],
    productId: json['product_id'],
    imageName: json['image_name'],
  );
}

// ----------------------------------------------------------------

class ProductType {
  final int? id;
  final int? productId;
  final String? title;
  final bool click;
  final List<InstallmentPlan>? productInstallment;

  ProductType({
    this.id,
    this.productId,
    this.title,
    this.click = false,
    this.productInstallment,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json['id'],
    productId: json['product_id'],
    title: json['title'],
    click: json['click'] ?? false,
    productInstallment: (json['product_installment'] is List)
        ? (json['product_installment'] as List)
        .where((e) => e != null)
        .map(
            (e) => InstallmentPlan.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
  );
}

// ----------------------------------------------------------------

class InstallmentPlan {
  final int? id;
  final int? productId;
  final String? planName;
  final String? details;

  InstallmentPlan({this.id, this.productId, this.planName, this.details});

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) =>
      InstallmentPlan(
        id: json['id'],
        productId: json['product_id'],
        planName: json['plan_name'],
        details: json['details'],
      );
}
