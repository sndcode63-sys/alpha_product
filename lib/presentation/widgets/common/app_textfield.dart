import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.initialValue,
    this.onTap,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: prefixIcon,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: suffixIcon,
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
        suffixIconConstraints: BoxConstraints(minWidth: 24.w, minHeight: 24.h),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textHint,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius12),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius12),
          borderSide: const BorderSide(color: AppColors.alert),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String? label;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    super.key,
    this.controller,
    required this.hint,
    this.label,
    this.validator,
    this.onChanged,
    this.textInputAction,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hint: widget.hint,
      label: widget.label,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      prefixIcon: FaIcon(
        FontAwesomeIcons.lock,
        size: 16.sp,
        color: AppColors.textHint,
      ),
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: FaIcon(
          _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
          size: 16.sp,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
