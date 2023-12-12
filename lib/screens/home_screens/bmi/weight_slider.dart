import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../widgets/constants.dart';

class WeightSlider extends StatelessWidget {
  const WeightSlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.width,
    required this.value,
    required this.onChanged, required this.scrollController,
  })  :
        super(key: key);

  final int minValue;
  final int maxValue;
  final double width;

  double get itemExtent => width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  final int value;
  final ValueChanged<int> onChanged;

  final ScrollController scrollController;

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: const BouncingScrollPhysics(),
        // padding: EdgeInsets.symmetric(vertical: 1.h),
        itemBuilder: (BuildContext context, int index) {
          final int value = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? Container() //empty first and last element
              : Center(
                  child: Text(
                    value.toString(),
                    style: _getTextStyle(value),
                  ),
                );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      color: eUser().userTextFieldColor,
      fontFamily: eUser().userTextFieldFont,
      fontSize: eUser().userTextFieldHintFontSize,
    );
  }

  TextStyle _getHighlightTextStyle() {
    return TextStyle(
      color: eUser().mainHeadingColor,
      fontFamily: eUser().mainHeadingFont,
      fontSize: eUser().mainHeadingFontSize,
    );
  }

  TextStyle _getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle()
        : _getDefaultTextStyle();
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    return middleValue;
  }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration:  Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if(_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
}