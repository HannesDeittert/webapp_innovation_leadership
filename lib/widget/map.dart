import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../Homepage.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import '../datamanager/QuestionProvider.dart';
import '../datamanager/Questions.dart';
import '../datamanager/WorkProvider.dart';
import '../home.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'Map_Popup.dart';
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
  List<String> selected_all_tags = [];
  bool selected_yes = false;
  bool selected_no = false;
  String searchText = '';
  late final PopupController _popupController;

  @override
  void initState() {
    super.initState();
    _popupController = PopupController();
  }

  void setSelectedType(List<dynamic> value) {
    setState(() => selected_Type_tags = value.cast<String>());
  }
  void setSelectedCategory(List<dynamic> value) {
    setState(() => selected_Category_tags = value.cast<String>());
  }
  void setSelectedAll(List<dynamic> value) {
    setState(() => selected_all_tags = value.cast<String>());
  }
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  void clearTextField() {
    setState(() {
      textEditingController.clear();
    });
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
      // Überprüfe und füge nicht leere Elemente von `hub.question_topic` zu `tags` hinzu
      tags.addAll(hub.question_topic.where((topic) => topic.isNotEmpty));

      // Überprüfe und füge nicht leere Elemente von `hub.question_goal` zu `tags` hinzu
      tags.addAll(hub.question_goal.where((goal) => goal.isNotEmpty));
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
        List<Marker> _markers = filteredHubs.map((hub) {
          return Marker(
            point: hub.coordinates,
            child: Icon(_getIconForCategory(hub.category),
            size: 30,),
          );
        }).toList();
        int filterselected = selected_all_tags.length;

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
                          initialCenter: LatLng(49.47593, 10.98856),
                        onTap: (_, __) => _popupController.hideAllPopups(),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        // Erstellen Sie MarkerLayer dynamisch basierend auf der gefilterten Liste von InnovationHubs
                        PopupMarkerLayer(
                          options: PopupMarkerLayerOptions(
                            markerCenterAnimation: const MarkerCenterAnimation(),
                            markers: _markers,
                            popupController: _popupController,
                            markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                            popupDisplayOptions: PopupDisplayOptions(
                              builder: (BuildContext context, Marker marker) =>

                                  MapPopup(marker),
                              animation: PopupAnimation.fade(
                                  duration: Duration(milliseconds: 700)),

                            ),
                          ),
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
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*(1/63)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 21,
                            width: 21,
                            decoration: BoxDecoration(
                              color: Color(0xFF006BDC),
                              borderRadius: BorderRadius.all(Radius.circular(10.5))
                            ),
                            child: Center(
                              child: Text(
                                filterselected.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: tWhite
                                ),
                              ),
                            ),
                          ),

                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                for(InnovationHub hub in provider.innovationHubs){
                                  hub.filtered_chips.clear();
                                }
                                provider.createFilterdHubList(provider.innovationHubs);
                                selected_Type_tags = [];
                                selected_all_tags = [];
                                selected_Category_tags= [];
                                searchText = "";
                                selected_yes = false;
                                selected_no = false;
                                clearTextField();
                              });
                            },
                              child: Text(
                                "Reset All",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xFFC3C3C3)
                              ),
                              ))
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (10 / 982)
                      ),
                      Divider(
                        thickness: 1,
                        color: tSearch,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (11 / 982)
                      ),
                      ///SearchButton
                      Container(
                        height: MediaQuery.of(context).size.height * (55 / 982),
                        width: MediaQuery.of(context).size.width * (317 / 1512),
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * (27.5 / 982)),
                          color: tSearch,
                        ),
                        child: Center(
                          child: TextField(
                            controller: textEditingController,
                            onChanged: (text) {
                              setState(() {
                                searchText = text; // Update the variable when text changes
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_sharp, color: Colors.black),
                              hintText: "Search by name",
                              enabledBorder: InputBorder.none, // Remove the underline when not focused
                              focusedBorder: InputBorder.none,
                            ),

                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (11 / 982)
                      ),
                      Divider(
                        thickness: 1,
                        color: tSearch,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (11 / 982)
                      ),
                      ///TypeButton
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Location Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: tWritingGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: Category_tags.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected = selected_Category_tags.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      if (isSelected) {
                                        selected_all_tags.remove(item);
                                        selected_Category_tags.remove(item);
                                      } else {
                                        selected_all_tags.add(item);
                                        selected_Category_tags.add(item);
                                      }
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: Color(0xFF006BDC),
                                              ),
                                              child: Icon(Icons.check,color: tWhite,size: 20,),
                                            )
                                          else
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: tBackground,
                                                border: Border.all(
                                                  color: Color(0xFF006BDC), // Blue color for the border
                                                  width: 2, // Adjust the width as needed
                                                ),
                                              ),
                                            ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                            );
                          }).toList(),

                          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                          value: selected_Category_tags.isEmpty ? null : selected_Category_tags.last,
                          onChanged: (value) {},
                          selectedItemBuilder: (context) {
                            return Category_tags.map((item) {
                              return Container(
                                width: MediaQuery.of(context).size.width * (365 / 1512) - MediaQuery.of(context).size.width * (1 / 63),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  selected_Category_tags.join(', '),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              );
                            }).toList();
                          },
                          buttonStyleData: ButtonStyleData(
                            height: MediaQuery.of(context).size.height * (55 / 982),
                            width: MediaQuery.of(context).size.width * (317 / 1512),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * (27.5 / 982)),
                              color: tSearch,
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: tSearch,
                            iconDisabledColor: tSearch,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: MediaQuery.of(context).size.height * (400 / 982),
                            width: MediaQuery.of(context).size.width * (317 / 1512),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * (27.5 / 982)),
                              color: tSearch,
                            ),
                            offset: Offset(0, -MediaQuery.of(context).size.height * (6.875 / 982)),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),

                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (12 / 982)
                      ),
                      ///CategoryButton
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Category of Interest',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: tWritingGrey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: Type_tags.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected = selected_Type_tags.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      if (isSelected) {
                                        selected_all_tags.remove(item);
                                        selected_Type_tags.remove(item);
                                      } else {
                                        selected_all_tags.add(item);
                                        selected_Type_tags.add(item);
                                      }
                                      //This rebuilds the StatefulWidget to update the button's text
                                      setState(() {});
                                      //This rebuilds the dropdownMenu Widget to update the check mark
                                      menuSetState(() {});
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: Color(0xFF006BDC),
                                              ),
                                              child: Icon(Icons.check,color: tWhite,size: 20,),
                                            )
                                          else
                                            Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: tBackground,
                                                border: Border.all(
                                                  color: Color(0xFF006BDC), // Blue color for the border
                                                  width: 2, // Adjust the width as needed
                                                ),
                                              ),
                                            ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                            );
                          }).toList(),

                          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                          value: selected_Type_tags.isEmpty ? null : selected_Type_tags.last,
                          onChanged: (value) {},
                          selectedItemBuilder: (context) {
                            return Type_tags.map(
                                  (item) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    selected_Type_tags.join(', '),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              },
                            ).toList();
                          },
                          buttonStyleData: ButtonStyleData(
                            height: MediaQuery.of(context).size.height * (55 / 982),
                            width: MediaQuery.of(context).size.width * (317 / 1512),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * (27.5 / 982)),
                              color: tSearch,
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 14,
                            iconEnabledColor: tSearch,
                            iconDisabledColor: tSearch,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            ///ToDo: Optimize
                            maxHeight: MediaQuery.of(context).size.height * (150 / 982),
                            width: MediaQuery.of(context).size.width * (317 / 1512),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * (27.5 / 982)),
                              color: tSearch,
                            ),
                            offset: Offset(0, -MediaQuery.of(context).size.height * (6.875 / 982)),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),

                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (21 / 982)
                      ),
                      Text(
                        'Location is a part of FAU:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * (12 / 982)
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
                                  width: MediaQuery.of(context).size.height * (24 / 982),
                                  height: MediaQuery.of(context).size.height * (24 / 982),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_yes ? Colors.blue : Colors.white, // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Yes',style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * (24 / 982)
                          ),
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
                                  width: MediaQuery.of(context).size.height * (24 / 982),
                                  height: MediaQuery.of(context).size.height * (24 / 982),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_no ? Colors.blue : Colors.white, // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('No',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                ),),
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
                              filterInnoHubs(context, selected_Category_tags, selected_Type_tags, selected_yes,selected_no, searchText);
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
      case 'startup':
        return Icons.rocket;
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
                  await provider.getHubInfoByCode(hub.code,hub.filtered_chips);
                  await provider.getMenu();
                  provider2.calculate_recomendations(provider2.getInnovationHubByCode(hub.code));
                  await provider3.loadAllEvents();
                  await provider3.getEventListFromUidList(provider.detailedInnovationHub.events);
                  await provider4.loadAllHubworks();
                  await provider4.getHubworksListFromUidList(provider.detailedInnovationHub.work);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InnovationHubDetailPage(stringList: hub.filtered_chips,),
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

