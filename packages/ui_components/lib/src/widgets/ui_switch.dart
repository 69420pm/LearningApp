import 'package:flutter/material.dart';

class UISwitch extends StatefulWidget {
  UISwitch({super.key, required this.onChanged, this.startValue = false, this.disabled=false}) {
    _isSwitched = startValue;
  }
  /// callback when switch gets changed
  void Function(bool)? onChanged;
  /// start value of switch
  final bool startValue;

  final bool disabled;

  bool _isSwitched = false;
  @override
  State<UISwitch> createState() => _UISwitchState();
}

class _UISwitchState extends State<UISwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      
      // activeColor: UIColors.background,
      // activeTrackColor: UIColors.primary,
      // inactiveThumbColor: UIColors.smallText,
      // inactiveTrackColor: UIColors.background,
      onChanged: widget.disabled ? null: (value) {
        setState(() {
          widget._isSwitched = value;
        }); 
        if(widget.onChanged != null){
        widget.onChanged!.call(value);

        }
      },
      value: widget._isSwitched,
    );
  }
}
