import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/location/location_service.dart';
import '../domain/map_models.dart';
import '../domain/map_repository.dart';
import '../../execution/presentation/execute_point_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapRepository = MapRepository();
  final _locationService = LocationService();

  final List<SectorOption> _sectors = const [
    SectorOption(id: 1, name: 'Sector 1'),
    SectorOption(id: 2, name: 'Sector 2'),
  ];

  final List<SubActivityOption> _subactivities = const [
    SubActivityOption(id: 1, name: 'Purga', formType: FormType.purga),
    SubActivityOption(id: 2, name: 'VPA', formType: FormType.vpa),
    SubActivityOption(id: 3, name: 'Genérico', formType: FormType.generic),
  ];

  SectorOption? _selectedSector;
  SubActivityOption? _selectedSubactivity;
  Position? _currentPosition;
  final Map<Symbol, PointItem> _pointSymbols = {};
  bool _isLoading = false;
  String? _error;
  double _currentZoom = 16;
  PointItem? _selectedPoint;
  MaplibreMapController? _mapController;
  Symbol? _userLocationSymbol;
  bool _symbolTapListenerSet = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final permission = await _locationService.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Permiso de ubicación denegado.';
        });
        return;
      }
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _updateUserMarker();
    } catch (err) {
      setState(() {
        _error = 'No se pudo obtener la ubicación: $err';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPoints() async {
    final sector = _selectedSector;
    final subactivity = _selectedSubactivity;
    if (sector == null || subactivity == null) {
      setState(() {
        _selectedPoint = null;
      });
      await _clearPointSymbols();
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final points = await _mapRepository.getPoints(
        sectorId: sector.id,
        subactivityId: subactivity.id,
      );
      await _renderPointSymbols(points, subactivity.formType);
    } catch (err) {
      setState(() {
        _error = 'Error al cargar puntos: $err';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _iconColorForFormType(FormType type) {
    switch (type) {
      case FormType.purga:
        return '#2196F3';
      case FormType.vpa:
        return '#FB8C00';
      case FormType.generic:
        return '#E53935';
    }
  }

  Future<void> _renderPointSymbols(
    List<PointItem> points,
    FormType formType,
  ) async {
    final controller = _mapController;
    if (controller == null) return;
    if (_pointSymbols.isNotEmpty) {
      await controller.removeSymbols(_pointSymbols.keys.toList());
      _pointSymbols.clear();
    }

    for (final point in points) {
      final showSgio = _shouldShowSgio(point);
      final symbol = await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(point.lat, point.lng),
          iconImage: 'marker-15',
          iconColor: _iconColorForFormType(formType),
          iconSize: 1.2,
          textField: showSgio ? point.sgio ?? '' : '',
          textOffset: const Offset(0, 1.2),
          textSize: 12,
        ),
        {},
      );
      _pointSymbols[symbol] = point;
    }

    setState(() {
      _selectedPoint = null;
    });

    if (!_symbolTapListenerSet) {
      controller.onSymbolTapped.add(_onSymbolTapped);
      _symbolTapListenerSet = true;
    }
  }

  Future<void> _clearPointSymbols() async {
    final controller = _mapController;
    if (controller == null) return;
    if (_pointSymbols.isNotEmpty) {
      await controller.removeSymbols(_pointSymbols.keys.toList());
      _pointSymbols.clear();
    }
  }

  bool _shouldShowSgio(PointItem point) {
    final distance = _currentPosition == null
        ? double.infinity
        : _haversineDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            point.lat,
            point.lng,
          );
    return distance <= 25 && _currentZoom >= 18 && (point.sgio ?? '').isNotEmpty;
  }

  void _onSymbolTapped(Symbol symbol) {
    final point = _pointSymbols[symbol];
    if (point == null) return;
    setState(() {
      _selectedPoint = point;
    });
    _openExecution(point);
  }

  Future<void> _updateSgioLabels() async {
    final controller = _mapController;
    if (controller == null) return;
    for (final entry in _pointSymbols.entries) {
      final showSgio = _shouldShowSgio(entry.value);
      await controller.updateSymbol(
        entry.key,
        SymbolOptions(textField: showSgio ? entry.value.sgio ?? '' : ''),
      );
    }
  }

  Future<void> _updateUserMarker() async {
    final controller = _mapController;
    final position = _currentPosition;
    if (controller == null || position == null) return;
    final location = LatLng(position.latitude, position.longitude);
    if (_userLocationSymbol != null) {
      await controller.updateSymbol(
        _userLocationSymbol!,
        SymbolOptions(geometry: location),
      );
      return;
    }
    _userLocationSymbol = await controller.addSymbol(
      SymbolOptions(
        geometry: location,
        iconImage: 'marker-15',
        iconColor: '#1976D2',
        iconSize: 1.3,
        textField: 'Yo',
        textOffset: const Offset(0, 1.2),
        textSize: 12,
      ),
      {},
    );
  }

  double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = pow(sin(dLat / 2), 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<void> _openExternalNavigation(PointItem point) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${point.lat},${point.lng}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps.')),
      );
    }
  }

  Future<void> _openExecution(PointItem point) async {
    final sector = _selectedSector;
    final subactivity = _selectedSubactivity;
    if (sector == null || subactivity == null) return;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ExecutePointScreen(
          point: point,
          sectorName: sector.name,
          subactivity: subactivity,
        ),
      ),
    );
    if (result == true) {
      _loadPoints();
    }
  }

  void _onSectorChanged(SectorOption? sector) {
    setState(() {
      _selectedSector = sector;
      _selectedPoint = null;
    });
    _loadPoints();
  }

  void _onSubactivityChanged(SubActivityOption? subactivity) {
    setState(() {
      _selectedSubactivity = subactivity;
      _selectedPoint = null;
    });
    _loadPoints();
  }

  void _onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  void _onCameraIdle() {
    _updateSgioLabels();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _currentPosition;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<SectorOption>(
                  value: _selectedSector,
                  decoration: const InputDecoration(labelText: 'Sector'),
                  items: _sectors
                      .map(
                        (sector) => DropdownMenuItem(
                          value: sector,
                          child: Text(sector.name),
                        ),
                      )
                      .toList(),
                  onChanged: _onSectorChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<SubActivityOption>(
                  value: _selectedSubactivity,
                  decoration: const InputDecoration(labelText: 'Subactividad'),
                  items: _subactivities
                      .map(
                        (subactivity) => DropdownMenuItem(
                          value: subactivity,
                          child: Text(subactivity.name),
                        ),
                      )
                      .toList(),
                  onChanged: _onSubactivityChanged,
                ),
              ),
            ],
          ),
        ),
        if (_isLoading) const LinearProgressIndicator(),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: currentPosition == null
              ? const Center(child: Text('Esperando ubicación...'))
              : MaplibreMap(
                  styleString: 'https://demotiles.maplibre.org/style.json',
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition.latitude,
                      currentPosition.longitude,
                    ),
                    zoom: _currentZoom,
                  ),
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _updateUserMarker();
                  },
                ),
        ),
        if (_selectedPoint != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((_selectedPoint!.gis ?? '').isNotEmpty)
                  Text('GIS: ${_selectedPoint!.gis}'),
                if ((_selectedPoint!.suministro ?? '').isNotEmpty)
                  Text('Suministro: ${_selectedPoint!.suministro}'),
                if ((_selectedPoint!.direccion ?? '').isNotEmpty)
                  Text('Dirección: ${_selectedPoint!.direccion}'),
                if ((_selectedPoint!.locality ?? '').isNotEmpty)
                  Text('Localidad: ${_selectedPoint!.locality}'),
                if ((_selectedPoint!.district ?? '').isNotEmpty)
                  Text('Distrito: ${_selectedPoint!.district}'),
                if (_selectedSector != null) Text('Sector: ${_selectedSector!.name}'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openExternalNavigation(_selectedPoint!),
                        icon: const Icon(Icons.navigation),
                        label: const Text('Navegar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
