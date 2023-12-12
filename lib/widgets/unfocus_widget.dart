import 'package:flutter/material.dart';

class UnfocusWidget extends StatefulWidget {
  final Widget child;
  const UnfocusWidget({Key? key, required this.child}) : super(key: key);

  @override
  _UnfocusWidgetState createState() => _UnfocusWidgetState();
}

class _UnfocusWidgetState extends State<UnfocusWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: this.widget.child,
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,

      // onPanDown: (_) {
      //   FocusScope.of(context).requestFocus(FocusNode());
      // },
    );
  }

  _onTap(){
    setState(() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if(!currentFocus.hasPrimaryFocus){
        currentFocus.unfocus();
      }
    });
  }
}
