import 'package:flutter/material.dart';

class CheckoutStepper extends StatelessWidget {
  final int currentStep;

  const CheckoutStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          const [
            _StepItem(index: 0, label: 'Your bag'),
            _StepItem(index: 1, label: 'Shipping'),
            _StepItem(index: 2, label: 'Payment'),
          ].asMap().entries.map((entry) {
            final item = entry.value;
            return _StepItem(
              index: item.index,
              label: item.label,
              currentStep: currentStep,
            );
          }).toList(),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int index;
  final String label;
  final int currentStep;

  const _StepItem({
    required this.index,
    required this.label,
    this.currentStep = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;

    Color circleColor;
    Widget circleChild;

    if (isCompleted) {
      circleColor = const Color(0xFFBFDFFF);
      circleChild = const Icon(Icons.check, size: 14, color: Color(0xFF1A73E8));
    } else if (isCurrent) {
      circleColor = const Color(0xFF1A73E8);
      circleChild = Text(
        '${index + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      circleColor = const Color(0xFFE0E4EA);
      circleChild = Text(
        '${index + 1}',
        style: const TextStyle(
          color: Color(0xFF8A94A6),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: circleChild),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCurrent
                ? const Color(0xFF1A1A2E)
                : const Color(0xFF8A8F9B),
            fontSize: 14,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
