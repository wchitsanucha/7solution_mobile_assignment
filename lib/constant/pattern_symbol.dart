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
