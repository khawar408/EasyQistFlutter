class BrandResponse {
  final int? id;
  final int? categoryId;
  final String? brandName;
  final String? brandImage;
  bool click;

  BrandResponse({
    this.id,
    this.categoryId,
    this.brandName,
    this.brandImage,
    this.click = false,
  });

  factory BrandResponse.fromJson(Map<String, dynamic> json) {
    return BrandResponse(
      id: json['id'],
      categoryId: json['category_id'],
      brandName: json['brand_name'],
      brandImage: json['brand_image'],
    );
  }
}

class ApiBrandResponse {
  final String? message;
  final bool? status;
  final List<BrandResponse>? data;

  ApiBrandResponse({this.message, this.status, this.data});

  factory ApiBrandResponse.fromJson(Map<String, dynamic> json) {
    return ApiBrandResponse(
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List?)
          ?.map((e) => BrandResponse.fromJson(e))
          .toList(),
    );
  }
}
