import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';

import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/QuestionProvider.dart';
import '../datamanager/Questions.dart';
import '../datamanager/WorkProvider.dart';
import '../home.dart';
import 'innovationhubdetailpage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:side_sheet/side_sheet.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import 'package:choice/choice.dart';

class InnoMap extends StatefulWidget {
  const InnoMap({super.key});
  @override
  State<InnoMap> createState() => _InnoMap();
}

class _InnoMap extends State<InnoMap> {

  List<String> Type_tags = [];
  List<String> selected_Type_tags = [];
  List<String> Category_tags = [];
  List<String> selected_Category_tags = [];
  List<String> all_tags = [];
  List<String> aelected_all_tags = [];
  bool selected_yes = false;
  bool selected_no = false;

  void setSelectedType(List<dynamic> value) {
    setState(() => selected_Type_tags = value.cast<String>());
  }
  void setSelectedCategory(List<dynamic> value) {
    setState(() => selected_Category_tags = value.cast<String>());
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of Innovation Hubs from the InnovationHubProvider
    List<InnovationHub> innoHubs = Provider.of<InnovationHubProvider>(context).innovationHubs;

    List<String> tags = [];
    for (InnovationHub hub in innoHubs) {
      tags.addAll(hub.question_category);
    }
    Category_tags = tags.toSet().toList();
    tags = [];
    for (InnovationHub hub in innoHubs) {
      tags.addAll(hub.question_topic);
      tags.addAll(hub.question_goal);
    }
    Type_tags = tags.toSet().toList();
    all_tags = Category_tags + Type_tags;
    print(all_tags);
    print(Category_tags);

    return Consumer<InnovationHubProvider>(
      builder: (context, provider, child) {
        // Liste der gefilterten Hubs abrufen
        List<InnovationHub> filteredHubs = provider.filteredHubs;
        print(filteredHubs);

        return Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Flexible(
                    child: FlutterMap(
                      options: MapOptions(
                          cameraConstraint: CameraConstraint.contain(
                            bounds: LatLngBounds(
                              LatLng(49.135171, 10.515910),
                              LatLng(49.881752, 11.509370),
                            ),
                          ),
                          initialCenter: LatLng(49.47593, 10.98856)),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        // Erstellen Sie MarkerLayer dynamisch basierend auf der gefilterten Liste von InnovationHubs
                        MarkerLayer(
                          markers: filteredHubs.map((hub) {
                            return Marker(
                              point: hub.coordinates,
                              child: IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  // Zur Detailseite navigiere
                                  SideSheet.right(
                                    sheetBorderRadius: 10,
                                    context: context,
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    body: PopUPContentMap(context, hub)
                                  );
                                },
                                icon: Icon(_getIconForCategory(hub.category)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * (31/1967),
              right: MediaQuery.of(context).size.width * (475 / 491) - MediaQuery.of(context).size.width * (365 / 1512),
              child: Container(
                height:  MediaQuery.of(context).size.height * (586 / 982),
                width: MediaQuery.of(context).size.width * (365 / 1512),
                decoration: BoxDecoration(
                  color: tWhite,
                  borderRadius: BorderRadius.circular(20)
                ),
                child:
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Search Tags',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Choice<String>.inline(
                        multiple: true,
                        clearable: true,
                        itemCount: Category_tags.length,
                        value: selected_Category_tags,
                        onChanged: setSelectedCategory,
                        itemBuilder: (state, i) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: ChoiceChip(
                              selected: state.selected(Category_tags[i]),
                              onSelected: state.onSelected(Category_tags[i]),
                              label: Text(Category_tags[i]),
                            )
                          );
                        },
                        listBuilder: ChoiceList.createScrollable(
                          direction: Axis.horizontal,
                          spacing: 10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      InlineChoice<String>(
                        multiple: true,
                        clearable: true,
                            itemCount: Type_tags.length,
                            value: selected_Type_tags,
                            onChanged: setSelectedType,
                            itemBuilder: (state, i) {
                              return ChoiceChip(
                                selected: state.selected(Type_tags[i]),
                                onSelected: state.onSelected(Type_tags[i]),
                                label: Text(Type_tags[i]),
                              );
                            },
                        listBuilder: ChoiceList.createWrapped(
                          spacing: 10,
                          runSpacing: 10,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                        ),
                          ),
                      SizedBox(height: 16),
                      Text(
                        'Location is a part of FAU:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_yes = !selected_yes; // Umkehrung des aktuellen Status
                                if (selected_yes) {
                                  selected_no = false; // Wenn "Ja" ausgewählt ist, setzen Sie "Nein" auf nicht ausgewählt
                                }
                              });
                              // Hier können Sie zusätzliche Logik für die Auswahl von "Ja" implementieren
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_yes ? Colors.blue : Colors.white, // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Yes'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_no = !selected_no; // Umkehrung des aktuellen Status
                                if (selected_no) {
                                  selected_yes = false; // Wenn "Nein" ausgewählt ist, setzen Sie "Ja" auf nicht ausgewählt
                                }
                              });
                              // Hier können Sie zusätzliche Logik für die Auswahl von "Nein" implementieren
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_no ? Colors.blue : Colors.white, // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('No'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              filterInnoHubs(context, selected_Category_tags, selected_Type_tags, selected_yes,selected_no);
                            },
                            child: Container(
                              height:  MediaQuery.of(context).size.height * (60 / 982),
                              width: MediaQuery.of(context).size.width * (317/ 1512),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular((MediaQuery.of(context).size.height * (60 / 982))/2,)
                              ),
                              child: Center(
                                child: Text(
                                  'Display',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'university':
        return Icons.school;
      case 'company':
        return Icons.business;
      case 'socialInstitution':
        return Icons.group;
      default:
        return Icons.info;
    }
  }
}

  Widget PopUPContentMap(BuildContext context, InnovationHub hub) {

    return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _loadProfileImage(hub.profileImagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.width*0.18,
                            width: MediaQuery.of(context).size.width*0.18,
                            child: Image(
                              image: snapshot.data as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    // Name
                    Text(
                      hub.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Summary
              Text(
                hub.summary,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey,),
              ),
              // Chips
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: hub.filtered_chips.map((chip) {
                  return Chip(
                    label: Text(chip),
                  );
                }).toList(),
              ),
              // Show More Button
              GestureDetector(
                onTap: () async {
                  DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                  InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context, listen: false);
                  EventProvider provider3 = Provider.of<EventProvider>(context, listen: false);
                  WorkProvider provider4 = Provider.of<WorkProvider>(context, listen: false);
                  await provider.getHubInfoByCode(hub.code);
                  await provider.getMenu();
                  provider2.calculate_recomendations(provider2.getInnovationHubByCode(hub.code));
                  await provider3.loadAllEvents();
                  await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
                  await provider4.loadAllHubworks();
                  await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InnovationHubDetailPage(),
                    ),
                  );
                },
                child: Text(
                  'Show More',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
    );
  }



Future<ImageProvider> _loadProfileImage(String path) async {
  try {
    final ref = firebase_storage.FirebaseStorage.instance.ref(path);
    final url = await ref.getDownloadURL();
    return NetworkImage(url);
  } catch (e) {
    // Fehlerbehandlung, wenn das Bild nicht geladen werden kann
    print('Fehler beim Laden des Profilbildes: $e');
    return AssetImage('assets/placeholder_image.jpg');
  }
}

void filterInnoHubs(BuildContext context, List<dynamic> selected_Category_tags, List<dynamic> selected_Type_tags, bool yes, bool no) {
  // Get the original list of innovation hubs
  List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;
  List<Map<InnovationHub, int>> filteredHubs = [];
  print(selected_Category_tags);
  print(selected_Type_tags);
  print(yes);
  print("filter");
  if(selected_Category_tags.length == 0 && selected_Type_tags.length == 0 && yes == false && no == false){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Options Selected'),
        content: Text("During the Filtering you have not selected an Filtering Option."),
        actions: [
          TextButton(
            child: const Text('Let´s restart!'),
            onPressed: () {
              ///ToDo: implement logic to set qurrentQuestionIndex to 0
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Let´s go Home'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ],
      ),
    );
  } else {
    for (InnovationHub Hub in originalHubs) {
      int matchCount = 0;
      Hub.filtered_chips.clear();
      // Calculate simmilarity for allSelectedItems_goal
      for (String tag in selected_Type_tags) {
        print(tag);
        if (Hub.question_goal.contains(tag)) {
          matchCount++;
          Hub.filtered_chips.add(tag);
        }
        if (Hub.question_topic.contains(tag)) {
          matchCount++;
          Hub.filtered_chips.add(tag);
        }
      }
      // Calculate simmilarity for allSelectedItems_category
      for (String tag in selected_Category_tags) {
        if (Hub.question_category.contains(tag)) {
          matchCount++;
          Hub.filtered_chips.add(tag);
        }
      }
      if(yes == true){
        if(Hub.fau == true){
          matchCount++;
          Hub.filtered_chips.add("FAU Hub");
        }
      }
      if(no == true){
        if(Hub.fau == false){
          matchCount++;
          Hub.filtered_chips.add("no FAU Hub");
        }
      }

      // Add it to filtered Hubs
      filteredHubs.add({Hub: matchCount});
    }

    // Sort filteredHubs by matchCount
    filteredHubs.sort((a, b) => b.values.first.compareTo(a.values.first));

    // Cut Hubs with 0 matchCount

    filteredHubs.removeWhere((entry) => entry.values.first == 0);

    // Create a List<InnovationHub> from the sorted List<Map>
    List<InnovationHub> sortedHubs = filteredHubs.map((entry) =>
    entry.keys.first).toList();

    // Call the createFilterdHubList function with the sorted and filtered filteredHubs list
    context.read<InnovationHubProvider>().createFilterdHubList(sortedHubs);
  }
}


