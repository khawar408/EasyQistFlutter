import 'dart:convert';
import 'dart:ffi';

class ApiUserResponse {
  final String? message;
  final bool? status;
  final User? data;
  final String? token;
  final int? code;

  ApiUserResponse({
    this.message,
    this.status,
    this.data,
    this.token,
    this.code,
  });

  factory ApiUserResponse.fromJson(Map<String, dynamic> json) {
    return ApiUserResponse(
      message: json['message'],
      status: json['status'],
      data: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'user': data?.toJson(),
      'token': token,
      'code': code,
    };
  }

  /// Helper to parse from raw JSON string
  static ApiUserResponse fromRawJson(String str) =>
      ApiUserResponse.fromJson(json.decode(str));

  /// Convert to raw JSON string
  String toRawJson() => json.encode(toJson());
}

class User {
  int? id;
  String? name;
  String? phoneNo;
  String? address;
  String? cnicNumber;

  User({
    this.id,
    this.name,
    this.phoneNo,
    this.address,
    this.cnicNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      address: json['address'],
      cnicNumber: json['cnic_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_no': phoneNo,
      'address': address,
      'cnic_number': cnicNumber,
    };
  }

  /// Helper to parse from raw JSON string
  static User fromRawJson(String str) => User.fromJson(json.decode(str));

  /// Convert to raw JSON string
  String toRawJson() => json.encode(toJson());
}
