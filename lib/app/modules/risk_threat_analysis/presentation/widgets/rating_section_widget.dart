import 'package:flutter/material.dart';
import 'rating_item_widget.dart';

class RatingSectionWidget extends StatelessWidget {
  final String title;
  final String score;
  final List<Map<String, dynamic>> items;

  const RatingSectionWidget({
    super.key,
    required this.title,
    required this.score,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFF232B48),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    height: 16 / 16,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      score,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border(
              left: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              right: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              bottom: BorderSide(color: Color(0xFFD1D5DB), width: 1),
            ),
          ),
          child: Column(
            children: items.map((item) => RatingItemWidget(
              rating: item['rating'] as int,
              title: item['title'] as String,
              color: item['color'] as Color,
            )).toList(),
          ),
        ),
      ],
    );
  }
}