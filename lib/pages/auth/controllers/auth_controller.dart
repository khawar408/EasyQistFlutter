import 'dart:async';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Signup fields
  var fullName = ''.obs;
  var cnic = ''.obs;
  var mobileNumber = ''.obs;

  // OTP
  var otpCode = ''.obs;
  var resendTimer = 20.obs;
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

  void resendOTP() {
    startResendTimer();
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

  void login() {
    if (mobileNumber.value.isEmpty) {
      Get.snackbar("Error", "Please enter your mobile number");
    } else if (!_isValidPakistaniNumber(mobileNumber.value)) {
      Get.snackbar("Error", "Please enter a valid Pakistani number (e.g. 03001234567)");
    } else {
      Get.toNamed('/otp');
    }
  }

  void signUp() {
    if (fullName.value.isEmpty || cnic.value.isEmpty || mobileNumber.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
    } else if (!_isValidCNIC(cnic.value)) {
      Get.snackbar("Error", "Please enter a valid 13-digit CNIC number");
    } else if (!_isValidPakistaniNumber(mobileNumber.value)) {
      Get.snackbar("Error", "Please enter a valid Pakistani number (e.g. 03001234567)");
    } else if (!termsAccepted.value) { // ✅ Check if checkbox is checked
      Get.snackbar("Error", "Please accept Terms & Conditions");
    } else {
      Get.toNamed('/otp'); // proceed to OTP screen
    }
  }


  void verifyOTP() {
    if (otpCode.value.length == 4) {
      Get.snackbar("Success", "OTP Verified");
      Get.offAllNamed('/login');
    } else {
      Get.snackbar("Error", "Please enter a valid 6-digit OTP");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
