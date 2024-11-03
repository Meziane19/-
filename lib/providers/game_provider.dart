import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameState {
  final int balance;
  final int jackpot;
  final bool showConfetti;

  GameState({
    required this.balance,
    required this.jackpot,
    required this.showConfetti,
  });

  GameState copyWith({
    int? balance,
    int? jackpot,
    bool? showConfetti,
  }) {
    return GameState(
      balance: balance ?? this.balance,
      jackpot: jackpot ?? this.jackpot,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier()
      : super(GameState(
          balance: 100,
          jackpot: 1000,
          showConfetti: false,
        ));

  void handleSpinComplete(int prize) {
    state = state.copyWith(
      balance: state.balance + prize,
      jackpot: prize == 5 ? 1000 : state.jackpot + 10,
      showConfetti: prize == 5,
    );

    if (prize == 5) {
      Future.delayed(const Duration(seconds: 5), () {
        state = state.copyWith(showConfetti: false);
      });
    }
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});