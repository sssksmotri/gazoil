import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class BottomBarIcon extends StatefulWidget {
  Function function;
  String name;
  bool isSelected;
  bool isDark;
  BottomBarIcon(
      {super.key, required this.name,
      required this.function,
      required this.isSelected,
      required this.isDark});

  @override
  State<BottomBarIcon> createState() => _BottomBarIconState();
}

class _BottomBarIconState extends State<BottomBarIcon> {
  Widget getIcon() {
    // функция для рендера корректной иконки
    return SvgPicture.asset(widget.isSelected
        ? 'icons/bottombaricons/selected/${widget.name}.svg'
        : widget.isDark
            ? 'icons/bottombaricons/dark/${widget.name}.svg'
            : 'icons/bottombaricons/bright/${widget.name}.svg');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.function(),
      child: getIcon(),
    );
  }
}
