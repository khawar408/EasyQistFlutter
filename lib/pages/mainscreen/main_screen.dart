import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../util/colors.dart';
import '../brands/brands_screen.dart';
import '../category/CategoriesScreen.dart';
import '../home_screen/home_screen.dart';
import '../profile/profile_screen.dart';
import 'main_screen_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final controller = Get.put(MainScreenController());

  final List<Widget> pages = [
     HomeScreen(),
     CategoriesScreen(),
     BrandsScreen(),
     ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 24, // same size as ImageIcon
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/category.png'),
                size: 24,
                color: controller.currentIndex.value == 1
                    ? AppColors.primary
                    : Colors.grey,
              ),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/brand.png'),
                size: 24,
                color: controller.currentIndex.value == 2
                    ? AppColors.primary
                    : Colors.grey,
              ),
              label: "Brands",
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 24,
              ),
              label: "Profile",
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          controller.openWhatsApp("+923000828456");
        },
        child:  const FaIcon(FontAwesomeIcons.whatsapp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
