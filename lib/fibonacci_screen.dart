import 'dart:async';

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

  late StreamSubscription<List<FibonacciItem>> _circleStreamSubscription;
  late StreamSubscription<List<FibonacciItem>> _squareStreamSubscription;
  late StreamSubscription<List<FibonacciItem>> _crossStreamSubscription;

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

    _circleStreamSubscription =
        _viewModel.circleListStream.listen((List<FibonacciItem> items) {
      showModalList(items);
      debugPrint("circleListStream called");
    });

    _squareStreamSubscription =
        _viewModel.squareListStream.listen((List<FibonacciItem> items) {
      showModalList(items);
      debugPrint("squareListStream called");
    });

    _crossStreamSubscription =
        _viewModel.crossListStream.listen((List<FibonacciItem> items) {
      showModalList(items);
      debugPrint("crossListStream called");
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    _circleStreamSubscription.cancel();
    _squareStreamSubscription.cancel();
    _crossStreamSubscription.cancel();

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
          debugPrint("fibonacciListStream got update.");
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
                    _viewModel.addItemToList(item);
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

  void showModalList(List<FibonacciItem> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 0,
              indent: 14,
              endIndent: 14,
            ),
            itemBuilder: (context, index) {
              final FibonacciItem item = items[index];

              return ListTile(
                onTap: () {
                  debugPrint("Remove idx back: $index => ${item.value}");
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 16,
                ),
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
