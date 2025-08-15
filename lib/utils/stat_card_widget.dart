import 'package:admin/constants/colors.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


Widget statCard(String title, String value, String icon, Color iconColor,  {bool? isDark =false,bool flag = false,String? name,bool analytics=false}) {
  return Container(
    height: 180,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: isDark! ? Color(0xFF23272F) : Colors.transparent,
      border: Border.all(width: 0.2, color: AppColors.grey),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextTheme.regular16.copyWith(
                    color: AppColors.grey,
                    fontSize: analytics ? 14:16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (name != null) ...[

                const SizedBox(height: 4),

                 Text(
                  name.toString(),
                  style: CustomTextTheme.regular20.copyWith(fontWeight: FontWeight.w500),
                ),
                ],
                const SizedBox(height: 4),
                Text(
                  value,
                  style: CustomTextTheme.regular26.copyWith(fontWeight: FontWeight.w500,fontSize: analytics ? 20:26),
                ),
              ],
            ),
            flag
              ? SvgPicture.asset(icon, width: 35)
              : SvgPicture.asset(icon, color: iconColor,),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(50, 21, 168, 31),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    size: 14,
                    color: Color.fromARGB(255, 21, 168, 31),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "0.5%",
                    style: CustomTextTheme.regular12.copyWith(
                      color: Color.fromARGB(255, 21, 168, 31),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "All Time",
              style: CustomTextTheme.regular12.copyWith(color: Colors.grey),
            ),
          ],
        )
      ],
    ),
  );
}
