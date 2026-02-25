import 'package:flutter/material.dart';

const Color kNavyDark = Color(0xFF0A1628);
const Color kNavyMid = Color(0xFF0D1F3C);
const Color kNavyCard = Color(0xFF162340);
const Color kGold = Color(0xFFF5A623);
const Color kGoldLight = Color(0xFFFFBD4A);
const Color kWhite = Colors.white;
const Color kWhite70 = Color(0xB3FFFFFF);
const Color kWhite40 = Color(0x66FFFFFF);

const List<String> kCategories = [
  'All',
  'Hospital',
  'Police Station',
  'Library',
  'Restaurant',
  'Café',
  'Park',
  'Tourist Attraction',
  'Pharmacy',
  'Utility Office',
];

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kNavyDark,
    primaryColor: kGold,
    colorScheme: const ColorScheme.dark(
      primary: kGold,
      secondary: kGoldLight,
      surface: kNavyCard,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: kNavyDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: kWhite,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: kWhite),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kNavyMid,
      selectedItemColor: kGold,
      unselectedItemColor: kWhite40,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kNavyDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kNavyCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kGold, width: 1.5),
      ),
      hintStyle: const TextStyle(color: kWhite40, fontSize: 14),
      labelStyle: const TextStyle(color: kWhite70),
      prefixIconColor: kWhite40,
      suffixIconColor: kWhite40,
    ),
    cardTheme: CardThemeData(
      color: kNavyCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kNavyCard,
      selectedColor: kGold,
      labelStyle: const TextStyle(color: kWhite, fontSize: 13),
      secondaryLabelStyle: const TextStyle(color: kNavyDark, fontWeight: FontWeight.w600, fontSize: 13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: kWhite, fontWeight: FontWeight.w800, fontSize: 28),
      headlineMedium: TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 22),
      titleLarge: TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 18),
      titleMedium: TextStyle(color: kWhite, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: TextStyle(color: kWhite70, fontWeight: FontWeight.w500, fontSize: 14),
      bodyLarge: TextStyle(color: kWhite, fontSize: 15),
      bodyMedium: TextStyle(color: kWhite70, fontSize: 14),
      bodySmall: TextStyle(color: kWhite40, fontSize: 12),
    ),
  );
}
