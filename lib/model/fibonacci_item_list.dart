import 'package:seven_solutions_mobile_assignment/model/fibonacci_item.dart';

class FibonacciListWrapper {
  final List<FibonacciItem> items;
  final int? selectedId;

  FibonacciListWrapper(
    this.items,
    this.selectedId,
  );
}
