import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';
import 'package:seven_solutions_mobile_assignment/fibonacci_view_model.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';
import 'package:seven_solutions_mobile_assignment/model/fibonacci_item_list.dart';

class FibonacciListScreen extends StatefulWidget {
  const FibonacciListScreen({super.key});

  @override
  State<FibonacciListScreen> createState() => _FibonacciListScreenState();
}

class _FibonacciListScreenState extends State<FibonacciListScreen> {
  late final FibonacciViewModel _viewModel;
  late final ScrollController _mainScrollController;
  late final ScrollController _modalCircleScrollController;
  late final ScrollController _modalSquareScrollController;
  late final ScrollController _modalCrossScrollController;

  late final StreamSubscription<FibonacciListWrapper> _circleStreamSubscription;
  late final StreamSubscription<FibonacciListWrapper> _squareStreamSubscription;
  late final StreamSubscription<FibonacciListWrapper> _crossStreamSubscription;

  late final double listTileHeight;

  void _onScroll() {
    if (_mainScrollController.position.pixels ==
        _mainScrollController.position.maxScrollExtent) {
      _viewModel.generateFibonacci(20); // generate more Fibonacci numbers
    }
  }

  @override
  void initState() {
    super.initState();

    listTileHeight =
        (PlatformDispatcher.instance.views.first.physicalSize.longestSide /
                PlatformDispatcher.instance.views.first.devicePixelRatio) *
            0.07;

    _viewModel = FibonacciViewModel();
    _mainScrollController = ScrollController();
    _modalCircleScrollController = ScrollController();
    _modalSquareScrollController = ScrollController();
    _modalCrossScrollController = ScrollController();

    _mainScrollController.addListener(_onScroll);
    _viewModel.init();

    _circleStreamSubscription =
        _viewModel.circleListStream.listen((FibonacciListWrapper fibList) {
      showModalList(fibList, _modalCircleScrollController);
      scrollToIndex(_modalCircleScrollController, fibList.itemIndex!);
      debugPrint("circleListStream called");
    });

    _squareStreamSubscription =
        _viewModel.squareListStream.listen((FibonacciListWrapper fibList) {
      showModalList(fibList, _modalSquareScrollController);
      scrollToIndex(_modalSquareScrollController, fibList.itemIndex!);
      debugPrint("squareListStream called");
    });

    _crossStreamSubscription =
        _viewModel.crossListStream.listen((FibonacciListWrapper fibList) {
      showModalList(fibList, _modalCrossScrollController);
      scrollToIndex(_modalCrossScrollController, fibList.itemIndex!);
      debugPrint("crossListStream called");
    });
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    _modalCircleScrollController.dispose();
    _modalSquareScrollController.dispose();
    _modalCrossScrollController.dispose();

    _circleStreamSubscription.cancel();
    _squareStreamSubscription.cancel();
    _crossStreamSubscription.cancel();

    _viewModel.dispose();
    super.dispose();
  }

  void scrollToIndex(ScrollController controller, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        (index - 2) * listTileHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
      body: StreamBuilder<FibonacciListWrapper>(
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
            final FibonacciListWrapper fibonacciList = snapshot.data!;
            final int? popItemId = fibonacciList.selectedId;

            if (fibonacciList.itemIndex != null) {
              scrollToIndex(_mainScrollController, fibonacciList.itemIndex!);
            }

            return ListView.separated(
              controller: _mainScrollController,
              itemCount: fibonacciList.items.length,
              separatorBuilder: (_, __) => const Divider(
                height: 0,
                indent: 14,
                endIndent: 14,
              ),
              itemBuilder: (context, index) {
                final FibonacciItem item = fibonacciList.items[index];

                return Container(
                  color: popItemId == item.id ? Colors.red : Colors.white,
                  height: listTileHeight,
                  alignment: Alignment.center,
                  child: ListTile(
                    onTap: () {
                      _viewModel.addItemToList(item);
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
                        child: Text('${item.id}'),
                      ),
                    ),
                    title: Text('Number: ${item.value}'),
                    trailing: Icon(
                      PatternSet.getSymbol(item.symbol),
                      color: Colors.blue[800],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void showModalList(
    FibonacciListWrapper fibList,
    ScrollController controller,
  ) {
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
            controller: controller,
            padding: const EdgeInsets.only(top: 16),
            itemCount: fibList.items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 0,
              indent: 14,
              endIndent: 14,
            ),
            itemBuilder: (context, index) {
              final FibonacciItem item = fibList.items[index];

              return Container(
                color: fibList.selectedId == item.id
                    ? Colors.greenAccent[400]
                    : null,
                height: listTileHeight,
                alignment: Alignment.center,
                child: ListTile(
                  onTap: () {
                    _viewModel.removeItemFromList(item);
                    Navigator.pop(context);
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
                      child: Text('${item.id}'),
                    ),
                  ),
                  title: Text('Number: ${item.value}'),
                  trailing: Icon(
                    PatternSet.getSymbol(item.symbol),
                    color: Colors.blue[800],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
