import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
import 'package:maplibre_gl/maplibre_gl.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
import 'package:maplibre_gl/maplibre_gl.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
import 'package:maplibre_gl/maplibre_gl.dart';
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
import 'package:maplibre_gl/maplibre_gl.dart';
=======
import 'package:google_maps_flutter/google_maps_flutter.dart';
 main
main
main
 main
import 'package:url_launcher/url_launcher.dart';

import '../../../core/location/location_service.dart';
import '../domain/map_models.dart';
import '../domain/map_repository.dart';
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
import '../../execution/presentation/execute_point_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
import '../../execution/presentation/execute_point_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
import '../../execution/presentation/execute_point_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
import '../../execution/presentation/execute_point_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
import '../../execution/presentation/execute_point_screen.dart';
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
import '../../execution/presentation/execute_point_screen.dart';
=======
 main
 main
 main
 main
 main
 main

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
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
  final Map<Symbol, PointItem> _pointSymbols = {};
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
  final Map<Symbol, PointItem> _pointSymbols = {};
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
  final Map<Symbol, PointItem> _pointSymbols = {};
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
  final Map<Symbol, PointItem> _pointSymbols = {};
=======
  Set<Marker> _markers = {};
 main
 main
 main
 main
  bool _isLoading = false;
  String? _error;
  double _currentZoom = 16;
  PointItem? _selectedPoint;
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
  MaplibreMapController? _mapController;
  Symbol? _userLocationSymbol;
  bool _symbolTapListenerSet = false;
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
  MaplibreMapController? _mapController;
  Symbol? _userLocationSymbol;
  bool _symbolTapListenerSet = false;
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
  MaplibreMapController? _mapController;
  Symbol? _userLocationSymbol;
  bool _symbolTapListenerSet = false;
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
  MaplibreMapController? _mapController;
  Symbol? _userLocationSymbol;
  bool _symbolTapListenerSet = false;
=======
  GoogleMapController? _mapController;
 main
 main
main
 main

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
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
      _updateUserMarker();
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
      _updateUserMarker();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
      _updateUserMarker();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
      _updateUserMarker();
=======
 main
 main
main
main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
        _selectedPoint = null;
      });
      await _clearPointSymbols();
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
        _selectedPoint = null;
      });
      await _clearPointSymbols();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
        _selectedPoint = null;
      });
      await _clearPointSymbols();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
        _selectedPoint = null;
      });
      await _clearPointSymbols();
=======
        _markers = {};
      });
main
main
main
main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
      await _renderPointSymbols(points, subactivity.formType);
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
      await _renderPointSymbols(points, subactivity.formType);
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
      await _renderPointSymbols(points, subactivity.formType);
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
      await _renderPointSymbols(points, subactivity.formType);
=======
      final markers = points.map((point) {
        final distance = _currentPosition == null
            ? double.infinity
            : _haversineDistance(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                point.lat,
                point.lng,
              );
        final showSgio = distance <= 25 && _currentZoom >= 18;
        final title = showSgio && (point.sgio ?? '').isNotEmpty
            ? point.sgio!
            : 'Punto ${point.id}';
        final infoSnippet = _buildInfoSnippet(point, sector.name);
        return Marker(
          markerId: MarkerId(point.id.toString()),
          position: LatLng(point.lat, point.lng),
          icon: _iconForFormType(subactivity.formType),
          infoWindow: InfoWindow(title: title, snippet: infoSnippet),
          onTap: () {
            setState(() {
              _selectedPoint = point;
            });
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
            _openExecution(point);
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
            _openExecution(point);
=======
 main
 main
          },
        );
      }).toSet();

      setState(() {
        _markers = markers;
      });
 main
 main
 main
main
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

codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
main
main
main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
=======
  String _buildInfoSnippet(PointItem point, String sectorName) {
    final lines = <String>[];
    if ((point.gis ?? '').isNotEmpty) {
      lines.add('GIS: ${point.gis}');
    }
    if ((point.suministro ?? '').isNotEmpty) {
      lines.add('Suministro: ${point.suministro}');
    }
    if ((point.direccion ?? '').isNotEmpty) {
      lines.add('Dirección: ${point.direccion}');
    }
    if ((point.locality ?? '').isNotEmpty) {
      lines.add('Localidad: ${point.locality}');
    }
    if ((point.district ?? '').isNotEmpty) {
      lines.add('Distrito: ${point.district}');
    }
    lines.add('Sector: $sectorName');
    return lines.join('\n');
  }

  BitmapDescriptor _iconForFormType(FormType type) {
    switch (type) {
      case FormType.purga:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case FormType.vpa:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case FormType.generic:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
 main
main
main
main
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

codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
main
main
main
main
main
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

codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-drar0n
=======
=======
 main
 main
 main
 main
 main
main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
    _updateSgioLabels();
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
    _updateSgioLabels();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
    _updateSgioLabels();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
    _updateSgioLabels();
=======
    _loadPoints();
 main
 main
 main
main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
              : MaplibreMap(
                  styleString: 'https://demotiles.maplibre.org/style.json',
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
              : MaplibreMap(
                  styleString: 'https://demotiles.maplibre.org/style.json',
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
              : MaplibreMap(
                  styleString: 'https://demotiles.maplibre.org/style.json',
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
              : MaplibreMap(
                  styleString: 'https://demotiles.maplibre.org/style.json',
=======
              : GoogleMap(
 main
 main
 main
 main
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition.latitude,
                      currentPosition.longitude,
                    ),
                    zoom: _currentZoom,
                  ),
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
=======
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
 main
 main
 main
 main
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  onMapCreated: (controller) {
                    _mapController = controller;
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
                    _updateUserMarker();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
                    _updateUserMarker();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
                    _updateUserMarker();
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
                    _updateUserMarker();
=======
 main
 main
 main
 main
                  },
                ),
        ),
        if (_selectedPoint != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-6intmf
 main
 main
 main
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
codex/initialize-project-scaffolding-for-fastapi-and-flutter-26hke3
=======
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-n79zkx
=======
codex/initialize-project-scaffolding-for-fastapi-and-flutter-viahdn
=======
=======
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Destino: ${_selectedPoint!.direccion ?? 'Sin dirección'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _openExternalNavigation(_selectedPoint!),
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navegar'),
 main
 main
 main
 main
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
