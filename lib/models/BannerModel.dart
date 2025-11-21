class BannerResponse {
  final String? message;
  final bool? status;
  final List<BannerModel>? data;

  BannerResponse({this.message, this.status, this.data});

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
    message: json['message'],
    status: json['status'],
    data: (json['data'] as List?)
        ?.map((e) => BannerModel.fromJson(e))
        .toList(),
  );
}

class BannerModel {
  final int? id;
  final String? bannerImage;
  final String? bannerLink;
  final String? bannerStatus;
  final String? mobileBanner;

  BannerModel({
    this.id,
    this.bannerImage,
    this.bannerLink,
    this.bannerStatus,
    this.mobileBanner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'],
    bannerImage: json['banner_image'],
    bannerLink: json['banner_link'],
    bannerStatus: json['banner_status'],
    mobileBanner: json['mobile_banner'],
  );
}
