import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:user/controller/theme_controller.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      final bool isDark = themeController.darkTheme; // Use controller state!
      return Padding(
        padding:  EdgeInsets.only(right: 15.w),
        child: GestureDetector(
          onTap: () {
            themeController.toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 48,
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.grey[800] : Colors.yellow[600],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sun icon in circle (left)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !isDark ? Colors.white : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.light_mode,
                    size: 16,
                    color: !isDark ? Colors.yellow[700] : Colors.grey[500],
                  ),
                ),
                // Moon icon in circle (right)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.yellow[600] : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.dark_mode,
                    size: 16,
                    color: isDark ? Colors.black : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
} 