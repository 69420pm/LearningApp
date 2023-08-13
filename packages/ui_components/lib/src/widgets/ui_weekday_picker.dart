import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class UIWeekdayPicker extends StatefulWidget {
  UIWeekdayPicker({super.key});

  @override
  State<UIWeekdayPicker> createState() => _UIWeekdayPickerState();
  final children = [
    _WeekDay(
      text: 'Mon',
      numToAdd: 1000000,
    ),
    _WeekDay(
      text: 'Tue',
      numToAdd: 100000,
    ),
    _WeekDay(
      text: 'Wed',
      numToAdd: 10000,
    ),
    _WeekDay(
      text: 'Thu',
      numToAdd: 1000,
    ),
    _WeekDay(
      text: 'Fri',
      numToAdd: 100,
    ),
    _WeekDay(
      text: 'Sat',
      numToAdd: 10,
    ),
    _WeekDay(
      text: 'Sun',
      numToAdd: 1,
    ),
  ];
  int getSelectedDays() {
    var selectedDays = 0;
    children.forEach((element) {
      selectedDays += element.currentNum;
    });
    return selectedDays;
  }
}

class _UIWeekdayPickerState extends State<UIWeekdayPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.children);
  }
}

class _WeekDay extends StatefulWidget {
  _WeekDay({super.key, required this.text, required this.numToAdd});

  String text;
  int numToAdd;
  int currentNum = 0;
  bool isSelected = false;

  @override
  State<_WeekDay> createState() => _WeekDayState();
}

class _WeekDayState extends State<_WeekDay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(UIConstants.cornerRadiusSmall),
          ),
          color: widget.isSelected ? UIColors.primary : UIColors.onOverlayCard,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: widget.isSelected
                ? UIText.normalBold.copyWith(color: UIColors.textDark)
                : UIText.normal,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        if (widget.isSelected) {
          widget.currentNum = widget.numToAdd;
        } else {
          widget.currentNum = 0;
        }
      },
    );
  }
}
