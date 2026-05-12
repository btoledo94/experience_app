import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedColorIndex;
  final Function(int) onColorSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(colors.length, (index) {
        final isSelected = index == selectedColorIndex;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onColorSelected(index),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: const Color(0xFF2962FF), width: 3)
                    : null,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 20),
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
