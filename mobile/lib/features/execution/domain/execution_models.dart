enum ExecutionStatus { resuelto, imposibilidad, reprogramacion }

class ExecutionRequest {
  final int pointId;
  final ExecutionStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Map<String, dynamic>? formData;

  const ExecutionRequest({
    required this.pointId,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.formData,
  });

  Map<String, dynamic> toJson() {
    return {
      'point_id': pointId,
      'status': _statusToApi(status),
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'form_data': formData,
    };
  }

  String _statusToApi(ExecutionStatus status) {
    switch (status) {
      case ExecutionStatus.resuelto:
        return 'RESUELTO';
      case ExecutionStatus.imposibilidad:
        return 'IMPOSIBILIDAD';
      case ExecutionStatus.reprogramacion:
        return 'REPROGRAMACION';
    }
  }
}

class ExecutionResponseModel {
  final int id;
  final bool requiresEvidence;

  const ExecutionResponseModel({required this.id, required this.requiresEvidence});

  factory ExecutionResponseModel.fromJson(Map<String, dynamic> json) {
    return ExecutionResponseModel(
      id: json['id'] as int,
      requiresEvidence: json['requires_evidence'] as bool? ?? false,
    );
  }
}
