import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBarItem {
  final String label;
  final String iconAsset;
  final bool isSvg;
  final Widget? customIcon;

  const CustomBottomNavBarItem({
    required this.label,
    required this.iconAsset,
    this.isSvg = true,
    this.customIcon,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavBarItem> items;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedIconBgColor;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor = Colors.white,
    this.selectedColor = Colors.white,
    this.unselectedColor = const Color(0x99FFFFFF),
    this.selectedIconBgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Validar currentIndex para evitar errores cuando es -1
    final validCurrentIndex = (currentIndex >= 0 && currentIndex < items.length) 
        ? currentIndex 
        : 0; // Fallback to first item, but we'll handle selection visually
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Work Sans',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.17,
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Work Sans',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.17,
      ),
      currentIndex: validCurrentIndex,
      onTap: onTap,
      items: List.generate(items.length, (index) {
        final item = items[index];
        // Si currentIndex es -1, ningún item debe aparecer seleccionado
        final isSelected = (currentIndex >= 0) && (index == currentIndex);
        return BottomNavigationBarItem(
          icon: item.customIcon ??
              (item.isSvg
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: selectedIconBgColor,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: SvgPicture.asset(
                        item.iconAsset,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          isSelected ? backgroundColor : selectedColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(
                      IconData(int.parse(item.iconAsset), fontFamily: 'MaterialIcons'),
                      color: isSelected ? backgroundColor : selectedColor,
                    )),
          label: item.label,
        );
      }),
    );
  }
}
