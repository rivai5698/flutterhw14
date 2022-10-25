import 'dart:async';

import 'package:flutterhw14/models/District.dart';
import 'package:flutterhw14/services/api_service.dart';
import 'package:flutterhw14/services/area_service.dart';

class DistrictBloc {
  final _districtStreamController = StreamController<List<District>>();
  Stream<List<District>> get streamDistrict => _districtStreamController.stream;

  DistrictBloc(int ctId) {
    getDistrict(ctId);
  }

  Future<void> closeStream() => _districtStreamController.close();
  List<District> listDis = [];
  bool isClosed(){
    return _districtStreamController.isClosed;
  }

  Future<void> getDistrict(int ctId) async {
    await Future.delayed(Duration.zero);
    await apiService.getDistrict(cityId: ctId).then((value) {
      _districtStreamController.add(value);
      listDis.addAll(value);
    }).catchError((e) {
      _districtStreamController.addError(e.toString());
    });
  }
}
