import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ItemBuilder = Widget Function(
    BuildContext context, FloatingNavbarItem item);

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem>? items;
  final int? currentIndex;
  final void Function(int val)? onTap;
  final Color? selectedBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? fontSize;
  final double? iconSize;
  final double? itemBorderRadius;
  final double? borderRadius;
  final ItemBuilder? itemBuilder;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double width;
  final double? elevation;

  FloatingNavbar({
    super.key,
    @required this.items,
    @required this.currentIndex,
    @required this.onTap,
    ItemBuilder? itemBuilder,
    this.borderColor,
    this.backgroundColor = Colors.black,
    this.selectedBackgroundColor = Colors.white,
    this.selectedItemColor = Colors.black,
    this.iconSize = 24.0,
    this.fontSize = 11.0,
    this.borderRadius = 8,
    this.itemBorderRadius = 8,
    this.unselectedItemColor = Colors.white,
    this.margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    this.padding = const EdgeInsets.only(bottom: 8, top: 8),
    this.width = double.infinity,
    this.elevation = 0.0,
  })  : assert(items!.length > 1),
        assert(items!.length <= 5),
        assert(currentIndex! <= items!.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              unselectedItemColor: unselectedItemColor,
              selectedItemColor: selectedItemColor,
              borderRadius: borderRadius,
              fontSize: fontSize,
              width: width,
              backgroundColor: backgroundColor,
              currentIndex: currentIndex,
              iconSize: iconSize,
              itemBorderRadius: itemBorderRadius,
              items: items,
              onTap: onTap,
              selectedBackgroundColor: selectedBackgroundColor,
            );

  @override
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  List<FloatingNavbarItem> get items => widget.items!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // The main navbar container
        Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
          child: Container(
            padding: widget.padding,
            height: 60.0.h,
            margin: EdgeInsets.symmetric(horizontal: 0.w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                )
              ],
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
              color: widget.backgroundColor,
              border:
                  Border.all(color: widget.borderColor ?? Colors.transparent),
            ),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  return item.title == "Add"
                      ? const SizedBox() // Empty space where the "Add" item should be
                      : widget.itemBuilder!(context, item);
                }).toList(),
              ),
            ),
          ),
        ),

        // The Floating "Add" Button
        if (items.any((item) => item.title == "Add"))
          Positioned(
            bottom: 20, // Lift above the navbar
            child: widget.itemBuilder!(
              context,
              items.firstWhere((item) => item.title == "Add"),
            ),
          ),
      ],
    );
  }
}

// Default Item Builder
ItemBuilder _defaultItemBuilder({
  Function(int val)? onTap,
  List<FloatingNavbarItem>? items,
  int? currentIndex,
  Color? selectedBackgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
  Color? backgroundColor,
  double width = double.infinity,
  double? fontSize,
  double? iconSize,
  double? itemBorderRadius,
  double? borderRadius,
}) {
  return (BuildContext context, FloatingNavbarItem item) {
    bool isAddItem = item.title == "Add";

    return GestureDetector(
      onTap: () {
        onTap!(items!.indexOf(item));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isAddItem ? backgroundColor : Colors.transparent,
              shape: isAddItem ? BoxShape.circle : BoxShape.rectangle,
              border: isAddItem
                  ? Border.all(color: selectedItemColor as Color)
                  : Border.all(color: Colors.transparent),
              boxShadow: isAddItem
                  ? [
                      BoxShadow(
                        color: selectedItemColor!.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ]
                  : [],
            ),
            padding: isAddItem ? const EdgeInsets.all(10) : EdgeInsets.zero,
            child: item.customWidget ??
                Image.asset(
                  item.icon.toString(),
                  color: (currentIndex == items!.indexOf(item)
                      ? selectedItemColor
                      : unselectedItemColor),
                  height: isAddItem ? 40 : iconSize,
                  width: isAddItem ? 40 : iconSize,
                ),
          ),
          if (!isAddItem && item.title != null)
            Text(
              item.title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: currentIndex == items!.indexOf(item)
                    ? selectedItemColor
                    : unselectedItemColor,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
            ),
        ],
      ),
    );
  };
}

// Navbar Item Model
class FloatingNavbarItem {
  final String? title;
  final String? icon;
  final Widget? customWidget;

  FloatingNavbarItem({
    this.icon,
    this.title,
    this.customWidget,
  }) : assert(icon != null || customWidget != null);
}
