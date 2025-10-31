import 'package:caja_herramientas/app/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/theme_colors.dart';
import 'package:flutter_svg/svg.dart';

enum ConfirmationDialogType {
  success,
  info,
  warning,
  error,
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final ConfirmationDialogType type;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = ConfirmationDialogType.success,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360, // width: 360px
        padding: const EdgeInsets.all(20), // padding: 15px 20px (usando 20px para mantener simetría)
        decoration: BoxDecoration(
          color: Colors.white, // background: #FFF
          borderRadius: BorderRadius.circular(8), // border-radius: 8px
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // align-items: flex-start
          children: [
            // Header con ícono
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
             
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: _getIcon(),
                  ),
                  const SizedBox(width: 10), 
                  // Título
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF000000), 
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500, 
                      height: 1.125, 
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 18), 
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity, 
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: 'Work Sans',
                    fontSize: 13.6,
                    fontWeight: FontWeight.w400, 
                    height: 1.764705882,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18), // gap final
          ],
        ),
      ),
    );
  }

  Widget _getIcon() {
    switch (type) {
      case ConfirmationDialogType.success:
        return  SvgPicture.asset(
          AppIcons.checkCirclev2,
          colorFilter: const ColorFilter.mode(
            Color(0xFF10B981),
            BlendMode.srcIn,
          ),
        );
      case ConfirmationDialogType.info:
        return SvgPicture.asset(
          AppIcons.info,
          colorFilter: ColorFilter.mode(
            ThemeColors.azulDAGRD,
            BlendMode.srcIn,
          ),
        );      
        
      case ConfirmationDialogType.warning:
        return SvgPicture.asset(
          AppIcons.warning,
          colorFilter: const ColorFilter.mode(
            Color(0xFFF59E0B),
            BlendMode.srcIn,
          ),
        );    
      case ConfirmationDialogType.error:
        return const Icon(
          Icons.error_outline,
          color: Color(0xFFEF4444),
          size: 32,
        );
    }
  }

  /// Método estático para mostrar el diálogo fácilmente
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    ConfirmationDialogType type = ConfirmationDialogType.success,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          message: message,
          type: type,
        );
      },
    );
  }
}