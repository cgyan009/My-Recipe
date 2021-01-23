import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/base_model.dart';

class Spinner extends StatefulWidget {
  Spinner({
    Key key,
    this.models,
    this.stream,
    this.prices,
    this.spinnerStream,
    this.spinnerName,
    this.selectedInfo,
  }) : super(key: key);
  final List<String> defaultValue = ['Data Not Available'];
  final List<BaseModel> models;
  final Stream<List<BaseModel>> stream;
  final List<BaseModel> prices;
  final Stream<Map<String, bool>> spinnerStream;
  final String spinnerName;
  final Map<String, BaseModel> selectedInfo;

  @override
  _SpinnerState createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  List<BaseModel> _list = [BaseModel(1, 'Data Not Available')];
  int _selectedIndex = 0;

  FixedExtentScrollController scrollController;

  Widget _buildPicker(
    FixedExtentScrollController controller,
    BuildContext context,
  ) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.6,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: IgnorePointer(
        ignoring: true,
        child: CupertinoPicker(
          scrollController: controller,
          itemExtent: 32,
          backgroundColor: CupertinoColors.white,
          onSelectedItemChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: List<Widget>.generate(_list.length, (int index) {
            return Text(
              _list[index].name,
              textAlign: TextAlign.start,
            );
          }),
        ),
      ),
    );
  }

  void _loopUp() {
    if (_list.length == 1 || _selectedIndex >= _list.length - 1) {
      return;
    }
    _selectedIndex += 1;
    scrollController.animateToItem(
      _selectedIndex,
      duration: Duration(milliseconds: 20),
      curve: Curves.linear,
    );
    widget.selectedInfo[widget.spinnerName] = _list[_selectedIndex];
  }

  void _loopDown() {
    if (_list.length == 1 || _selectedIndex <= 0) {
      return;
    }
    _selectedIndex -= 1;
    scrollController.animateToItem(
      _selectedIndex,
      duration: Duration(milliseconds: 20),
      curve: Curves.linear,
    );
    widget.selectedInfo[widget.spinnerName] = _list[_selectedIndex];
  }

  void _handleSpinnerLoop(Map<String, bool> info) {
    if (info['direction']) {
      if (!info[widget.spinnerName]) {
        _loopUp();
      }
    } else {
      if (!info[widget.spinnerName]) {
        _loopDown();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.spinnerStream.listen(_handleSpinnerLoop);
  }

  @override
  Widget build(BuildContext context) {
    scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
    if (widget.prices != null) {
      _list = widget.prices;
      widget.selectedInfo[widget.spinnerName] = _list[_selectedIndex];
      return _buildPicker(scrollController, context);
    } else {
      return StreamBuilder<List<BaseModel>>(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Waiting ...');
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data.isNotEmpty) {
                _list = snapshot.data;
                widget.selectedInfo[widget.spinnerName] = _list[_selectedIndex];
              }
              return _buildPicker(scrollController, context);
          }
          return null;
        },
      );
    }
  }
}
