import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart';

class LabeledBox extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDeactivated;
  final EdgeInsets? innerPadding;
  final VoidCallback? onSelectCallback;
  final BorderRadius? borderRadius;
  final Border? border;

  const LabeledBox({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelectCallback, this.borderRadius, this.border, this.innerPadding, required this.isDeactivated,
  });

  @override
  State<LabeledBox> createState() => _LabeledBoxState();
}

class _LabeledBoxState extends State<LabeledBox>
    with SingleTickerProviderStateMixin {
  bool? wasSelected;
  bool? wasDeactivated;
  late final AnimationController _controller = .new(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  static Color textColor({required bool selected , required bool deactivated}) =>
      deactivated ? backgroundColor :
      selected ? backgroundColor : mainColor;

  static Color containerColor({required bool selected , required bool deactivated}) =>
      deactivated ? deactivatedColor : selected ? mainColor : backgroundColor;

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
  void didUpdateWidget(covariant LabeledBox oldWidget) {
    if (oldWidget.isSelected == widget.isSelected) return;
    wasDeactivated = oldWidget.isDeactivated;
    wasSelected = oldWidget.isSelected;
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  Border _borderWithSidesOf(Border baseBorder, Color color ) {
    final top = baseBorder.top.copyWith(color: color);
    final bottom = baseBorder.bottom.copyWith(color: color);
    final left = baseBorder.left.copyWith(color: color);
    final right = baseBorder.right.copyWith(color: color);

    return Border(top: top, bottom: bottom, left: left, right: right);
  } 

  @override
  Widget build(BuildContext context) {
    final textColorTween = ColorTween(
      begin: textColor(selected:  wasSelected ?? false, deactivated: wasDeactivated ?? false),
      end: textColor(selected :widget.isSelected , deactivated:  widget.isDeactivated),
    );
    final containerColorTween = ColorTween(
      begin: containerColor(selected:  wasSelected ?? false , deactivated:  wasDeactivated ?? false),
      end: containerColor(selected : widget.isSelected , deactivated:  widget.isDeactivated),
    );
    final containerAnimColor = containerColorTween.lerp(_controller.value)!;
    final textAnimColor = textColorTween.lerp(_controller.value)!;

    return GestureDetector(
      onTap: widget.isDeactivated ? null : widget.onSelectCallback,
      child: Container(
        padding:widget.innerPadding ?? EdgeInsets.all(smallSpacing),
        decoration: BoxDecoration(
          color: containerAnimColor,
          border: widget.border != null ? _borderWithSidesOf(widget.border!, mainColor) : Border.all(color: mainColor),
          borderRadius:widget.borderRadius ?? BorderRadius.circular(24.0),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(color: textAnimColor,),
          ),
        ),
      ),
    );
  }
}