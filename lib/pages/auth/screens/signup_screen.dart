import 'package:easyqist/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // ✅ close keyboard when tapping outside
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  Image.asset('assets/icons/signup_illustration.png', height: 250),
                  const SizedBox(height: 20),
                  const Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please enter details below to continue",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Full Name Field
                  TextField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // ✅ no border
                      ),
                    ),
                    onChanged: (val) => controller.fullName.value = val,
                  ),
                  const SizedBox(height: 15),

                  // CNIC Field
                  TextField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "13 Digit CNIC",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) => controller.cnic.value = val,
                  ),
                  const SizedBox(height: 15),

                  // Mobile Number Field with Pakistan flag
                  TextField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
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
                              'assets/icons/pk_flag.png', // 🇵🇰 Pakistan flag icon
                              width: 24,
                              height: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "+92",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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

                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () => Checkbox(
                          value: controller.termsAccepted.value,
                          onChanged: (val) => controller.termsAccepted.value = val!,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "By continuing, I agree to ",
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Open your Terms & Conditions screen
                                    Get.toNamed('/terms');
                                  },
                              ),
                              const TextSpan(text: " & "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Open your Privacy Policy screen
                                    Get.toNamed('/privacy');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),



                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: controller.signUp,
                    child: const Text("Continue", style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 15),

                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "SignIn",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.offNamed('/login'),
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
