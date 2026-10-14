import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_theme.dart';

/// arguments: 'terms' ya 'privacy'. Text ko apne actual content se badlo.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  static const _terms = [
    ['1. Use of app', 'Ye app sirf Alpha Products ke authorised employees ke liye hai. Login details kisi ke saath share na karein.'],
    ['2. Attendance & location', 'Attendance, delivery aur trip ke dauran aapki GPS location aur selfie company ke records me save hoti hai.'],
    ['3. Data accuracy', 'Delivery quantity, remarks aur signature sahi bharna aapki zimmedari hai.'],
    ['4. Misuse', 'App ka galat istemal karne par company policy ke hisaab se action liya ja sakta hai.'],
  ];

  static const _privacy = [
    ['Data jo hum lete hain', 'Naam, mobile, email, attendance selfie, GPS location, delivery proof photo aur signature.'],
    ['Data ka istemal', 'Attendance, delivery verification, vehicle tracking aur reports ke liye.'],
    ['Data security', 'Aapka data secure servers par rakha jata hai aur sirf authorised admin dekh sakte hain.'],
    ['Aapke adhikar', 'Apna data dekhne ya sudharne ke liye admin / support se contact karein.'],
  ];

  @override
  Widget build(BuildContext context) {
    final isTerms = Get.arguments != 'privacy';
    final sections = isTerms ? _terms : _privacy;
    return Scaffold(
      appBar: AppBar(title: Text(isTerms ? 'Terms & Conditions' : 'Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final s in sections) ...[
            Text(s[0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 6),
            Text(s[1], style: const TextStyle(height: 1.5, color: AppColors.text)),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
