import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // height: 48px
      width: double.infinity, // align-self: stretch
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ThemeColors.amarDAGRD, // background: var(--AmarDAGRD, #FC0)
          foregroundColor: textColor ?? const Color(0xFF1E1E1E), // color: var(--Textos, #1E1E1E)
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // padding: 8px 10px
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4), // border-radius: 4px
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E1E1E)),
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center, // text-align: center
                style: TextStyle(
                  color: textColor ?? const Color(0xFF1E1E1E), // color: var(--Textos, #1E1E1E)
                  fontFamily: 'Work Sans', // font-family: "Work Sans"
                  fontSize: fontSize ?? 20, // font-size: 20px
                  fontWeight: fontWeight ?? FontWeight.w500, // font-weight: 500
                  height: 1.2, // line-height: 24px / 20px = 120%
                ),
              ),
      ),
    );
  }
}
