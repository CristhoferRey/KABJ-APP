import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/location/location_service.dart';
import '../domain/map_models.dart';
import '../domain/map_repository.dart';
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
import '../../execution/presentation/execute_point_screen.dart';
=======
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
  Set<Marker> _markers = {};
  bool _isLoading = false;
  String? _error;
  double _currentZoom = 16;
  PointItem? _selectedPoint;
  GoogleMapController? _mapController;

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
        _markers = {};
      });
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
 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
            _openExecution(point);
=======
 main
          },
        );
      }).toSet();

      setState(() {
        _markers = markers;
      });
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

 codex/initialize-project-scaffolding-for-fastapi-and-flutter-ra2stf
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

=======
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
    _loadPoints();
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
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition.latitude,
                      currentPosition.longitude,
                    ),
                    zoom: _currentZoom,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
        ),
        if (_selectedPoint != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
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
