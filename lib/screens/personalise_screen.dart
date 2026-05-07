import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/selected_interests_provider.dart';

class PersonaliseScreen extends ConsumerWidget {
  const PersonaliseScreen({super.key});

  final List<String> _interests = const [
    'User Interface',
    'User Experience',
    'User Research',
    'UX Writing',
    'User Testing',
    'Service Design',
    'Strategy',
    'Design Systems',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el estado de los intereses seleccionados
    final selectedInterests = ref.watch(selectedInterestsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2962FF),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Personalise your experience',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Choose your interests.',
                style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 24),

              // Interest list
              Expanded(
                child: ListView.separated(
                  itemCount: _interests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final interest = _interests[index];
                    final isSelected = selectedInterests.contains(interest);
                    return _InterestTile(
                      label: interest,
                      selected: isSelected,
                      onTap: () {
                        ref
                            .read(selectedInterestsProvider.notifier)
                            .toggle(interest);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Los intereses se guardan automáticamente en el estado
                    debugPrint(
                      'Intereses seleccionados: ${ref.read(selectedInterestsProvider).toList()}',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _InterestTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF2962FF) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: selected
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFF424242),
              ),
            ),
            if (selected)
              const Icon(Icons.check, size: 20, color: Color(0xFF2962FF)),
          ],
        ),
      ),
    );
  }
}
