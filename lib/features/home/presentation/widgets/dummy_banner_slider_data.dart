import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/home/domain/entities/dummy_banner_entity.dart';

const List<DummyBannerEntity> dummyBanners = [
  DummyBannerEntity(
    title: 'عروض العودة للمدارس',
    subtitle: 'خصومات حتى 40% على كل المستلزمات',
    buttonText: 'تسوّق الآن',
    image: 'assets/images/backpack.png',
    bgColor: AppColors.primary,
  ),
  DummyBannerEntity(
    title: 'عروض أخرى',
    subtitle: 'خصومات تصل إلى 30%',
    buttonText: 'تسوّق الآن',
    image: 'assets/images/another_item.png',
    bgColor: Colors.blueGrey,
  ),
  DummyBannerEntity(
    title: 'أدوات فنية مميزة',
    subtitle: 'اكتشف تشكيلة الألوان والفرش الجديدة',
    buttonText: 'تسوّق الآن',
    image: 'assets/images/art_supplies.png',
    bgColor: Colors.teal,
  ),
];