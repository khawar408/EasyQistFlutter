import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/colors.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ Close keyboard when tapping outside TextField
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/icons/login_illustration.png', height: 250),
                  const SizedBox(height: 30),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please sign in to continue",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done, // ✅ shows "Done" button on iOS
                    onEditingComplete: () => FocusScope.of(context).unfocus(), // ✅ closes keyboard on Done
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/pk_flag.png',
                              width: 24,
                              height: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "+92",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => controller.mobileNumber.value = val,
                  ),
                  const SizedBox(height: 30),
                  Obx(() {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: controller.isLoading.value ? null : controller.login,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Not having an account? ",
                      style: const TextStyle(color: AppColors.grey, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed('/signup'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
