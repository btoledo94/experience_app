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
            child: Semantics(
              button: true,
              selected: isSelected,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2962FF)
                        : const Color(0xFFE0E0E0),
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: colors[index].computeLuminance() > 0.5
                              ? const Color(0xFF1A1A2E)
                              : Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
