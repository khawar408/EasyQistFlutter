import 'dart:convert';

import 'ItemModel.dart';

class ApiResponseViewCart {
  final String? message;
  final bool? status;
  final ViewCartOrder? data;

  ApiResponseViewCart({
    this.message,
    this.status,
    this.data,
  });

  factory ApiResponseViewCart.fromJson(Map<String, dynamic> json) {
    return ApiResponseViewCart(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null ? ViewCartOrder.fromJson(json['data']) : null,
    );
  }
}

class ViewCartOrder {
  final int? id;
  final String? orderSessionId;
  final String? orderPrice;
  final String? orderAdvanceAmount;
  final String? orderRemainingAmount;
  final String? orderStatus;
  final String? orderDate;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;
  final String? paymentMethod;
  final List<OrderProduct>? orderProducts;
  final Address? address;

  ViewCartOrder({
    this.id,
    this.orderSessionId,
    this.orderPrice,
    this.orderAdvanceAmount,
    this.orderRemainingAmount,
    this.orderStatus,
    this.orderDate,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.paymentMethod,
    this.orderProducts,
    this.address,
  });

  factory ViewCartOrder.fromJson(Map<String, dynamic> json) {
    return ViewCartOrder(
      id: json['id'],
      orderSessionId: json['order_session_id'],
      orderPrice: json['order_price'],
      orderAdvanceAmount: json['order_advance_amount'],
      orderRemainingAmount: json['order_remaining_amount'],
      orderStatus: json['order_status'],
      orderDate: json['order_date'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      paymentMethod: json['payment_method'],
      orderProducts: json['order_products'] != null
          ? (json['order_products'] as List)
          .map((e) => OrderProduct.fromJson(e))
          .toList()
          : [],
      address:
      json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }
}

class OrderProduct {
  final int? id;
  final String? orderId;
  final int? productId;
  final String? orderProductAmount;
  final String? orderProductAdvanceAmount;
  final int? qty;
  final String? orderProductStatus;
  final int? orderProductInstallmentId;
  final String? orderProductInstallment;
  final int? orderProductTypeId;
  final int? categoryId;
  final int? brandId;
  final ItemModel product;
  final int? userId;
  final String? advance;
  final InstallmentPlan orderInstallment;
  final String? orderProductDuration;

  OrderProduct({
    this.id,
    this.orderId,
    this.productId,
    this.orderProductAmount,
    this.orderProductAdvanceAmount,
    this.qty,
    this.orderProductStatus,
    this.orderProductInstallmentId,
    this.orderProductInstallment,
    this.orderProductTypeId,
    this.categoryId,
    this.brandId,
    required this.product,
    this.userId,
    this.advance,
    required this.orderInstallment,
    this.orderProductDuration,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      orderProductAmount: json['order_product_amount'],
      orderProductAdvanceAmount: json['order_product_advance_amount'],
      qty: json['qty'],
      orderProductStatus: json['order_product_status'],
      orderProductInstallmentId: json['order_product_installment_id'],
      orderProductInstallment: json['order_product_installment'],
      orderProductTypeId: json['order_product_type_id'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      product: ItemModel.fromJson(json['product']),
      userId: json['user_id'],
      advance: json['advance'],
      orderInstallment: json['orderinstallment'] != null
          ? InstallmentPlan.fromJson(json['orderinstallment'])
          : InstallmentPlan.empty(),
      orderProductDuration: json['order_product_duration'],
    );
  }
}

class ApiResponseOrderList {
  final String? message;
  final bool? status;
  final List<ViewCartOrder>? data;

  ApiResponseOrderList({
    this.message,
    this.status,
    this.data,
  });

  factory ApiResponseOrderList.fromJson(Map<String, dynamic> json) {
    return ApiResponseOrderList(
      message: json['message'],
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => ViewCartOrder.fromJson(e))
          .toList()
          : [],
    );
  }
}

class Address {
  final int? id;
  final String? address;

  Address({this.id, this.address});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'],
    );
  }
}
