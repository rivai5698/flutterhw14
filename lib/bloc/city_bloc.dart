import 'dart:async';

import 'package:flutterhw14/models/City.dart';
import 'package:flutterhw14/services/api_service.dart';
import 'package:flutterhw14/services/area_service.dart';

class CityBloc {
  final _cityStreamController = StreamController<List<City>>();
  Stream<List<City>> get streamCity => _cityStreamController.stream;
  CityBloc() {
    getCity();
  }

  Future<void> closeStream() => _cityStreamController.close();

  bool isClosed(){
    return _cityStreamController.isClosed;
  }

  Future<void> getCity() async {
    await Future.delayed(Duration.zero);
    await apiService.getCity().then((value) {
      _cityStreamController.add(value);
    }).catchError((e) {
      _cityStreamController.addError(e.toString());
      print(e);
    });
  }
}
