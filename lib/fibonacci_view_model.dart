import 'dart:async';
import 'dart:developer';

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

  final _circleListController =
      StreamController<List<FibonacciItem>>.broadcast();
  get circleListStream => _circleListController.stream;

  final _squareListController =
      StreamController<List<FibonacciItem>>.broadcast();
  get squareListStream => _squareListController.stream;

  final _crossListController =
      StreamController<List<FibonacciItem>>.broadcast();
  get crossListStream => _crossListController.stream;

  init() {
    generateFibonacci(40); // Generate first 40 Fibonacci numbers
    _fibonacciListController.sink.add(_fibonacciList);
  }

  dispose() {
    _fibonacciListController.close();
    _circleListController.close();
    _squareListController.close();
    _crossListController.close();
  }

  void addItemToList(FibonacciItem item) {
    switch (item.symbol) {
      case PatternSymbol.circle:
        _circleList.add(item);
        _circleListController.sink.add(_circleList);
        debugPrint("Circle added: ${item.id}");
        break;
      case PatternSymbol.square:
        _squareList.add(item);
        _squareListController.sink.add(_squareList);
        debugPrint("Square added: ${item.id}");
        break;
      case PatternSymbol.cross:
        _crossList.add(item);
        _crossListController.sink.add(_crossList);
        debugPrint("Cross added: ${item.id}");
        break;
      default:
        debugPrint("Something went wrong !!!");
        break;
    }

    _fibonacciList.removeWhere((element) => element.id == item.id);
    _fibonacciListController.sink.add(_fibonacciList);

    // inspect(_fibonacciList);
    // inspect(_circleList);
    // inspect(_squareList);
    // inspect(_crossList);
    // debugPrint("--------------------");
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
      PatternSymbol symbol = PatternSet.getSymbolByIndex(index);

      _fibonacciList.add(
        FibonacciItem(index, value, symbol),
      );
    }
  }
}
