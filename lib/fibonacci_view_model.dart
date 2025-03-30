import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/numbers.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item_list.dart';

class FibonacciViewModel {
  final List<FibonacciItem> _fibonacciList = <FibonacciItem>[];
  final List<FibonacciItem> _circleList = <FibonacciItem>[];
  final List<FibonacciItem> _squareList = <FibonacciItem>[];
  final List<FibonacciItem> _crossList = <FibonacciItem>[];

  final _fibonacciListController = StreamController<FibonacciListWrapper>();
  get fibonacciListStream => _fibonacciListController.stream;

  final _circleListController = StreamController<FibonacciListWrapper>();
  get circleListStream => _circleListController.stream;

  final _squareListController = StreamController<FibonacciListWrapper>();
  get squareListStream => _squareListController.stream;

  final _crossListController = StreamController<FibonacciListWrapper>();
  get crossListStream => _crossListController.stream;

  int? _popItemId;

  init() {
    // Generate first 40 Fibonacci numbers
    generateFibonacci(ConfigValues.initFibNumber);
  }

  dispose() {
    _fibonacciListController.close();
    _circleListController.close();
    _squareListController.close();
    _crossListController.close();
  }

  void removeItemFromList(FibonacciItem item) {
    _popItemId = item.id;
    switch (item.symbol) {
      case PatternSymbol.circle:
        _circleList.removeWhere((element) => element.id == item.id);
        debugPrint("Circle removed: ${item.id}");
        break;

      case PatternSymbol.square:
        _squareList.removeWhere((element) => element.id == item.id);
        debugPrint("Square removed: ${item.id}");
        break;

      case PatternSymbol.cross:
        _crossList.removeWhere((element) => element.id == item.id);
        debugPrint("Cross removed: ${item.id}");
        break;

      default:
        debugPrint("Something went wrong !!!");
        break;
    }

    _fibonacciList.add(item);
    _fibonacciList.sort((a, b) => a.id.compareTo(b.id));
    _fibonacciListController.sink.add(
      FibonacciListWrapper(
        _fibonacciList,
        _popItemId,
        _fibonacciList.indexOf(item),
      ),
    );
  }

  void addItemToList(FibonacciItem item) {
    switch (item.symbol) {
      case PatternSymbol.circle:
        _circleList.add(item);
        _circleList.sort((a, b) => a.id.compareTo(b.id));
        _circleListController.sink.add(
          FibonacciListWrapper(
            _circleList,
            item.id,
            _circleList.indexOf(item),
          ),
        );
        debugPrint("Circle added: ${item.id}");
        break;

      case PatternSymbol.square:
        _squareList.add(item);
        _squareList.sort((a, b) => a.id.compareTo(b.id));
        _squareListController.sink.add(
          FibonacciListWrapper(
            _squareList,
            item.id,
            _squareList.indexOf(item),
          ),
        );
        debugPrint("Square added: ${item.id}");
        break;

      case PatternSymbol.cross:
        _crossList.add(item);
        _crossList.sort((a, b) => a.id.compareTo(b.id));
        _crossListController.sink.add(
          FibonacciListWrapper(
            _crossList,
            item.id,
            _crossList.indexOf(item),
          ),
        );
        debugPrint("Cross added: ${item.id}");
        break;

      default:
        debugPrint("Something went wrong !!!");
        break;
    }

    _fibonacciList.removeWhere((element) => element.id == item.id);
    _fibonacciListController.sink.add(
      FibonacciListWrapper(
        _fibonacciList,
        _popItemId,
      ),
    );
  }

  void generateFibonacci(int count) {
    // Set limit to 100 Fibonacci numbers
    if (_fibonacciList.length +
            _circleList.length +
            _squareList.length +
            _crossList.length +
            count >
        ConfigValues.limitFibNumber) {
      debugPrint("Fibonacci list is full.");
      return;
    }

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

    _fibonacciListController.sink.add(
      FibonacciListWrapper(
        _fibonacciList,
        _popItemId,
      ),
    );
  }
}
