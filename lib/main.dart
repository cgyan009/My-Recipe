import 'package:flutter/material.dart';
import './blocs/location_bloc.dart';
import './screens/restaurant_list.dart';
import 'package:location/location.dart';

import 'blocs/main_bloc.dart';
import 'widgets/locker.dart';
import 'widgets/spinner_widget.dart';

void main() {
  runApp(
    MaterialApp(
      home: SuburbanSpoon(
        locationBloc: LocationBloc(),
      ),
    ),
  );
}

class SuburbanSpoon extends StatefulWidget {
  final locationBloc;


  const SuburbanSpoon({
    Key key,
    this.locationBloc,
  }) : super(key: key);

  @override
  _SuburbanSpoonState createState() => _SuburbanSpoonState();
}

class _SuburbanSpoonState extends State<SuburbanSpoon> with MainBloc {
  @override
  void dispose() {
    spinnerBloc.dispose();
    spinnerController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              FutureBuilder<LocationData>(
                  future: widget.locationBloc.currentLocation,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        var lat = snapshot.data.latitude;
                        var lon = snapshot.data.longitude;
                        controller.text = ('$lat,$lon');
                        loadData(
                          lat,
                          lon,
                        );
                      } else {
                        controller.text = 'Please enter latitude and longitude '
                            'data, splitted by ,';
                      }
                    }
                    return TextField(
                      style: TextStyle(fontSize: 18),
                      onSubmitted: (value) {
                        var trimmedTxt = value.trim();
                        if (trimmedTxt.isNotEmpty) {
                          var list = value.split(',');
                          var latStr = list[0];
                          var lonStr = list[1];
                          try {
                            var lat = double.parse(latStr.trim());
                            var lon = double.parse(lonStr.trim());
                            loadData(lat, lon);
                          } on FormatException catch (e) {
                            print(e);
                            controller.text = 'Invalid value, try again';
                          }
                        }
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Location',
                      ),
                    );
                  }),
              Row(
                children: <Widget>[
                  Spinner(
                    selectedInfo: selectedInfo,
                    spinnerName: 'city',
                    stream: spinnerBloc.cityStream,
                    spinnerStream: spinnerStream,
                  ),
                  Spinner(
                    selectedInfo: selectedInfo,
                    spinnerName: 'cuisine',
                    stream: spinnerBloc.cuisineStream,
                    spinnerStream: spinnerStream,
                  ),
                  Spinner(
                    selectedInfo: selectedInfo,
                    spinnerName: 'price',
                    spinnerStream: spinnerStream,
                    prices: prices,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Locker(lockerIndex: 0, onLockerClicked: clickLocker),
                  Locker(lockerIndex: 1, onLockerClicked: clickLocker),
                  Locker(lockerIndex: 2, onLockerClicked: clickLocker),
                ],
              ),
              Spacer(),
              Container(
                child: Row(),
                color: Colors.amberAccent,
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container(), flex: 1),
                  Expanded(
                    flex: 8,
                    child: FlatButton(
                      onPressed: () {
                        loopSpinner(true);
                      },
                      color: Colors.green,
                      child: Text('Up'),
                    ),
                  ),
                  Expanded(child: Container(), flex: 1)
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container(), flex: 1),
                  Expanded(
                    flex: 8,
                    child: FlatButton(
                      onPressed: () {
                        loopSpinner(false);
                      },
                      color: Colors.lime,
                      child: Text('Down'),
                    ),
                  ),
                  Expanded(child: Container(), flex: 1)
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Container(), flex: 1),
                  Expanded(
                    flex: 8,
                    child: FlatButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantList(
                              restaurants: searchedRestaurants,
                            ),
                          ),
                        );
                      },
                      color: Colors.lime,
                      child: Text('Show Restaurants'),
                    ),
                  ),
                  Expanded(child: Container(), flex: 1)
                ],
              ),
            ],
          ),
        ),
      ),
    ); /**/
  }
}
