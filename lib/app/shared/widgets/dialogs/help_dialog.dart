import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  final String contentTitle;
  final Widget content;
  final VoidCallback? onClose;

  const HelpDialog({
    super.key,
    required this.contentTitle,
    required this.content,
    this.onClose,
  });

  static void show({
    required BuildContext context,
    required String categoryTitle,
    required String contentTitle,
    required Widget content,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => HelpDialog(
        contentTitle: contentTitle,
        content: content,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Ayuda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                      height: 1.125, // 112.5%
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClose?.call();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF1E1E1E),
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider separador
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE5E5E5),
            ),
            
            // Category Title
        
            
            // Content Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                contentTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                  height: 1.5, // 150%
                ),
              ),
            ),
            
            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: content,
              ),
            ),
            
            // Bottom padding
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget helper para crear contenido estructurado
class HelpContent extends StatelessWidget {
  final List<HelpSection> sections;

  const HelpContent({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) => section.build(context)).toList(),
    );
  }
}

class HelpSection {
  final String? title;
  final String? description;
  final List<HelpItem> items;
  final Widget? customWidget;

  const HelpSection({
    this.title,
    this.description,
    this.items = const [],
    this.customWidget,
  });

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E1E1E),
                height: 1.615, // 161.538%
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (description != null) ...[
            Text(
              description!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E1E1E),
                height: 1.615, // 161.538%
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (items.isNotEmpty) ...[
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: item.build(context),
            )),
          ],
          if (customWidget != null) customWidget!,
        ],
      ),
    );
  }
}

class HelpItem {
  final String? text;
  final String? description;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isLink;
  final TextSpan? textSpan;
  final TextSpan? descriptionSpan;

  const HelpItem({
    this.text,
    this.description,
    this.icon,
    this.trailing,
    this.onTap,
    this.isLink = false,
    this.textSpan,
    this.descriptionSpan,
  }) : assert(text != null || textSpan != null, 'Either text or textSpan must be provided');

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 8),
            child: icon!,
          ),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTap,
                child: textSpan != null
                    ? RichText(
                        text: textSpan!,
                        textAlign: TextAlign.left,
                      )
                    : Text(
                        text ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isLink ? const Color(0xFF2563EB) : const Color(0xFF1E1E1E),
                          decoration: isLink ? TextDecoration.underline : null,
                          height: 1.615, // 161.538%
                        ),
                      ),
              ),
              if (description != null || descriptionSpan != null) ...[
                const SizedBox(height: 2),
                descriptionSpan != null
                    ? RichText(
                        text: descriptionSpan!,
                      )
                    : Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1E1E1E),
                          height: 1.615, // 161.538%
                        ),
                      ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: trailing!,
          ),
        ],
      ],
    );
  }
}

// Widget para notas especiales
class HelpNote extends StatelessWidget {
  final String text;
  final Widget? icon;

  const HelpNote({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: icon!,
            ),
          ],
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[800],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para botones de ejemplo
class HelpButtonExample extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  const HelpButtonExample({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
