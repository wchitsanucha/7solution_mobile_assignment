import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/common/common_divider.dart';
import 'package:seven_solutions_mobile_assignment/common/common_list_tile.dart';
import 'package:seven_solutions_mobile_assignment/constant/colors.dart';
import 'package:seven_solutions_mobile_assignment/constant/numbers.dart';
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

  late final double _listTileHeight;

  void _onScrollEnd() {
    if (_mainScrollController.position.pixels ==
        _mainScrollController.position.maxScrollExtent) {
      // generate more Fibonacci numbers
      _viewModel.generateFibonacci(ConfigValues.generateFibNumber);
    }
  }

  @override
  void initState() {
    super.initState();

    _listTileHeight =
        (PlatformDispatcher.instance.views.first.physicalSize.longestSide /
                PlatformDispatcher.instance.views.first.devicePixelRatio) *
            ConfigValues.listTileHeightFactor;

    _viewModel = FibonacciViewModel();
    _mainScrollController = ScrollController();
    _modalCircleScrollController = ScrollController();
    _modalSquareScrollController = ScrollController();
    _modalCrossScrollController = ScrollController();

    _mainScrollController.addListener(_onScrollEnd);
    _viewModel.init();

    _subscribeStream();
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScrollEnd);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.appBar,
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
              _scrollToIndex(_mainScrollController, fibonacciList.itemIndex!);
            }

            return ListView.separated(
              controller: _mainScrollController,
              itemCount: fibonacciList.items.length,
              separatorBuilder: (_, __) => const CommonDivider(),
              itemBuilder: (context, index) {
                final FibonacciItem item = fibonacciList.items[index];

                return CommonListTile(
                  item: item,
                  listTileHeight: _listTileHeight,
                  onPressed: () => _viewModel.addItemToList(item),
                  highlightId: popItemId,
                  highlightColor: ColorStyle.popHighlight,
                );
              },
            );
          }
        },
      ),
    );
  }

  void _subscribeStream() {
    _circleStreamSubscription =
        _viewModel.circleListStream.listen((FibonacciListWrapper fibList) {
      _showModalList(fibList, _modalCircleScrollController);
      _scrollToIndex(_modalCircleScrollController, fibList.itemIndex!);
      debugPrint("circleListStream called");
    });

    _squareStreamSubscription =
        _viewModel.squareListStream.listen((FibonacciListWrapper fibList) {
      _showModalList(fibList, _modalSquareScrollController);
      _scrollToIndex(_modalSquareScrollController, fibList.itemIndex!);
      debugPrint("squareListStream called");
    });

    _crossStreamSubscription =
        _viewModel.crossListStream.listen((FibonacciListWrapper fibList) {
      _showModalList(fibList, _modalCrossScrollController);
      _scrollToIndex(_modalCrossScrollController, fibList.itemIndex!);
      debugPrint("crossListStream called");
    });
  }

  void _scrollToIndex(ScrollController controller, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        (index - ConfigValues.listTileOffset) * _listTileHeight,
        duration: const Duration(milliseconds: ConfigValues.durationTime),
        curve: Curves.easeInOut,
      );
    });
  }

  void _showModalList(
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
            separatorBuilder: (_, __) => const CommonDivider(),
            itemBuilder: (context, index) {
              final FibonacciItem item = fibList.items[index];

              return CommonListTile(
                item: item,
                listTileHeight: _listTileHeight,
                onPressed: () {
                  _viewModel.removeItemFromList(item);
                  Navigator.pop(context);
                  debugPrint("Remove idx back: $index => ${item.value}");
                },
                highlightId: fibList.selectedId,
                highlightColor: ColorStyle.pushHighlight,
              );
            },
          ),
        );
      },
    );
  }
}
