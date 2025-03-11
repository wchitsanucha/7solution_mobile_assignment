import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';
import 'package:seven_solutions_mobile_assignment/fibonacci_view_model.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';

class FibonacciListScreen extends StatefulWidget {
  const FibonacciListScreen({super.key});

  @override
  State<FibonacciListScreen> createState() => _FibonacciListScreenState();
}

class _FibonacciListScreenState extends State<FibonacciListScreen> {
  late final FibonacciViewModel _viewModel;
  late final ScrollController _scrollController;

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _viewModel.generateFibonacci(20); // generate more Fibonacci numbers
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel = FibonacciViewModel();
    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
    _viewModel.init();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    _viewModel.dispose();
    super.dispose();
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
      body: StreamBuilder<List<FibonacciItem>>(
        stream: _viewModel.fibonacciListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<FibonacciItem> fibonacciList = snapshot.data!;

            return ListView.separated(
              controller: _scrollController,
              itemCount: fibonacciList.length,
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                indent: 14,
                endIndent: 14,
              ),
              itemBuilder: (context, index) {
                final FibonacciItem item = fibonacciList[index];

                return ListTile(
                  onTap: () {
                    // showModalListFilterBySymbol(item.symbol);
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
            );
          }
        },
      ),
    );
  }

  // List<FibonacciItem>? getFibonacciItemListBySymbol(PatternSymbol symbol) {
  //   switch (symbol) {
  //     case PatternSymbol.circle:
  //       return _circleList;
  //     case PatternSymbol.square:
  //       return _squareList;
  //     case PatternSymbol.cross:
  //       return _crossList;
  //     default:
  //       return null;
  //   }
  // }

  // void showModalListFilterBySymbol(PatternSymbol symbol) {
  //   List<FibonacciItem>? fiboList = getFibonacciItemListBySymbol(symbol);

  //   if (fiboList == null) return;

  //   showModalBottomSheet<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 200,
  //         decoration: const BoxDecoration(
  //           color: Colors.amber,
  //           borderRadius: BorderRadius.vertical(
  //             top: Radius.circular(15),
  //           ),
  //         ),
  //         child: ListView.separated(
  //           itemCount: fiboList.length,
  //           separatorBuilder: (context, index) => const Divider(
  //             height: 0,
  //             indent: 14,
  //             endIndent: 14,
  //           ),
  //           itemBuilder: (context, index) {
  //             final FibonacciItem item = fiboList[index];

  //             return ListTile(
  //               onTap: () {
  //                 debugPrint("Remove idx: $index => ${item.value}");
  //               },
  //               contentPadding: const EdgeInsets.symmetric(
  //                 vertical: 3,
  //                 horizontal: 16,
  //               ),
  //               tileColor: Colors.white,
  //               leading: Container(
  //                 padding: const EdgeInsets.all(2),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.blue,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: CircleAvatar(
  //                   radius: 16,
  //                   backgroundColor: Colors.white,
  //                   child: Text('${item.id + 1}'),
  //                 ),
  //               ),
  //               title: Text('Number: ${item.value}'),
  //               trailing: Icon(
  //                 PatternSet.getSymbol(item.symbol),
  //                 color: Colors.blue[800],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
