import 'package:flutter/material.dart';
import 'package:caja_herramientas/app/core/theme/dagrd_colors.dart';

class RatingItemWidget extends StatefulWidget {
  final int rating;
  final String title;
  final Color color;
  final List<String>? detailedItems;
  final bool isLastItem;

  const RatingItemWidget({
    super.key,
    required this.rating,
    required this.title,
    required this.color,
    this.detailedItems,
    this.isLastItem = false,
  });

  @override
  State<RatingItemWidget> createState() => _RatingItemWidgetState();
}

class _RatingItemWidgetState extends State<RatingItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isUnrated = widget.rating == 0;
    final isNotApplicable = widget.rating == -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: (isUnrated || isNotApplicable)
                ? ThemeColors.surfaceVariant
                : ThemeColors.surface,
            border: Border(
              bottom: BorderSide(
                color: widget.isLastItem
                    ? Colors.transparent
                    : ThemeColors.outline,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isNotApplicable ? Colors.white : widget.color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    isNotApplicable ? 'NA' : widget.rating.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isUnrated
                          ? ThemeColors.blancoDAGRD
                          : ThemeColors.negroDAGRD,
                      fontFamily: 'Work Sans',
                      fontSize: isNotApplicable ? 16 : 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 16 / 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: ThemeColors.negroDAGRD,
                    fontFamily: 'Work Sans',
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 20 / 15,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: ThemeColors.grisMedio,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        if (_isExpanded && widget.detailedItems != null)
          Container(
            color: const Color(0xFFF9FAFB),
            // padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.detailedItems!
                    .map((item) => _buildDetailItem(item))
                    .toList(),
                Divider(color: ThemeColors.outline, height: 1),
              ],
            ),
          ),
        
      ],
    );
  }

  Widget _buildDetailItem(String item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Text(
        item,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Color(0xFF1E1E1E),
          fontFamily: 'Work Sans',
          fontSize: 12,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          height: 20 / 12,
        ),
      ),
    );
  }
}
