import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';

class FibonacciViewModel {
  final List<FibonacciItem> _fibonacciList = <FibonacciItem>[];
  final List<FibonacciItem> _circleList = <FibonacciItem>[];
  final List<FibonacciItem> _squareList = <FibonacciItem>[];
  final List<FibonacciItem> _crossList = <FibonacciItem>[];

  final _fibonacciListController = StreamController<List<FibonacciItem>>();
  get fibonacciListStream => _fibonacciListController.stream;
  get fibonacciList => _fibonacciList;

  final _circleListController = StreamController<List<FibonacciItem>>();
  get circleListStream => _circleListController.stream;
  get circleList => _circleList;

  final _squareListController = StreamController<List<FibonacciItem>>();
  get squareListStream => _squareListController.stream;
  get squareList => _squareList;

  final _crossListController = StreamController<List<FibonacciItem>>();
  get crossListStream => _crossListController.stream;
  get crossList => _crossList;

  init() {
    generateFibonacci(40); // Generate first 40 Fibonacci numbers
    _fibonacciListController.add(_fibonacciList);
  }

  dispose() {
    _fibonacciListController.close();
    _circleListController.close();
    _squareListController.close();
    _crossListController.close();
  }

  // increaseCounter() {
  //   _counter += _counterRepository.getIncrement();
  //   _counterController.sink.add(_counter);
  // }

  void addItemToList(FibonacciItem item) {
    switch (item.symbol) {
      case PatternSymbol.circle:
        return _circleList.add(item);
      case PatternSymbol.square:
        return _squareList.add(item);
      case PatternSymbol.cross:
        return _crossList.add(item);
      default:
        debugPrint("Something went wrong !!!");
        break;
    }
  }

  void generateFibonacci(int count) {
    int startIndex = _fibonacciList.length;
    for (int i = 0; i < count; i++) {
      int index = startIndex + i;
      BigInt value;

      if (index == 0) {
        value = BigInt.zero;
      } else if (index == 1) {
        value = BigInt.one;
      } else {
        value =
            _fibonacciList[index - 1].value + _fibonacciList[index - 2].value;
      }

      // Attach the symbol directly
      PatternSymbol symbol = _getSymbolByIndex(index);

      _fibonacciList.add(
        FibonacciItem(index, value, symbol),
      );
    }
  }

  PatternSymbol _getSymbolByIndex(int index) {
    int patternIndex = (index ~/ 4) % 2; // Switch between pattern A and B
    int symbolIndex = index % 4; // Get symbol within the pattern

    // debugPrint("@@@ Index $index => $patternIndex, $symbolIndex");

    return PatternSet.patterns[patternIndex][symbolIndex];
  }
}
