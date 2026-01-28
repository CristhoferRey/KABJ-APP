import '../data/map_api.dart';
import 'map_models.dart';

class MapRepository {
  final MapApi _mapApi;

  MapRepository({MapApi? mapApi}) : _mapApi = mapApi ?? MapApi();

  Future<List<PointItem>> getPoints({
    required int sectorId,
    required int subactivityId,
  }) {
    return _mapApi.fetchPoints(sectorId: sectorId, subactivityId: subactivityId);
  }
}
