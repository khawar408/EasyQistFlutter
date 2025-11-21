class CategoryResponse {
  final String? message;
  final bool? status;
  final List<CategoryModel>? data;

  CategoryResponse({this.message, this.status, this.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        message: json['message'],
        status: json['status'],
        data: (json['data'] as List?)
            ?.map((e) => CategoryModel.fromJson(e))
            .toList(),
      );
}

class CategoryModel {
  final int? id;
  final String? name;
  final String? categoryImage;
  final List<BrandModel>? brands;
  final bool? click;

  CategoryModel({
    this.id,
    this.name,
    this.categoryImage,
    this.brands,
    this.click,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    name: json['name'],
    categoryImage: json['category_image'],
    brands: (json['brands'] as List?)
        ?.map((e) => BrandModel.fromJson(e))
        .toList(),
    click: json['click'] ?? false,
  );
}

class BrandModel {
  final int? id;
  final String? name;
  final String? image;

  BrandModel({this.id, this.name, this.image});

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    id: json['id'],
    name: json['name'],
    image: json['image'],
  );
}
