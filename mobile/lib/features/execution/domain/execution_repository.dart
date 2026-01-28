import '../data/execution_api.dart';
import 'execution_models.dart';

class ExecutionRepository {
  final ExecutionApi _api;

  ExecutionRepository({ExecutionApi? api}) : _api = api ?? ExecutionApi();

  Future<ExecutionResponseModel> createExecution(ExecutionRequest request) {
    return _api.createExecution(request);
  }

  Future<void> uploadEvidence({
    required int executionId,
    required String deviceId,
    required String filePath,
  }) {
    return _api.uploadEvidence(
      executionId: executionId,
      deviceId: deviceId,
      filePath: filePath,
    );
  }
}
