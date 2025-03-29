import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';

class FibonacciListWrapper {
  final List<FibonacciItem> items;
  final int? selectedId;
  final int? itemIndex;

  FibonacciListWrapper(
    this.items,
    this.selectedId, [
    this.itemIndex,
  ]);
}
