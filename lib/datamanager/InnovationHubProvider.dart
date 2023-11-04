import 'package:flutter/foundation.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

import 'InnovationHub.dart';


class InnovationHubProvider with ChangeNotifier {
  static List<InnovationHub> _mockupHubs = createMockupInnovationHubs();
  List<InnovationHub> _filteredHubs = _mockupHubs;

  List<InnovationHub> get mockupHubs => _mockupHubs;
  List<InnovationHub> get filteredHubs => _filteredHubs;

  void createFilterdHubList(List<InnovationHub> filteredHubs) {
    _filteredHubs = filteredHubs;
    notifyListeners();
  }

  static List<InnovationHub> createMockupInnovationHubs() {
    return [
      InnovationHub(
        id: '1',
        coordinates: LatLng(49.4710, 10.9876),
        category: 'university',
        name: 'Lehrstuhl Example 1',
        summary: 'Ein Hub für Forschung und Lehre an der Universität Fürth.',
        tags: ['Forschung', 'Lehre', 'Bildung'],
        code: '1234',
      ),
      InnovationHub(
        id: '2',
        coordinates: LatLng(49.4720, 10.9886),
        category: 'company',
        name: 'Unternehmen',
        summary: 'Ein Hub für Technologie und Innovation im Fürther Technologiezentrum.',
        tags: ['Technologie', 'Innovation', 'Wirtschaft'],
        code: '5678',
      ),
      InnovationHub(
        id: '3',
        coordinates: LatLng(49.4730, 10.9896),
        category: 'socialInstitution',
        name: 'Innovations Cafe',
        summary: 'Ein Hub für soziale Projekte und Gemeinschaftsarbeit in Fürth.',
        tags: ['Soziales', 'Gemeinschaft', 'Projekte'],
        code: '9101',
      ),
      InnovationHub(
        id: '4',
        coordinates: LatLng(49.4740, 10.9906),
        category: 'university',
        name: 'Lehstuhl Example 2',
        summary: 'Ein weiterer Hub für Forschung und Lehre an der Universität Fürth.',
        tags: ['Forschung', 'Lehre', 'Bildung'],
        code: '1121',
      ),
      InnovationHub(
        id: '5',
        coordinates: LatLng(49.4750, 10.9916),
        category: 'company',
        name: 'Unternehmen1',
        summary: 'Ein Hub für Startups und junge Unternehmen im Fürther Gründerzentrum.',
        tags: ['Startups', 'Unternehmertum', 'Innovation'],
        code: '1314',
      ),
      InnovationHub(
        id: '6',
        coordinates: LatLng(49.4760, 10.9926),
        category: 'socialInstitution',
        name: 'Soziale Einrichtung1',
        summary: 'Ein Hub für kulturelle Projekte und Veranstaltungen in Fürth.',
        tags: ['Kultur', 'Veranstaltungen', 'Projekte'],
        code: '1516',
      ),
    ];
  }
}