import 'package:flutter/material.dart';

class Bubble {
  const Bubble(
      {this.title,
      required this.onPress,
      this.titleStyle,
      this.iconColor,
      this.bubbleColor,
      this.icon,
      required this.iconSize});

  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final Color? bubbleColor;
  final VoidCallback onPress;
  final String? title;
  final TextStyle? titleStyle;
}

class BubbleMenu extends StatelessWidget {
  const BubbleMenu(this.item, {Key? key}) : super(key: key);

  final Bubble item;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: CircleBorder(),
      padding: EdgeInsets.only(top: 11, bottom: 13, left: 32, right: 32),
      color: item.bubbleColor,
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.1),
      elevation: 2,
      highlightElevation: 2,
      disabledColor: item.bubbleColor,
      onPressed: item.onPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          item.icon != null
              ? Icon(
                  item.icon,
                  color: item.iconColor,
                  size: item.iconSize
                )
              : Container(),
        ],
      ),
    );
  }
}

class _DefaultHeroTag {
  const _DefaultHeroTag();
  @override
  String toString() => '<default FloatingActionBubble tag>';
}

class FloatingActionBubble extends AnimatedWidget {
  const FloatingActionBubble({
    required this.items,
    required this.onPress,
    this.iconColor,
    this.backGroundColor,
    required Animation animation,
    this.herotag,
    this.iconData,
    required this.iconSize,
    this.animatedIconData,
    required this.keyButton1,
  }) : assert((iconData == null && animatedIconData != null) ||
      (iconData != null && animatedIconData == null)),
        super(listenable: animation);

  final List<Bubble> items;
  final VoidCallback onPress;
  final AnimatedIconData? animatedIconData;
  final Object? herotag;
  final IconData? iconData;
  final Color? iconColor;
  final double iconSize;
  final Color? backGroundColor;
  final GlobalKey keyButton1;

  get _animation => listenable;
  

  Widget buildItem(BuildContext context, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

     final textDirection = Directionality.of(context);

    final animationDirection = textDirection == TextDirection.ltr ? -1 : 1;

    final transform = Matrix4.translationValues(
      animationDirection *
          (screenWidth - _animation.value * screenWidth) *
          ((items.length - index) / 4),
      0.0,
      0.0,
    );

    return Align(
      alignment: textDirection == TextDirection.ltr
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Transform(
        transform: transform,
        child: Opacity(
          opacity: _animation.value,
          child: BubbleMenu(items[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey keyButton = keyButton1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IgnorePointer(
          ignoring: _animation.value == 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: items.length,
            itemBuilder: buildItem,
          ),
        ),
        FloatingActionButton(
          heroTag: herotag == null ? const _DefaultHeroTag() : herotag,
          backgroundColor: backGroundColor,
          // iconData is mutually exclusive with animatedIconData
          // only 1 can be null at the time
          child: iconData == null && animatedIconData != null
              ? AnimatedIcon(
                  icon: animatedIconData!,
                  progress: _animation,
                )
              : Icon(
                  iconData,
                  color: iconColor,
                  size: iconSize,
                  key: keyButton,
                ),
          onPressed: onPress,
        ),
      ],
    );
  }
}
