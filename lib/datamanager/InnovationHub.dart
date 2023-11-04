
import 'package:latlong2/latlong.dart';

class InnovationHub {
  final String id;
  final LatLng coordinates;
  final String category;
  final String name;
  final String summary;
  final List<String> tags;
  final String code;

  InnovationHub({
    required this.id,
    required this.coordinates,
    required this.category,
    required this.name,
    required this.summary,
    required this.tags,
    required this.code,
  });

}

