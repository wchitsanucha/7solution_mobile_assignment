import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';

class FibonacciListScreen extends StatefulWidget {
  const FibonacciListScreen({super.key});

  @override
  State<FibonacciListScreen> createState() => _FibonacciListScreenState();
}

class _FibonacciListScreenState extends State<FibonacciListScreen> {
  final List<FibonacciItem> _fibonacciList = <FibonacciItem>[];

  final List<FibonacciItem> _circleList = <FibonacciItem>[];
  final List<FibonacciItem> _squareList = <FibonacciItem>[];
  final List<FibonacciItem> _crossList = <FibonacciItem>[];

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _generateFibonacci(20); // Load 20 more when scrolled to the bottom
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    _generateFibonacci(40); // Generate first 40 Fibonacci numbers
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _generateFibonacci(int count) {
    setState(() {
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
    });
  }

  PatternSymbol _getSymbolByIndex(int index) {
    int patternIndex = (index ~/ 4) % 2; // Switch between pattern A and B
    int symbolIndex = index % 4; // Get symbol within the pattern

    // debugPrint("@@@ Index $index => $patternIndex, $symbolIndex");

    return PatternSet.patterns[patternIndex][symbolIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: const Text(
          'Fibonacci List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: _fibonacciList.length,
        separatorBuilder: (context, index) => const Divider(
          height: 0,
          indent: 14,
          endIndent: 14,
        ),
        itemBuilder: (context, index) {
          final FibonacciItem item = _fibonacciList[index];

          return ListTile(
            onTap: () {
              showModalListFilterBySymbol(item.symbol);
            },
            contentPadding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 16,
            ),
            tileColor: Colors.white,
            leading: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Text('${item.id + 1}'),
              ),
            ),
            title: Text('Number: ${item.value}'),
            trailing: Icon(
              PatternSet.getSymbol(item.symbol),
              color: Colors.blue[800],
            ),
          );
        },
      ),
    );
  }

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

  List<FibonacciItem>? getFibonacciItemListBySymbol(PatternSymbol symbol) {
    switch (symbol) {
      case PatternSymbol.circle:
        return _circleList;
      case PatternSymbol.square:
        return _squareList;
      case PatternSymbol.cross:
        return _crossList;
      default:
        return null;
    }
  }

  void showModalListFilterBySymbol(PatternSymbol symbol) {
    List<FibonacciItem>? fiboList = getFibonacciItemListBySymbol(symbol);

    if (fiboList == null) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          child: ListView.separated(
            itemCount: fiboList.length,
            separatorBuilder: (context, index) => const Divider(
              height: 0,
              indent: 14,
              endIndent: 14,
            ),
            itemBuilder: (context, index) {
              final FibonacciItem item = fiboList[index];

              return ListTile(
                onTap: () {
                  debugPrint("Remove idx: $index => ${item.value}");
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 16,
                ),
                tileColor: Colors.white,
                leading: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Text('${item.id + 1}'),
                  ),
                ),
                title: Text('Number: ${item.value}'),
                trailing: Icon(
                  PatternSet.getSymbol(item.symbol),
                  color: Colors.blue[800],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
