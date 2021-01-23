import 'dart:async';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationBloc {
  
  final location = Location();

  Future<LocationData> get currentLocation async {
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      print(e.code);
    }
    return null;
  }
}
