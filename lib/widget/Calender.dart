

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../Homepage.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/Events.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'EventPage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _Calender();
}

class _Calender extends State<Calender> {
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
    EventProvider provider3 = Provider.of<EventProvider>(context);
    List<HubEvents> events = provider3.allHubevents;
    List<String> tags = [];
    for (HubEvents Event in events) {
      tags.addAll(Event.tags);
    }
    Category_tags = tags.toSet().toList();
    tags = [];
    for (HubEvents Event in events) {
      tags.addAll(Event.Type);
    }
    Type_tags = tags.toSet().toList();
    all_tags = Category_tags + Type_tags;
    print(all_tags);
    print(Category_tags);

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        // Liste der gefilterten Hubs abrufen
        List<HubEvents> Filteredevents = provider3.filteredEvents;
        print(Filteredevents);
        return Stack(
          children: [
            Container(
              color: tBackground,
              child: Flexible(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * (365 / 1512),
                    ),
                    Expanded(
                        child: SfCalendar(
                          backgroundColor: tBackground,
                          view: CalendarView.week,
                          dataSource: AppointmentDataSource(provider3.filteredAppointment),
                          showNavigationArrow: true,
                          onTap: (CalendarTapDetails details) {
                            if (details.targetElement == CalendarElement.appointment) {
                              Appointment tappedAppointment = details.appointments![0];
                              Object? TapEvent = tappedAppointment.recurrenceId;
                              if (TapEvent is HubEvents) {
                                print(TapEvent);
                                // Handle the appointment tap event
                                showAppointmentDetails(context, TapEvent);
                              } else {
                                // Wenn TapEvent nicht vom Typ HubEvents ist, handle entsprechend
                                print('TapEvent ist nicht vom Typ HubEvents');
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width -
                  MediaQuery.of(context).size.width * (365 / 1512),
              child: Container(
                height: MediaQuery.of(context).size.height * (617 / 982),
                width: MediaQuery.of(context).size.width * (365 / 1512),
                decoration: BoxDecoration(
                  border: Border(),
                    color: tWhite,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.zero, right: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * (1 / 63)),
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
                          Spacer()
                        ],
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (10 / 982)),
                      Divider(
                        thickness: 1,
                        color: tSearch,
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (11 / 982)),

                      ///SearchButton
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Icon(
                                Icons.search_sharp,
                                size: MediaQuery.of(context).size.height *
                                    (24 / 982),
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
                                  final isSelected =
                                      selected_all_tags.contains(item);
                                  return InkWell(
                                    onTap: () {
                                      if (isSelected == true) {
                                        selected_all_tags.remove(item);
                                        if (selected_Category_tags
                                            .contains(item)) {
                                          selected_Category_tags.remove(item);
                                        }
                                        if (selected_Type_tags.contains(item)) {
                                          selected_Type_tags.remove(item);
                                        }
                                      } else {
                                        selected_all_tags.add(item);
                                        if (Category_tags.contains(item)) {
                                          selected_Category_tags.add(item);
                                        }
                                        if (Type_tags.contains(item)) {
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(
                                                Icons.check_box_outline_blank),
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
                          value: selected_all_tags.isEmpty
                              ? null
                              : selected_all_tags.last,
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
                            height:
                                MediaQuery.of(context).size.height * (55 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
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
                            maxHeight: MediaQuery.of(context).size.height *
                                (300 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
                              color: tSearch,
                            ),
                            offset: Offset(
                                0,
                                -MediaQuery.of(context).size.height *
                                    (6.875 / 982)),
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
                            searchInnerWidgetHeight: 50 +
                                MediaQuery.of(context).size.height * (20 / 982),
                            searchInnerWidget: Container(
                              height: 50 +
                                  MediaQuery.of(context).size.height *
                                      (20 / 982),
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    (20 / 982),
                                left: MediaQuery.of(context).size.height *
                                    (10 / 982),
                                right: MediaQuery.of(context).size.height *
                                    (10 / 982),
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
                              return item.value
                                  .toString()
                                  .contains(searchValue);
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
                          height:
                              MediaQuery.of(context).size.height * (11 / 982)),
                      Divider(
                        thickness: 1,
                        color: tSearch,
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (11 / 982)),

                      ///TypeButton
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Event Type',
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
                                  final isSelected =
                                      selected_Category_tags.contains(item);
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(
                                                Icons.check_box_outline_blank),
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
                          value: selected_Category_tags.isEmpty
                              ? null
                              : selected_Category_tags.last,
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
                            height:
                                MediaQuery.of(context).size.height * (55 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
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
                            maxHeight: MediaQuery.of(context).size.height *
                                (400 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
                              color: tSearch,
                            ),
                            offset: Offset(
                                0,
                                -MediaQuery.of(context).size.height *
                                    (6.875 / 982)),
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
                          height:
                              MediaQuery.of(context).size.height * (12 / 982)),

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
                                  final isSelected =
                                      selected_Type_tags.contains(item);
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            const Icon(Icons.check_box_outlined)
                                          else
                                            const Icon(
                                                Icons.check_box_outline_blank),
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
                          value: selected_Type_tags.isEmpty
                              ? null
                              : selected_Type_tags.last,
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
                            height:
                                MediaQuery.of(context).size.height * (55 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            padding: const EdgeInsets.only(left: 14, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
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
                            maxHeight: MediaQuery.of(context).size.height *
                                (150 / 982),
                            width: MediaQuery.of(context).size.width *
                                (317 / 1512),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      (27.5 / 982)),
                              color: tSearch,
                            ),
                            offset: Offset(
                                0,
                                -MediaQuery.of(context).size.height *
                                    (6.875 / 982)),
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
                          height:
                              MediaQuery.of(context).size.height * (21 / 982)),
                      Text(
                        'Event is a part of FAU:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (12 / 982)),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_yes =
                                    !selected_yes; // Umkehrung des aktuellen Status
                                if (selected_yes) {
                                  selected_no =
                                      false; // Wenn "Ja" ausgewählt ist, setzen Sie "Nein" auf nicht ausgewählt
                                }
                              });
                              // Hier können Sie zusätzliche Logik für die Auswahl von "Ja" implementieren
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height *
                                      (24 / 982),
                                  height: MediaQuery.of(context).size.height *
                                      (24 / 982),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_yes
                                        ? Colors.blue
                                        : Colors.white,
                                    // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  (24 / 982)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected_no =
                                    !selected_no; // Umkehrung des aktuellen Status
                                if (selected_no) {
                                  selected_yes =
                                      false; // Wenn "Nein" ausgewählt ist, setzen Sie "Ja" auf nicht ausgewählt
                                }
                              });
                              // Hier können Sie zusätzliche Logik für die Auswahl von "Nein" implementieren
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height *
                                      (24 / 982),
                                  height: MediaQuery.of(context).size.height *
                                      (24 / 982),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: selected_no
                                        ? Colors.blue
                                        : Colors.white,
                                    // Farbe basierend auf Auswahl ändern
                                    border: Border.all(
                                      color: Colors.grey, // Randfarbe
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'No',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
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
                            onTap: () {
                              filterEvents(
                                  context,
                                  selected_Category_tags,
                                  selected_Type_tags,
                                  selected_yes,
                                  selected_no);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *
                                  (60 / 982),
                              width: MediaQuery.of(context).size.width *
                                  (317 / 1512),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(
                                    (MediaQuery.of(context).size.height *
                                            (60 / 982)) /
                                        2,
                                  )),
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
              ),
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

void filterEvents(BuildContext context, List<dynamic> selected_Category_tags,
    List<dynamic> selected_Type_tags, bool yes, bool no) {
  // Get the original list of innovation hubs
  List<HubEvents> originalEvents = context.read<EventProvider>().allHubevents;
  List<Map<HubEvents, int>> filteredEvents = [];
  print(selected_Category_tags);
  print(selected_Type_tags);
  print(yes);
  print("filter");
  if (selected_Category_tags.length == 0 &&
      selected_Type_tags.length == 0 &&
      yes == false &&
      no == false) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Options Selected'),
        content: Text(
            "During the Filtering you have not selected an Filtering Option."),
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
    for (HubEvents Event in originalEvents) {
      int matchCount = 0;
      Event.filtered_chips.clear();
      // Calculate simmilarity for allSelectedItems_goal
      for (String tag in selected_Type_tags) {
        print(tag);
        if (Event.Type.contains(tag)) {
          matchCount++;
          Event.filtered_chips.add(tag);
        }
      }
      // Calculate simmilarity for allSelectedItems_category
      for (String tag in selected_Category_tags) {
        if (Event.tags.contains(tag)) {
          matchCount++;
          Event.filtered_chips.add(tag);
        }
      }
      if (yes == true) {
        if (Event.fau == true) {
          matchCount++;
          Event.filtered_chips.add("FAU Event");
        }
      }
      if (no == true) {
        if (Event.fau == false) {
          matchCount++;
          Event.filtered_chips.add("no FAU Event");
        }
      }

      // Add it to filtered Hubs
      filteredEvents.add({Event: matchCount});
    }

    // Sort filteredHubs by matchCount
    filteredEvents.sort((a, b) => b.values.first.compareTo(a.values.first));

    // Cut Hubs with 0 matchCount

    filteredEvents.removeWhere((entry) => entry.values.first == 0);

    // Create a List<InnovationHub> from the sorted List<Map>
    List<HubEvents> sortedEvents =
        filteredEvents.map((entry) => entry.keys.first).toList();

    // Call the createFilterdHubList function with the sorted and filtered filteredHubs list
    context.read<EventProvider>().createFilterdEventList(sortedEvents);
  }
}
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}


void showAppointmentDetails(BuildContext context, HubEvents HubEvent) {
  // Implement your logic to show details, e.g., a popup or navigate to a detailed view
  // For simplicity, I'm showing an AlertDialog with appointment details
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery
              .of(context)
              .size
              .height * (104 / 982),
          width: MediaQuery
              .of(context)
              .size
              .width * (350 / 1512),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              children: [
                FutureBuilder(
                  future: _loadProfileImage(HubEvent.eventImagePath ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * (72/982),
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * (72/982),
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
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * (12 / 1512),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(HubEvent.title, style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              DetailedHubInfoProvider provider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                              EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                              await provider3.loadAllEvents();
                              await provider3.selectEvent(HubEvent);
                              await provider.getHubInfoByCode(provider3.selHubevent.HubCode,provider3.selHubevent.filtered_chips);
                              print(provider3.selHubevent);
                              // Zur Detailseite navigieren
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text("Show Details", style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: tBlue
                                ),),
                                Icon(
                                  Icons.arrow_forward,
                                  color: tBlue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * (4 / 982),
                      ),
                      Text(
                        HubEvent.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
