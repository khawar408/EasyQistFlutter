import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/colors.dart';
import '../controllers/auth_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  final controller = Get.find<AuthController>();
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    controller.startResendTimer();

    return Scaffold(
      body: GestureDetector(   // ✅ Detect taps outside TextField
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/otp_illustration.png', height: 250),
                const SizedBox(height: 30),
                const Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Enter the 4-digit code sent to your number"),
                const SizedBox(height: 30),

                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 60,
                      child: TextField(
                        controller: otpControllers[index],
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          if (val.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (val.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                          controller.otpCode.value = otpControllers.map((c) => c.text).join();
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 30),
              Obx(() {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed:controller.isLoading.value ? null : controller.verifyOTP,
                  child: controller.isLoading.value
                      ?const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text("Continue", style: TextStyle(fontSize: 18)),
                );
              }),
                const SizedBox(height: 20),

                Obx(() => TextButton(
                  onPressed: controller.resendTimer.value == 0 ? controller.resendOTP : null,
                  child: Text(
                    controller.resendTimer.value == 0
                        ? "Resend Code"
                        : "Resend code in ${controller.resendTimer.value}s",
                    style: TextStyle(
                      color: controller.resendTimer.value == 0 ? Colors.green : AppColors.primary,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


