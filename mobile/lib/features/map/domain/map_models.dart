enum FormType { purga, vpa, generic }

class SectorOption {
  final int id;
  final String name;

  const SectorOption({required this.id, required this.name});
}

class SubActivityOption {
  final int id;
  final String name;
  final FormType formType;

  const SubActivityOption({
    required this.id,
    required this.name,
    required this.formType,
  });
}

class PointItem {
  final int id;
  final int subactivityId;
  final int sectorId;
  final String? sgio;
  final String? gis;
  final String? suministro;
  final String? direccion;
  final String? locality;
  final String? district;
  final double lat;
  final double lng;
  final bool needsEvidence;

  const PointItem({
    required this.id,
    required this.subactivityId,
    required this.sectorId,
    required this.sgio,
    required this.gis,
    required this.suministro,
    required this.direccion,
    required this.locality,
    required this.district,
    required this.lat,
    required this.lng,
    required this.needsEvidence,
  });

  factory PointItem.fromJson(Map<String, dynamic> json) {
    return PointItem(
      id: json['id'] as int,
      subactivityId: json['subactivity_id'] as int,
      sectorId: json['sector_id'] as int,
      sgio: json['sgio'] as String?,
      gis: json['gis'] as String?,
      suministro: json['suministro'] as String?,
      direccion: json['direccion'] as String?,
      locality: json['locality'] as String?,
      district: json['district'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      needsEvidence: json['needs_evidence'] as bool? ?? false,
    );
  }
}
