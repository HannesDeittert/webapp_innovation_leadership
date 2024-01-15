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
        List<Marker> _markers = filteredHubs.map((hub) {
          return Marker(
            point: hub.coordinates,
            child: Icon(_getIconForCategory(hub.category),
            size: 30,),
          );
        }).toList();

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
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                for(InnovationHub hub in provider.innovationHubs){
                                  hub.filtered_chips.clear();
                                }
                                provider.createFilterdHubList(provider.innovationHubs);
                              });
                            },
                              child: Icon(Icons.filter_alt_off))
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
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.search_sharp,
                                size: MediaQuery.of(context).size.height * (24 / 982),
                                color: tWritingGrey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Search filter',
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
                          items: all_tags.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, menuSetState) {
                                  final isSelected = selected_all_tags.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      if (isSelected == true) {
                                        selected_all_tags.remove(item);
                                        if(selected_Category_tags.contains(item)){
                                          selected_Category_tags.remove(item);
                                        }
                                        if(selected_Type_tags.contains(item)){
                                          selected_Type_tags.remove(item);
                                        }
                                      }else{
                                        selected_all_tags.add(item);
                                        if(Category_tags.contains(item)){
                                          selected_Category_tags.add(item);
                                        }
                                        if(Type_tags.contains(item)){
                                          selected_Type_tags.add(item);
                                        }
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
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(Icons.check_box_outline_blank),
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
                          value: selected_all_tags.isEmpty ? null : selected_all_tags.last,
                          onChanged: (value) {},
                          selectedItemBuilder: (context) {
                            return all_tags.map(
                                  (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    selected_all_tags.join(', '),
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
                            maxHeight: MediaQuery.of(context).size.height * (300 / 982),
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
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50+MediaQuery.of(context).size.height * (20 / 982),
                            searchInnerWidget: Container(
                              height: 50+MediaQuery.of(context).size.height * (20 / 982),
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * (20 / 982),
                                left: MediaQuery.of(context).size.height * (10 / 982),
                                right: MediaQuery.of(context).size.height * (10 / 982),
                              ),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
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
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(Icons.check_box_outline_blank),
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
                          value: selected_Category_tags.isEmpty ? null : selected_Category_tags.last,
                          onChanged: (value) {},
                          selectedItemBuilder: (context) {
                            return Category_tags.map(
                                  (item) {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    selected_Category_tags.join(', '),
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
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(Icons.check_box_outline_blank),
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
                                  alignment: AlignmentDirectional.center,
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
                MaterialPageRoute(builder: (context) => MyHomePage()),
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


