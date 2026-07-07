import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 186.44,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(34.0),
                bottomRight: Radius.circular(34.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.location_pin)),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text('data'),
                        Text('data >'),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
                  ],
                ),
                CustomTextField(
                  controller: TextEditingController(),
                  fillColor: AppColors.fillColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsetsGeometry.directional(start: 16.0, end: 5.0),
                    child: SvgPicture.asset('assets/icons/search_icon.svg'),
                  ),
                  hintText: 'ابحث عن قلم، دفتر، حقيبة...',
                ),
              ],
            ),
          ),

          const Expanded(
            child: Center(
              child: Text('Home'),
            ),
          ),
        ],
      ),
    );
  }
}