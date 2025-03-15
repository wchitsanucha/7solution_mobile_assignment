import 'package:flutter/material.dart';

enum PatternSymbol { square, circle, cross }

class PatternSet {
  PatternSet._();

  static const List<List<PatternSymbol>> patterns = [
    [
      PatternSymbol.circle,
      PatternSymbol.square,
      PatternSymbol.square,
      PatternSymbol.cross,
    ], // Pattern A
    [
      PatternSymbol.circle,
      PatternSymbol.cross,
      PatternSymbol.cross,
      PatternSymbol.square,
    ], // Pattern B
  ];

  static PatternSymbol getSymbolByIndex(int index) {
    int patternIndex = (index ~/ 4) % 2; // Switch between pattern A and B
    int symbolIndex = index % 4; // Get symbol within the pattern

    // debugPrint("@@@ Index $index => $patternIndex, $symbolIndex");

    return PatternSet.patterns[patternIndex][symbolIndex];
  }

  static IconData getSymbol(PatternSymbol symbol) {
    switch (symbol) {
      case PatternSymbol.circle:
        return Icons.circle_outlined;
      case PatternSymbol.square:
        return Icons.square_outlined;
      case PatternSymbol.cross:
        return Icons.close;
      default:
        return Icons.close;
    }
  }
}
