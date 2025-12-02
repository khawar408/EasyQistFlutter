import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../api/ApiEndpoints.dart';
import '../../../models/user.dart';
import '../../../storage/data_storage_repository.dart';
import '../../../util/Singleton.dart';

class AuthController extends GetxController {

  final storage = DataStorageRepository();
  // Loading State
  var isLoading = false.obs;
  // Signup fields
  var fullName = ''.obs;
  var cnic = ''.obs;
  var mobileNumber = ''.obs;

  // OTP
  var otpCode = ''.obs;
  var resendTimer = 20.obs;
  var reg=0;
  Timer? _timer;

  // Terms & Conditions
  var termsAccepted = false.obs; // ✅ Add this

  void startResendTimer() {
    resendTimer.value = 20;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        timer.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  Future<void> resendOTP() async {
    startResendTimer();
    if(reg==0) {
      String apiNumber = mobileNumber.value.replaceFirst("0", "+92");

      final response = await loginWithPhone(apiNumber);
    }else{
      String apiNumber = mobileNumber.value.replaceFirst("0", "+92");

      final response = await signUpApi(
        name: fullName.value,
        phoneNo: apiNumber,
        cnicNumber: cnic.value,
      );
    }
    Get.snackbar("OTP", "New OTP sent successfully");
  }

  bool _isValidPakistaniNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\s+'), '');
    final regex = RegExp(r'^(03)[0-9]{9}$'); // 03XXXXXXXXX (11 digits)
    return regex.hasMatch(cleaned);
  }

  bool _isValidCNIC(String cnicNumber) {
    // CNIC must be exactly 13 digits, no dashes
    final regex = RegExp(r'^[0-9]{13}$');
    return regex.hasMatch(cnicNumber);
  }

  Future<void> login() async {
    if (mobileNumber.value.isEmpty) {
      Get.snackbar("Error", "Please enter your mobile number");
      return ;
    } else if (!_isValidPakistaniNumber(mobileNumber.value)) {
      Get.snackbar("Error", "Please enter a valid Pakistani number (e.g. 03001234567)");
      return ;
    } else {
      isLoading.value = true;
      String apiNumber = mobileNumber.value.replaceFirst("0", "+92");

      final response = await loginWithPhone(apiNumber);

      isLoading.value = false;

      if (response != null && response.status == true) {
        Get.snackbar("Success", "OTP sent successfully");
        reg=0;
        Get.offNamed('/otp');
      } else {
        Get.snackbar("Error", response?.message ?? "Login failed");
      }
    }
  }

  Future<void> signUp() async {
    if (fullName.value.isEmpty || cnic.value.isEmpty || mobileNumber.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
    }
    else if (!_isValidCNIC(cnic.value)) {
      Get.snackbar("Error", "Please enter a valid 13-digit CNIC number");
    }
    else if (!_isValidPakistaniNumber(mobileNumber.value)) {
      Get.snackbar("Error", "Please enter a valid Pakistani number (e.g. 03001234567)");
    }
    else if (!termsAccepted.value) {
      Get.snackbar("Error", "Please accept Terms & Conditions");
    }
    else {
      isLoading.value = true;

      String apiNumber = mobileNumber.value.replaceFirst("0", "+92");

      final response = await signUpApi(
        name: fullName.value,
        phoneNo: apiNumber,
        cnicNumber: cnic.value,
      );

      isLoading.value = false;

      if (response != null && response.status == true) {
        // backend also sends OTP here
        reg = 1;   // <-- Important for verify API (register = 1)
        Get.snackbar("Success", "OTP sent successfully");
        Get.offNamed('/otp');
      } else {
        Get.snackbar("Error", response?.message ?? "Signup failed");
      }
    }
  }



  Future<void> verifyOTP() async {
    if (otpCode.value.length == 4) {
      isLoading.value = true;
      String apiNumber = mobileNumber.value.replaceFirst("0", "+92");
      final response = await sendOtpApi(phoneNo:apiNumber,smsCode:otpCode.value,register: reg);

      isLoading.value = false;

      if (response != null && response.status == true) {
        Get.snackbar("Success", "OTP sent successfully");
        await storage.saveUser(response.data!);
        await storage.saveIsLogin(true);
        print("check login ${response.data.toString()}");

        Singleton.user.value=response.data;
        Singleton.setLogin(true);
        if (Get.context != null) {
          Navigator.of(Get.context!, rootNavigator: true).pop();
        } else {
          Get.back();
        }

        print("check login ${response.data.toString()}");
      } else {
        Get.snackbar("Error", response?.message ?? "Login failed");
      }
    } else {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<ApiUserResponse?> loginWithPhone(String phoneNo) async {
    try {
      final url = Uri.parse("${ApiEndpoints.getLoginOpt}");

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "phone_no": phoneNo,
        },
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        return ApiUserResponse.fromRawJson(response.body);
      } else {
        print("Failed: ${response.body}");
      }
    } catch (e) {
      print("Login Error: $e");
    }

    return null;
  }


  Future<ApiUserResponse?> sendOtpApi({
    required String phoneNo,
    required String smsCode,
    required int register,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.sendOtp); // <-- your api/sendopt endpoint

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "sms_code": smsCode,
          "phone_no": phoneNo,
          "register": "$register",
        },
      );

      print("OTP API Response: ${response.body}");

      if (response.statusCode == 200) {
        return ApiUserResponse.fromRawJson(response.body);
      }
    } catch (e) {
      print("OTP API Error: $e");
    }
    return null;
  }

  Future<ApiUserResponse?> signUpApi({
    required String name,
    required String phoneNo,
    required String cnicNumber,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.registor); // api/registeropt

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": name,
          "phone_no": phoneNo,
          "cnic_number": cnicNumber,
        },
      );

      print("SIGNUP API Response: ${response.body}");

      if (response.statusCode == 200) {
        return ApiUserResponse.fromRawJson(response.body);
      }
    } catch (e) {
      print("SIGNUP API Error: $e");
    }
    return null;
  }


}
