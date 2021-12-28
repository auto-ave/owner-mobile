import 'package:flutter/material.dart';
import 'package:owner_app/size_config.dart';

class CommonTextField extends StatelessWidget {
  final String? fieldName;
  final String? hintText;
  final TextEditingController fieldController;
  final String? Function(String?)? validator;
  final bool filled;
  final int? maxLines;
  final bool? obscureText;
  const CommonTextField(
      {Key? key,
      this.fieldName,
      this.hintText,
      required this.fieldController,
      this.validator,
      this.filled = true,
      this.maxLines,
      this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: fieldController,
      style: SizeConfig.kStyle14W500,
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        filled: filled,
        fillColor: Color(0xffF2F8FF),
        labelText: fieldName,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: SizeConfig.kPrimaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: SizeConfig.kPrimaryColor)),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: SizeConfig.kPrimaryColor),
        ),
      ),
    );
  }
}
