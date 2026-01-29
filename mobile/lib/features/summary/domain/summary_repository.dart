import '../data/summary_api.dart';
import 'summary_models.dart';

class SummaryRepository {
  final SummaryApi _api;

  SummaryRepository({SummaryApi? api}) : _api = api ?? SummaryApi();

  Future<SummaryData> getSummary({String? date}) {
    return _api.fetchSummary(date: date);
  }
}
