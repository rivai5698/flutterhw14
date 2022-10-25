import 'package:flutterhw14/models/City.dart';
import 'package:flutterhw14/models/District.dart';
import 'package:flutterhw14/services/api_service.dart';

extension AreaService on ApiService {
  Future<List<City>> getCity() async {
    final result = await request(path: '/cities',method: Method.get);
    final cities =
        List<City>.from(result.map((e) => City.fromJson(e)));
    return cities;
  }

  Future<List<District>> getDistrict({
      required int cityId,
  }) async {
    final result = await request(path: '/districts?cityId=$cityId');
    final district =
    List<District>.from(result.map((e) => District.fromJson(e)));
    return district;
  }

}
