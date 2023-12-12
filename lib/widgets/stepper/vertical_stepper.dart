import 'stepper_data.dart';
import 'stepper_dot.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

class VerticalStepperItem extends StatelessWidget {
  /// Stepper Item to show vertical stepper
  const VerticalStepperItem(
      {Key? key,
      required this.item,
      required this.index,
      required this.totalLength,
      required this.gap,
      required this.activeIndex,
      required this.isInverted,
      required this.activeBarColor,
      required this.inActiveBarColor,
      required this.barWidth,
      required this.dotWidget,
      required this.titleTextStyle,
      required this.subtitleTextStyle,
      required this.initialText,
      required this.isInitialText})
      : super(key: key);

  /// Stepper item of type [StepperData] to inflate stepper with data
  final StepperData item;

  final bool isInitialText;

  final StepperData? initialText;

  /// Index at which the item is present
  final int index;

  /// Total length of the list provided
  final int totalLength;

  /// Active index which needs to be highlighted and before that
  final int activeIndex;

  /// Gap between the items in the stepper
  final double gap;

  /// Inverts the stepper with text that is being used
  final bool isInverted;

  /// Bar color for active step
  final Color activeBarColor;

  /// Bar color for inactive step
  final Color inActiveBarColor;

  /// Bar width/thickness
  final double barWidth;

  /// [Widget] for dot/point
  final List<Widget> dotWidget;

  /// [TextStyle] for title
  final TextStyle titleTextStyle;

  /// [TextStyle] for subtitle
  final TextStyle subtitleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: isInverted ? getInvertedChildren() : getChildren(),
    );
  }

  List<Widget> getChildren() {
    return [
      Visibility(
        visible: isInitialText,
        child: Expanded(
          child: Column(
            crossAxisAlignment:
                isInverted ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              if (initialText?.title != null && initialText?.title != "") ...[
                Text(
                  initialText!.title!,
                  style: titleTextStyle,
                ),
              ],
              if (initialText?.subtitle != null &&
                  initialText?.subtitle != "") ...[
                const SizedBox(height: 8),
                Text(
                  initialText!.subtitle!,
                  textAlign: TextAlign.start,
                  style: subtitleTextStyle,
                ),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(width: 8),
      Column(
        children: [
          Container(
            color: index == 0
                ? Colors.transparent
                : (index <= activeIndex ? activeBarColor : inActiveBarColor),
            width: barWidth,
            height: gap,
          ),
          index <= activeIndex
              ? dotWidget.isNotEmpty
                  ? dotWidget[index]
                  : StepperDot(
                      index: index,
                      totalLength: totalLength,
                      activeIndex: activeIndex,
                    )
              : ColorFiltered(
                  colorFilter: Utils.getGreyScaleColorFilter(),
                  child: dotWidget.isNotEmpty
                      ? dotWidget[index]
                      : StepperDot(
                          index: index,
                          totalLength: totalLength,
                          activeIndex: activeIndex,
                        ),
                ),
          Container(
            color: index == totalLength - 1
                ? Colors.transparent
                : (index < activeIndex ? activeBarColor : inActiveBarColor),
            width: barWidth,
            height: gap,
          ),
        ],
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: isInitialText ? 5 : 1,
        child: Column(
          crossAxisAlignment:
              isInverted ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (item.title != null && item.title != "") ...[
              Text(
                item.title!,
                maxLines: 2,
              //  overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: titleTextStyle,
              ),
            ],
            if (item.subtitle != null && item.subtitle != "") ...[
              const SizedBox(height: 8),
              Text(
                item.subtitle!,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: subtitleTextStyle,
              ),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> getInvertedChildren() {
    return getChildren().reversed.toList();
  }
}
