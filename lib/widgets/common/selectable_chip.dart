import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart';

class SelectableChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onSelectCallback;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelectCallback,
  });

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip>
    with SingleTickerProviderStateMixin {
  bool? wasSelected;
  late final AnimationController _controller = .new(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  static Color borderColor(bool selected) =>
      selected ? backgroundColor : mainColor;

  static Color containerColor(bool selected) =>
      selected ? mainColor : backgroundColor;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectableChip oldWidget) {
    if (oldWidget.isSelected == widget.isSelected) return;
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final borderColorTween = ColorTween(
      begin: borderColor(wasSelected ?? false),
      end: borderColor(widget.isSelected),
    );
    final containerColorTween = ColorTween(
      begin: containerColor(wasSelected ?? false),
      end: containerColor(widget.isSelected),
    );

    return GestureDetector(
      onTap: widget.onSelectCallback,
      child: Container(
        padding: EdgeInsets.all(smallSpacing),
        decoration: BoxDecoration(
          color: containerColorTween.lerp(_controller.value),
          border: Border.all(color: borderColorTween.lerp(_controller.value)!),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Text(
          widget.label,
          style: TextStyle(color: borderColorTween.lerp(_controller.value)!),
        ),
      ),
    );
  }
}
