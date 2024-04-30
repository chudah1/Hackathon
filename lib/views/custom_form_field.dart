import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final Function(String?) onSaved;
  final Function(String?) validator;
  final String? initialValue;
  final bool? enabled;

  const CustomTextFormField(
      {super.key, required this.hintText,
      required this.prefixIcon,
      required this.onSaved,
      required this.validator,
      this.initialValue,
      this.enabled});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SizedBox(
        width: 250,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            final errorMessage = widget.validator(value);
            return errorMessage?.toString();
          },
          obscureText: widget.hintText == "password",
          onSaved: widget.onSaved,
          enabled: widget.enabled,
          initialValue: widget.initialValue,
        ),
      ),
    );
  }
}