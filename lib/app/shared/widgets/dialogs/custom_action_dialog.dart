import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class CustomActionDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color? iconColor;
  final bool showIconBorder;
  final String leftButtonText;
  final IconData leftButtonIcon;
  final VoidCallback? onLeftButtonPressed;
  final String rightButtonText;
  final IconData rightButtonIcon;
  final VoidCallback? onRightButtonPressed;
  final bool isLeftButtonOutlined;
  final Color? rightButtonColor;

  const CustomActionDialog({
    super.key,
    required this.title,
    required this.message,
    this.iconColor,
    this.showIconBorder = false,
    required this.leftButtonText,
    required this.leftButtonIcon,
    this.onLeftButtonPressed,
    required this.rightButtonText,
    required this.rightButtonIcon,
    this.onRightButtonPressed,
    this.isLeftButtonOutlined = true,
    this.rightButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
          children: [
            // Header con título y botón de cerrar
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Work Sans',
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      height: 18 / 16, // 112.5% -> 18px
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                height: 24 / 14, // 171.429% -> 24px
              ),
            ),

            const SizedBox(height: 24),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        onLeftButtonPressed ??
                        () => Navigator.of(context).pop(),
                    icon: Icon(leftButtonIcon, size: 20, color: Colors.black),
                    label: Text(
                      leftButtonText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        height: 24 / 14, // 171.429%
                      ),
                    ),
                     style: OutlinedButton.styleFrom(
                       side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                       backgroundColor: const Color(0xFFFFFFFF), // #FFF
                       padding: const EdgeInsets.symmetric(vertical: 12),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(4), // 4px
                       ),
                     ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        onRightButtonPressed ??
                        () => Navigator.of(context).pop(),
                    icon: Icon(rightButtonIcon, size: 20, color: Colors.white),
                    label: Text(
                      rightButtonText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF), // #FFF
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        height: 24 / 14, // 171.429%
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rightButtonColor ?? ThemeColors.azulDAGRD,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Método estático para mostrar el diálogo fácilmente
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? iconText,
    Color? iconColor,
    bool showIconBorder = false,
    required String leftButtonText,
    required IconData leftButtonIcon,
    VoidCallback? onLeftButtonPressed,
    required String rightButtonText,
    required IconData rightButtonIcon,
    VoidCallback? onRightButtonPressed,
    bool isLeftButtonOutlined = true,
    Color? rightButtonColor,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomActionDialog(
          title: title,
          message: message,
          iconColor: iconColor,
          showIconBorder: showIconBorder,
          leftButtonText: leftButtonText,
          leftButtonIcon: leftButtonIcon,
          onLeftButtonPressed: onLeftButtonPressed,
          rightButtonText: rightButtonText,
          rightButtonIcon: rightButtonIcon,
          onRightButtonPressed: onRightButtonPressed,
          isLeftButtonOutlined: isLeftButtonOutlined,
          rightButtonColor: rightButtonColor,
        );
      },
    );
  }

  // Métodos de conveniencia para los diálogos específicos
  static Future<void> showFinishForm({
    required BuildContext context,
    required String category,
    VoidCallback? onReview,
    VoidCallback? onFinish,
  }) {
    return show(
      context: context,
      title: 'Finalizar formulario',
      message:
          '¿Está seguro que desea finalizar el formulario para la categoría de $category?',
      iconText: 'T',
      iconColor: ThemeColors.azulDAGRD,
      showIconBorder: true,
      leftButtonText: 'Revisar',
      leftButtonIcon: Icons.edit,
      onLeftButtonPressed: onReview,
      rightButtonText: 'Finalizar',
      rightButtonIcon: Icons.check,
      onRightButtonPressed: onFinish,
    );
  }

  static Future<void> showIncompleteForm({
    required BuildContext context,
    VoidCallback? onCancel,
    VoidCallback? onReview,
  }) {
    return show(
      context: context,
      title: 'Formulario incompleto',
      message:
          'Antes de finalizar, revisa el formulario. Algunas variables aún no han sido evaluadas',
      leftButtonText: 'Cancelar',
      leftButtonIcon: Icons.close,
      onLeftButtonPressed: onCancel,
      rightButtonText: 'Revisar',
      rightButtonIcon: Icons.edit,
      onRightButtonPressed: onReview,
    );
  }

  static Future<void> showSaveDraft({
    required BuildContext context,
    String saveButtonText = 'Guardar',
    VoidCallback? onReview,
    VoidCallback? onSave,
  }) {
    return show(
      context: context,
      title: 'Guardar borrador',
      message:
          '¿Está seguro que desea guardar un borrador de este formulario? Podrá continuar más tarde.',
      leftButtonText: 'Revisar',
      leftButtonIcon: Icons.edit,
      onLeftButtonPressed: onReview,
      rightButtonText: saveButtonText,
      rightButtonIcon: Icons.check,
      onRightButtonPressed: onSave,
    );
  }
}
