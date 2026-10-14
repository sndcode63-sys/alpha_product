import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';
import '../core/widgets.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  static const cats = ['Attendance', 'Delivery', 'Vehicle / GPS', 'Login', 'Other'];
  String cat = cats.first;
  bool shot = false;
  final desc = TextEditingController();

  Future<void> _submit() async {
    if (desc.text.trim().length < 10) {
      return AppDialogs.snack('Details kam hain', 'Problem thodi detail me likho (10+ characters)', type: SnackType.warning);
    }
    AppDialogs.loading('Report bheji ja rahi hai...');
    await Future.delayed(const Duration(seconds: 1)); // API call yahan
    AppDialogs.hideLoading();
    Get.back();
    AppDialogs.success('Report submitted', 'Hamari team jaldi aapse contact karegi.');
  }

  @override
  void dispose() {
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report a Problem')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: cats
                .map((c) => ChoiceChip(
                      label: Text(c),
                      selected: cat == c,
                      selectedColor: AppColors.primaryLight,
                      onSelected: (_) => setState(() => cat = c),
                    ))
                .toList(),
          ),
          const SizedBox(height: 18),
          TextField(controller: desc, maxLines: 5, decoration: const InputDecoration(hintText: 'Problem kya hai? Detail me likho...')),
          const SizedBox(height: 16),
          PhotoBox(
            taken: shot,
            emptyLabel: 'Screenshot attach karo (optional)',
            takenLabel: 'Screenshot attached',
            icon: Icons.attach_file,
            onTap: () async {
              final s = await AppDialogs.photoSource();
              if (s != null) setState(() => shot = true);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _submit, child: const Text('Submit Report')),
        ],
      ),
    );
  }
}
