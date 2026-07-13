import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
            prefixIcon: Icon(widget.prefixIcon, size: 20, color: AppColors.textSecondary),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.primary),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(widget.errorText!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
        ],
      ],
    );
  }
}
