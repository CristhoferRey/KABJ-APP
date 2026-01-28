import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/storage/device_id_storage.dart';
import '../../map/domain/map_models.dart';
import '../domain/execution_models.dart';
import '../domain/execution_repository.dart';

class ExecutePointScreen extends StatefulWidget {
  final PointItem point;
  final String sectorName;
  final SubActivityOption subactivity;

  const ExecutePointScreen({
    super.key,
    required this.point,
    required this.sectorName,
    required this.subactivity,
  });

  @override
  State<ExecutePointScreen> createState() => _ExecutePointScreenState();
}

class _ExecutePointScreenState extends State<ExecutePointScreen> {
  final _repository = ExecutionRepository();
  final _pressureController = TextEditingController();
  final _chlorineController = TextEditingController();
  final _observationsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ExecutionStatus? _status;
  String? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _loading = false;
  String? _evidencePath;

  @override
  void dispose() {
    _pressureController.dispose();
    _chlorineController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _pickEvidence() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _evidencePath = image.path;
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final time = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      if (isStart) {
        _startTime = time;
      } else {
        _endTime = time;
      }
    });
  }

  DateTime? _combineTime(TimeOfDay? time) {
    if (time == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Duration? _timeDifference() {
    final start = _combineTime(_startTime);
    final end = _combineTime(_endTime);
    if (start == null || end == null) return null;
    return end.difference(start);
  }

  String? _validateForm() {
    final status = _status;
    if (status == null) {
      return 'Selecciona un estado.';
    }

    if (widget.subactivity.formType == FormType.purga) {
      final pressure = double.tryParse(_pressureController.text);
      final chlorine = double.tryParse(_chlorineController.text);
      if (pressure == null || pressure < 10 || pressure > 200) {
        return 'Presión fuera de rango (10-200).';
      }
      if (chlorine == null || chlorine < 0.72 || chlorine > 1.20) {
        return 'Cloro fuera de rango (0.72-1.20).';
      }
      final duration = _timeDifference();
      if (duration == null) {
        return 'Selecciona hora inicio y fin.';
      }
      final minutes = duration.inMinutes;
      if (minutes < 5 || minutes > 20) {
        return 'Tiempo debe ser entre 5 y 20 minutos.';
      }
    }

    if (widget.subactivity.formType == FormType.vpa) {
      if (_selectedDay == null) {
        return 'Selecciona el día.';
      }
    }

    if (status == ExecutionStatus.resuelto && _evidencePath == null) {
      return 'La evidencia es obligatoria para RESUELTO.';
    }

    return null;
  }

  Map<String, dynamic>? _buildFormData() {
    switch (widget.subactivity.formType) {
      case FormType.purga:
        return {
          'presion': double.parse(_pressureController.text),
          'cloro': double.parse(_chlorineController.text),
          'hora_inicio': _startTime?.format(context),
          'hora_fin': _endTime?.format(context),
        };
      case FormType.vpa:
        return {
          'dia': _selectedDay,
          'observaciones': _observationsController.text.trim(),
        };
      case FormType.generic:
        return null;
    }
  }

  Future<void> _submit() async {
    final error = _validateForm();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final start = _combineTime(_startTime);
      final end = _combineTime(_endTime);
      final request = ExecutionRequest(
        pointId: widget.point.id,
        status: _status!,
        startedAt: start,
        endedAt: end,
        formData: _buildFormData(),
      );
      final response = await _repository.createExecution(request);

      if (_evidencePath != null) {
        final deviceId = await DeviceIdStorage.instance.getOrCreateDeviceId();
        await _repository.uploadEvidence(
          executionId: response.id,
          deviceId: deviceId,
          filePath: _evidencePath!,
        );
      } else if (response.requiresEvidence) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se requiere evidencia antes de cerrar.')),
        );
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ejecución registrada.')),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $err')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejecutar Punto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoCard(point: widget.point, sectorName: widget.sectorName, subactivity: widget.subactivity),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExecutionStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: const [
                DropdownMenuItem(
                  value: ExecutionStatus.resuelto,
                  child: Text('RESUELTO'),
                ),
                DropdownMenuItem(
                  value: ExecutionStatus.imposibilidad,
                  child: Text('IMPOSIBILIDAD'),
                ),
                DropdownMenuItem(
                  value: ExecutionStatus.reprogramacion,
                  child: Text('REPROGRAMACION'),
                ),
              ],
              onChanged: (value) => setState(() => _status = value),
            ),
            const SizedBox(height: 16),
            if (widget.subactivity.formType == FormType.purga) ...[
              TextField(
                controller: _pressureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Presión (10-200)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _chlorineController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Cloro (0.72-1.20)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(isStart: true),
                      child: Text(_startTime == null
                          ? 'Hora inicio'
                          : 'Inicio: ${_startTime!.format(context)}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(isStart: false),
                      child: Text(_endTime == null
                          ? 'Hora fin'
                          : 'Fin: ${_endTime!.format(context)}'),
                    ),
                  ),
                ],
              ),
            ],
            if (widget.subactivity.formType == FormType.vpa) ...[
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Día (cronograma)'),
                items: const [
                  DropdownMenuItem(value: 'Lunes', child: Text('Lunes')),
                  DropdownMenuItem(value: 'Martes', child: Text('Martes')),
                  DropdownMenuItem(value: 'Miércoles', child: Text('Miércoles')),
                  DropdownMenuItem(value: 'Jueves', child: Text('Jueves')),
                  DropdownMenuItem(value: 'Viernes', child: Text('Viernes')),
                  DropdownMenuItem(value: 'Sábado', child: Text('Sábado')),
                  DropdownMenuItem(value: 'Domingo', child: Text('Domingo')),
                ],
                onChanged: (value) => setState(() => _selectedDay = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _observationsController,
                decoration: const InputDecoration(labelText: 'Observaciones'),
                maxLines: 3,
              ),
            ],
            const SizedBox(height: 16),
            if (_status != ExecutionStatus.reprogramacion)
              OutlinedButton.icon(
                onPressed: _pickEvidence,
                icon: const Icon(Icons.camera_alt),
                label: Text(_evidencePath == null
                    ? 'Tomar evidencia'
                    : 'Evidencia seleccionada'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar ejecución'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final PointItem point;
  final String sectorName;
  final SubActivityOption subactivity;

  const _InfoCard({
    required this.point,
    required this.sectorName,
    required this.subactivity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SGIO: ${point.sgio ?? 'N/A'}'),
            const SizedBox(height: 4),
            Text('Dirección: ${point.direccion ?? 'N/A'}'),
            const SizedBox(height: 4),
            Text('Sector: $sectorName'),
            const SizedBox(height: 4),
            Text('Subactividad: ${subactivity.name}'),
          ],
        ),
      ),
    );
  }
}
