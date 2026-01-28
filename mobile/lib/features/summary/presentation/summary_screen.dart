import 'package:flutter/material.dart';

import '../domain/summary_models.dart';
import '../domain/summary_repository.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _repository = SummaryRepository();
  bool _loading = false;
  String? _error;
  SummaryData? _summary;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _loadSummary() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final summary = await _repository.getSummary(date: _formatDate(_selectedDate));
      setState(() {
        _summary = summary;
      });
    } catch (err) {
      setState(() {
        _error = 'Error al cargar resumen: $err';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    setState(() {
      _selectedDate = date;
    });
    _loadSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Diario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadSummary,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Fecha: ${_formatDate(_selectedDate)}'),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_summary != null) ...[
              _SummaryCard(
                title: 'Ejecutados hoy',
                value: _summary!.executedToday,
                color: Colors.green.shade100,
              ),
              const SizedBox(height: 12),
              _SummaryCard(
                title: 'Pendientes hoy',
                value: _summary!.pendingToday,
                color: Colors.orange.shade100,
              ),
            ],
            if (!_loading && _summary == null && _error == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Sin datos para mostrar.'),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(value.toString(), style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
