import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const faqs = [
    ['Attendance kaise mark karun?', 'Attendance tab me selfie lo, location allow karo aur Check In dabao. Din ke end me Check Out karna na bhoolein.'],
    ['Delivery complete kaise karun?', 'Delivery kholo, Start Trip dabao. Customer ko saman dene ke baad Mark as Delivered me quantity, photo aur signature daalo.'],
    ['Short / excess quantity kya hai?', 'Agar order se kam saman diya to Short, zyada diya to Excess dikhta hai. Submit karte waqt confirm poocha jayega.'],
    ['Location nahi mil rahi', 'Phone ka GPS on karo aur app ko location permission do. Phir Attendance screen par location refresh karo.'],
    ['Password bhool gaya', 'Login screen par Forgot password dabao aur Employee ID daalo.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _Contact(Icons.call, 'Call us', '+91 98765 00000', () => AppDialogs.snack('Call', 'Dialer khul raha hai...'))),
              const SizedBox(width: 12),
              Expanded(child: _Contact(Icons.email_outlined, 'Email', 'support@alpha.in', () => AppDialogs.snack('Email', 'Mail app khul raha hai...'))),
            ],
          ),
          const SectionTitle('FAQs'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: faqs
                  .map((f) => ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        title: Text(f[0], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(f[1], style: const TextStyle(color: AppColors.muted, height: 1.4))],
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.reportProblem),
            icon: const Icon(Icons.bug_report_outlined),
            label: const Text('Report a Problem'),
          ),
        ],
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const _Contact(this.icon, this.title, this.sub, this.onTap);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        ],
      ),
    );
  }
}
