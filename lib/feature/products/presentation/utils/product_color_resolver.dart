import 'package:flutter/material.dart';

Color productColorFromName(String colorName, {Color? fallback}) {
  final input = colorName.trim();
  final hexColor = _tryParseHexColor(input);
  if (hexColor != null) return hexColor;

  final normalized = _normalizeColorName(input);
  if (normalized.isEmpty) {
    return fallback ?? const Color(0xFF757575);
  }

  return _namedColors[normalized] ??
      _namedColors.entries
          .firstWhere(
            (entry) => normalized.contains(entry.key),
            orElse: () => MapEntry('', fallback ?? const Color(0xFF757575)),
          )
          .value;
}

List<Color> productColorsFromNames(List<String> colorNames) {
  const fallbackPalette = [
    Color(0xFF1A1A2E),
    Color(0xFF757575),
    Color(0xFFE0E0E0),
    Color(0xFF2962FF),
    Color(0xFFFFFFFF),
  ];

  return List.generate(colorNames.length, (index) {
    return productColorFromName(
      colorNames[index],
      fallback: fallbackPalette[index % fallbackPalette.length],
    );
  });
}

Color? _tryParseHexColor(String value) {
  final hex = value.replaceFirst('#', '').replaceFirst('0x', '');
  if (!RegExp(r'^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$').hasMatch(hex)) {
    return null;
  }

  final argbHex = hex.length == 6 ? 'FF$hex' : hex;
  return Color(int.parse(argbHex, radix: 16));
}

String _normalizeColorName(String value) {
  return value
      .toLowerCase()
      .replaceAll('\u00E1', 'a')
      .replaceAll('\u00E9', 'e')
      .replaceAll('\u00ED', 'i')
      .replaceAll('\u00F3', 'o')
      .replaceAll('\u00FA', 'u')
      .replaceAll('\u00FC', 'u')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

const _namedColors = <String, Color>{
  'black': Color(0xFF1A1A1A),
  'negro': Color(0xFF1A1A1A),
  'white': Color(0xFFFFFFFF),
  'blanco': Color(0xFFFFFFFF),
  'grey': Color(0xFF757575),
  'gray': Color(0xFF757575),
  'gris': Color(0xFF757575),
  'light grey': Color(0xFFE0E0E0),
  'light gray': Color(0xFFE0E0E0),
  'gris claro': Color(0xFFE0E0E0),
  'blue': Color(0xFF2962FF),
  'azul': Color(0xFF2962FF),
  'red': Color(0xFFF44336),
  'rojo': Color(0xFFF44336),
  'green': Color(0xFF4CAF50),
  'verde': Color(0xFF4CAF50),
  'yellow': Color(0xFFFFC107),
  'amarillo': Color(0xFFFFC107),
  'orange': Color(0xFFFF9800),
  'naranja': Color(0xFFFF9800),
  'purple': Color(0xFF7E57C2),
  'morado': Color(0xFF7E57C2),
  'violeta': Color(0xFF7E57C2),
  'pink': Color(0xFFE91E63),
  'rosado': Color(0xFFE91E63),
  'rosa': Color(0xFFE91E63),
  'brown': Color(0xFF795548),
  'cafe': Color(0xFF795548),
  'marron': Color(0xFF795548),
};
