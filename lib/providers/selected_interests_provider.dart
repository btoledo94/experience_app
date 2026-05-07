import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para manejar los intereses seleccionados
final selectedInterestsProvider =
    StateNotifierProvider<SelectedInterestsNotifier, Set<String>>((ref) {
  return SelectedInterestsNotifier();
});

class SelectedInterestsNotifier extends StateNotifier<Set<String>> {
  SelectedInterestsNotifier()
      : super({
          'User Interface',
          'User Research',
          'Strategy',
          'Design Systems',
        });

  void toggle(String interest) {
    if (state.contains(interest)) {
      state = {...state}..remove(interest);
    } else {
      state = {...state, interest};
    }
  }

  void reset() {
    state = {
      'User Interface',
      'User Research',
      'Strategy',
      'Design Systems',
    };
  }

  List<String> getSelected() => state.toList();
}
