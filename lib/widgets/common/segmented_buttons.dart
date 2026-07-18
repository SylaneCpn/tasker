import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tasker/widgets/common/selectable_chip.dart';

class SegmentedButtons extends StatelessWidget {
  final List<String> labels;
  final int? selectedIndex;
  final void Function(int)? onIndexSelected;
  const SegmentedButtons({
    super.key,
    required this.labels,
    this.selectedIndex,
    this.onIndexSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (labels.length <= 1) {
      throw ArgumentError(
        "Please provide at least 2 items for SelectedButtons",
      );
    }
    final [first, ...middle, last] = labels;
    return Row(
      mainAxisSize: .min,
      children: [
        SelectableChip(
          label: first,
          isSelected: selectedIndex == 0,
          onSelectCallback: () => onIndexSelected?.call(0),
          border: Border.all(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            bottomLeft: Radius.circular(24.0),
          ),
        ),
        ...middle.mapIndexed(
          (i, midLabel) => SelectableChip(
            label: midLabel,
            isSelected: selectedIndex == i + 1,
            onSelectCallback: () => onIndexSelected?.call(i + 1),
            border: Border(
              bottom: BorderSide(),
              top: BorderSide(),
              right: BorderSide(),
            ),
            borderRadius: BorderRadius.only(),
          ),
        ),
        SelectableChip(
          label: last,
          isSelected: selectedIndex == labels.length - 1,
          onSelectCallback: () => onIndexSelected?.call(labels.length - 1),
          border: Border(
              bottom: BorderSide(),
              top: BorderSide(),
              right: BorderSide(),
            ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
      ],
    );
  }
}
