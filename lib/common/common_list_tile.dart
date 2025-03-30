import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/constant/colors.dart';
import 'package:seven_solutions_mobile_assignment/constant/pattern_symbol.dart';

import '../model/fibonacci_item.dart';

class CommonListTile extends StatelessWidget {
  const CommonListTile({
    super.key,
    required this.item,
    required this.listTileHeight,
    required this.onPressed,
    required this.highlightId,
    required this.highlightColor,
  });

  final FibonacciItem item;
  final double listTileHeight;
  final VoidCallback onPressed;
  final int? highlightId;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlightId == item.id ? highlightColor : null,
      height: listTileHeight,
      alignment: Alignment.center,
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 16,
        ),
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: ColorStyle.symbol,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: ColorStyle.listTile,
            child: Text('${item.id}'),
          ),
        ),
        title: Text('Number: ${item.value}'),
        trailing: Icon(
          PatternSet.getSymbol(item.symbol),
          color: ColorStyle.symbol,
        ),
      ),
    );
  }
}
