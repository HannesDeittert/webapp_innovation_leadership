// Datei: detailed_hub_info_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DetailedHubInfo.dart';

class DetailedHubInfoProvider with ChangeNotifier {

  late DetailedHubInfo _detailedHubInfo;

  DetailedHubInfo get detailedHubInfo => _detailedHubInfo;

  // Methode zum Laden der DetailedHubInfo für einen gegebenen Code
  void loadDetailedHubInfo(String code) {
    // Mockup-Daten durchsuchen, um die DetailedHubInfo für den gegebenen Code zu finden
    _detailedHubInfo = _mockupDetailedHubInfos.firstWhere(
          (hub) => hub.code == code,
      orElse: () => DetailedHubInfo(
        code: '',
        name: 'Hub nicht gefunden',
        detailedDescription: 'Es wurden keine Informationen für den gegebenen Hub-Code gefunden.',
        headerImage: 'path/to/default/header/image.png',
      ),
    );
    notifyListeners();
  }

  // Mockup-Liste mit detaillierten Hub-Informationen
  static List<DetailedHubInfo> _mockupDetailedHubInfos = [
  DetailedHubInfo(
  code: '1234',
  name: 'Lehrstuhl Example 1',
  detailedDescription: 'Ein inspirierender Ort für Forschung und Lehre an der Universität Fürth.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  DetailedHubInfo(
  code: '5678',
  name: 'Unternehmen',
  detailedDescription: 'Ein Ort für Technologie und Innovation im Fürther Technologiezentrum.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  DetailedHubInfo(
  code: '9101',
  name: 'Innovations Cafe',
  detailedDescription: 'Ein gemütlicher Hub für soziale Projekte und Gemeinschaftsarbeit in Fürth.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  DetailedHubInfo(
  code: '1121',
  name: 'Lehstuhl Example 2',
  detailedDescription: 'Ein weiterer inspirierender Hub für Forschung und Lehre an der Universität Fürth.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  DetailedHubInfo(
  code: '1314',
  name: 'Unternehmen1',
  detailedDescription: 'Ein aufstrebender Hub für Startups und junge Unternehmen im Fürther Gründerzentrum.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  DetailedHubInfo(
  code: '1516',
  name: 'Soziale Einrichtung1',
  detailedDescription: 'Ein kultureller Hub für kulturelle Projekte und Veranstaltungen in Fürth.',
  headerImage: 'assets/images/zimt_header.jpeg',
  ),
  ];
}