void filterByName(BuildContext context, String filterText) {
  if (filterText.isNotEmpty) {
    final String lowercaseFilter = filterText.toLowerCase();
    List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;
    List<InnovationHub> filtered = originalHubs
        .where((hub) => hub.name.toLowerCase().contains(lowercaseFilter))
        .toList();
    // Sortiere die gefilterte Liste nach der Übereinstimmung
    filtered.sort((a, b) => a.name.toLowerCase().indexOf(lowercaseFilter).compareTo(b.name.toLowerCase().indexOf(lowercaseFilter)));
    context.read<InnovationHubProvider>().createFilterdHubList(filtered);
  }
}

void filterInnoHubs(BuildContext context, List<dynamic> selected_Category_tags, List<dynamic> selected_Type_tags, bool yes, bool no,String text) {
  filterByName(context, text);
  // Get the original list of innovation hubs
  List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().filteredHubs;
  List<Map<InnovationHub, int>> filteredHubs = [];
  print(selected_Category_tags);
  print(selected_Type_tags);
  print(yes);
  print("filter");
  if(selected_Category_tags.length == 0 && selected_Type_tags.length == 0 && yes == false && no == false && text.isEmpty){
    List<InnovationHub> originalHubs = context.read<InnovationHubProvider>().innovationHubs;
    context.read<InnovationHubProvider>().createFilterdHubList(originalHubs);
  } else if(selected_Category_tags.length == 0 && selected_Type_tags.length == 0 && yes == false && no == false && !text.isEmpty){

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


