import 'package:flutter/material.dart';

typedef LockerChanged = Function(int index, bool isLocked);

class Locker extends StatefulWidget {
  final LockerChanged onLockerClicked;
  final int lockerIndex;

  const Locker({Key key, this.onLockerClicked, this.lockerIndex})
      : super(key: key);

  @override
  _LockerState createState() => _LockerState();
}

class _LockerState extends State<Locker> {
  bool _isLocked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isLocked = !_isLocked;
        });
        widget.onLockerClicked(widget.lockerIndex, _isLocked);
      },
      icon: _isLocked ? Icon(Icons.lock) : Icon(Icons.lock_open),
    );
  }
}
