import 'dart:convert';

class Vendor {
  final String? address;
  final String? address2;
  final String? createdAt;
  final int? id;
  final String? lastLogin;
  final String? name;
  final String? password;
  final String? phoneNo;
  final String? updatedAt;
  final dynamic vendorPersonName; // `Any` in Kotlin => `dynamic` in Dart

  Vendor({
    this.address,
    this.address2,
    this.createdAt,
    this.id,
    this.lastLogin,
    this.name,
    this.password,
    this.phoneNo,
    this.updatedAt,
    this.vendorPersonName,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      address: json['address'],
      address2: json['address2'],
      createdAt: json['created_at'],
      id: json['id'],
      lastLogin: json['last_login'],
      name: json['name'],
      password: json['password'],
      phoneNo: json['phone_no'],
      updatedAt: json['updated_at'],
      vendorPersonName: json['vendor_person_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'address2': address2,
      'created_at': createdAt,
      'id': id,
      'last_login': lastLogin,
      'name': name,
      'password': password,
      'phone_no': phoneNo,
      'updated_at': updatedAt,
      'vendor_person_name': vendorPersonName,
    };
  }

  /// Parse from JSON string
  static Vendor fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  /// Convert to JSON string
  String toRawJson() => json.encode(toJson());
}
