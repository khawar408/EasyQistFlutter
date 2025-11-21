// product_response.dart
class ProductResponse {
  final String? message;
  final bool? status;
  final List<ItemModel>? data;

  ProductResponse({this.message, this.status, this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<ItemModel> parsedData = [];

    if (data is List) {
      parsedData = data
          .where((e) => e != null)
          .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is Map<String, dynamic>) {
      parsedData = [ItemModel.fromJson(data)];
    }

    return ProductResponse(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      data: parsedData,
    );
  }
}

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
  final List<ProductImage> productImage;
  final String? thumbnail;
  final String? advance;
  final List<ProductType> productType;
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
    required this.productImage,
    this.thumbnail,
    this.advance,
    required this.productType,
    this.count = 0,
    this.productTypeSelectIndex = -1,
    this.installIndex = -1,
    this.detailDescription,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    categoryId: json['category_id'] as int?,
    price: json['price']?.toString(),
    discount: json['discount'] as int?,
    discountType: json['discount_type'] as String?,
    status: json['status'] as String?,
    description: json['description'] as String?,
    installment: json['installment'] as String?,
    brandId: json['brand_id'] as int?,
    special: json['special'] as String?,
    trending: json['trending'] as int?,
    categoryName: json['category_name'] as String?,
    productImage: (json['product_image'] is List)
        ? (json['product_image'] as List)
        .where((e) => e != null)
        .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
    thumbnail: json['thumbnail'] as String?,
    advance: json['advance'] as String?,
    productType: (json['product_type'] is List)
        ? (json['product_type'] as List)
        .where((e) => e != null)
        .map((e) => ProductType.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
    detailDescription: json['detail_description'] as String?,
  );
}

class ProductImage {
  final int? id;
  final int? productId;
  final String? imageName;

  ProductImage({this.id, this.productId, this.imageName});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    imageName: json['image_name'] as String?,
  );
}

class ProductType {
  final int? id;
  final int? productId;
  final String? title;
  final bool click;
  final List<InstallmentPlan> productInstallment;

  ProductType({
    this.id,
    this.productId,
    this.title,
    this.click = false,
    required this.productInstallment,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    title: json['title'] as String?,
    click: json['click'] ?? false,
    productInstallment: (json['product_installment'] is List)
        ? (json['product_installment'] as List)
        .where((e) => e != null)
        .map((e) => InstallmentPlan.fromJson(e as Map<String, dynamic>))
        .toList()
        : [],
  );
}

class InstallmentPlan {
  final int? id;
  final int? productId;
  final int? productTypeId;
  final String? installmentTitle;
  final String? totalAmount;
  final String? advance;
  final String? amount;
  final String? duration;
  final String? durationType;
  final String? status;
  final bool click;
  final int downpaymentPercentage;
  final List<Payment>? payment;

  InstallmentPlan({
    this.id,
    this.productId,
    this.productTypeId,
    this.installmentTitle,
    this.totalAmount,
    this.advance,
    this.amount,
    this.duration,
    this.durationType,
    this.status,
    this.click = false,
    this.downpaymentPercentage = 0,
    this.payment,
  });

  factory InstallmentPlan.fromJson(Map<String, dynamic> json) => InstallmentPlan(
    id: json['id'] as int?,
    productId: json['product_id'] as int?,
    productTypeId: json['product_type_id'] as int?,
    installmentTitle: json['installment_title'] as String?,
    totalAmount: json['total_amount']?.toString(),
    advance: json['advance']?.toString(),
    amount: json['amount']?.toString(),
    duration: json['duration']?.toString(),
    durationType: json['duration_type'] as String?,
    status: json['status'] as String?,
    click: json['click'] ?? false,
    downpaymentPercentage: json['downpayment_percentage'] is int
        ? json['downpayment_percentage'] as int
        : int.tryParse(json['downpayment_percentage']?.toString() ?? '0') ?? 0,
    payment: (json['payment'] is List)
        ? (json['payment'] as List)
        .where((e) => e != null)
        .map((e) => Payment.fromJson(e as Map<String, dynamic>))
        .toList()
        : null,
  );
}

class Payment {
  final int? id;
  final int? userId;
  final int? orderId;
  final int? orderProductId;
  final int? orderProductTypeId;
  final int? orderInstallmentId;
  final String? amount;
  final String? fullAmount;
  final String? paymentDate;

  Payment({
    this.id,
    this.userId,
    this.orderId,
    this.orderProductId,
    this.orderProductTypeId,
    this.orderInstallmentId,
    this.amount,
    this.fullAmount,
    this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    orderId: json['order_id'] as int?,
    orderProductId: json['order_product_id'] as int?,
    orderProductTypeId: json['order_product_type_id'] as int?,
    orderInstallmentId: json['order_installment_id'] as int?,
    amount: json['amount']?.toString(),
    fullAmount: json['fullamount']?.toString(),
    paymentDate: json['payment_date'] as String?,
  );
}
class SingleProductResponse {
  final String? message;
  final bool? status;
  final ItemModel? data;

  SingleProductResponse({
    this.message,
    this.status,
    this.data,
  });

  factory SingleProductResponse.fromJson(Map<String, dynamic> json) {
    return SingleProductResponse(
      message: json['message'] as String?,
      status: json['status'] as bool?,
      data: json['data'] != null
          ? ItemModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
