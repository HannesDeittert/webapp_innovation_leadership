import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:webapp_innovation_leadership/datamanager/Events.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/InnovationHubProvider.dart';
import 'package:webapp_innovation_leadership/widget/detailed_widget/EventsDetailedPage.dart';
import 'package:webapp_innovation_leadership/widget/detailed_widget/EventsDetailedPageNoHub.dart';
import '../constants/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  final HubEvents Event;
  final double Lenght;
  final bool detail;
  final bool text;

  String weekdayToAbbreviation(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Invalid day';
    }
  }
  String formatTimeRange(DateTime startTime, DateTime endTime) {
    // Format für die Stunden im 12-Stunden-Format mit AM/PM
    final timeFormat = DateFormat.jm();

    // Formatieren Sie die Start- und Endzeiten
    final formattedStartTime = timeFormat.format(startTime);
    final formattedEndTime = timeFormat.format(endTime);

    // Kombinieren Sie die formatierten Zeiten in den gewünschten String
    final timeRangeString = '$formattedStartTime - $formattedEndTime';

    return timeRangeString;
  }

  EventListItem({required this.Event,required this.Lenght, required this.detail, required this.text});

  @override
  Widget build(BuildContext context) {
    String startday = Event.startTime.day.toString();
    String startMonth = Event.startTime.month.toString();
    String startYear = Event.startTime.year.toString();
    String starthour = Event.startTime.hour.toString();
    String startMin = Event.startTime.minute.toString();
    String endday = Event.endTime.day.toString();
    String endMonth = Event.endTime.month.toString();
    String endYear = Event.endTime.year.toString();
    String emdhour = Event.endTime.hour.toString();
    String endMin = Event.endTime.minute.toString();
    String Start = Event.startTime.toString();
    String End = Event.endTime.toString();
    String Cost = "Paid";
    String Day = weekdayToAbbreviation(Event.startTime.weekday);
    String timeRange = formatTimeRange(Event.startTime, Event.endTime);

    if (Event.free == true) {
      Cost = "Free";
    }

    if (startMonth == "1") {
      startMonth = "JAN";
    }
    if (startMonth == "2") {
      startMonth = "FEB";
    }
    if (startMonth == "3") {
      startMonth = "MRZ";
    }
    if (startMonth == "4") {
      startMonth = "APR";
    }
    if (startMonth == "5") {
      startMonth = "MAI";
    }
    if (startMonth == "6") {
      startMonth = "JUN";
    }
    if (startMonth == "7") {
      startMonth = "JUL";
    }
    if (startMonth == "8") {
      startMonth = "AUG";
    }
    if (startMonth == "9") {
      startMonth = "SPT";
    }
    if (startMonth == "10") {
      startMonth = "OKT";
    }
    if (startMonth == "11") {
      startMonth = "NOV";
    }
    if (startMonth == "12") {
      startMonth = "DEZ";
    }
    if (endMonth == "1") {
      endMonth = "JAN";
    }
    if (endMonth == "2") {
      endMonth = "FEB";
    }
    if (endMonth == "3") {
      endMonth = "MRZ";
    }
    if (endMonth == "4") {
      endMonth = "APR";
    }
    if (endMonth == "5") {
      endMonth = "MAI";
    }
    if (endMonth == "6") {
      endMonth = "JUN";
    }
    if (endMonth == "7") {
      endMonth = "JUL";
    }
    if (endMonth == "8") {
      endMonth = "AUG";
    }
    if (endMonth == "9") {
      endMonth = "SPT";
    }
    if (endMonth == "10") {
      endMonth = "OKT";
    }
    if (endMonth == "11") {
      endMonth = "NOV";
    }
    if (endMonth == "12") {
      endMonth = "DEZ";
    }
    String Detailed = "$Day, $startMonth $startday, $startYear";

    print(Detailed);
    print(timeRange);






    String Date =
        "SAVE THE DATE: $startday $startMonth $startYear, $starthour:$startMin CET";
    if (Event.startTime.difference(Event.endTime) > Duration(hours: 24)) {
      Date =
          "SAVE THE DATE: $startday $startMonth $startYear - $endday $endMonth $endYear  CET";
    }

    return Consumer<EventProvider>(
        builder: (context, provider, child) {
          if(detail == true){
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * (252/1032),
              width: Lenght,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: detail? tBackground : tWhite
              ),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .height * (41/982),
                        ),
                        // Hier kannst du das Profilbild anzeigen
                        Stack(
                          children: [
                            FutureBuilder(
                              future: _loadProfileImage(Event.eventImagePath),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10)),
                                    child: Image(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (200/1032),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (200/1032),
                                      image: snapshot.data as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                                }
                              },
                            ),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 68,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: tWhiteop
                                  ),
                                  child: Center(
                                    child: Text(
                                        Cost,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: tWritingGrey
                                        ),
                                        textAlign: TextAlign.center
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * (125/491),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (26/1032)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Container(
                                    width: Lenght - 10- MediaQuery
                                        .of(context)
                                        .size
                                        .height * (200/1032),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if(Event.title.length > 38)
                                          Text(

                                            Event.title.substring(0,38) +"...",
                                            style: TextStyle(fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if(Event.title.length <= 38)
                                          Text(
                                            Event.title,
                                            style: TextStyle(fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Spacer(),
                                        IntrinsicWidth(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    child: IntrinsicWidth(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.stretch,
                                                        children: [
                                                          Text(Date),
                                                          Divider(
                                                            thickness: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),Container(
                                    width: Lenght*(900/1384),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * (125/1032),

                                    child: LayoutBuilder(
                                      builder: (BuildContext context, BoxConstraints constraints) {
                                        int maxLines = (constraints.maxHeight.isFinite ? constraints.maxHeight / 32 : 1).floor(); // 32 is the font size, adjust as needed
                                        return Text(
                                          Event.description,
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                          ),
                                          maxLines: maxLines >2? 3:maxLines ,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .height * (41/982),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * (10 / 491),
                    right: MediaQuery.of(context).size.width * (10 / 491),
                    child: GestureDetector(
                      onTap: () async {
                        DetailedHubInfoProvider detailedHubInfoProvider =
                        Provider.of<DetailedHubInfoProvider>(context, listen: false);
                        InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context, listen: false);
                        InnovationHub Hub = provider2.getInnovationHubByCode(Event.HubCode);
                        await detailedHubInfoProvider.getHubInfoByCode(Event.HubCode,Hub.filtered_chips);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsDetailedPage(Event,timeRange,Detailed,Hub),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height*(29/491),
                        height: MediaQuery.of(context).size.height*(29/491),
                        decoration: BoxDecoration(
                            color: detail? tWhite: tBackground,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*(29/491))
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * (252/1032),
              width: Lenght,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: detail? tBackground : tWhite
              ),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .height * (41/982),
                        ),
                        // Hier kannst du das Profilbild anzeigen
                        Stack(
                          children: [
                            FutureBuilder(
                              future: _loadProfileImage(Event.eventImagePath),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10)),
                                    child: Image(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (200/1032),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (200/1032),
                                      image: snapshot.data as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return Container(); // Hier könnte ein Ladeindikator eingefügt werden
                                }
                              },
                            ),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  width: 68,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: tWhiteop
                                  ),
                                  child: Center(
                                    child: Text(
                                        Cost,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: tWritingGrey
                                        ),
                                        textAlign: TextAlign.center
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * (125/491),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (26/1032)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(text == false)
                                        if(Event.title.length > 38)
                                          Text(

                                            Event.title.substring(0,38) +"...",
                                            style: TextStyle(fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      if(text == false)
                                        if(Event.title.length <= 38)
                                          Text(
                                            Event.title,
                                            style: TextStyle(fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      if(text == true)
                                        Text(
                                          Event.title,
                                          style: TextStyle(fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      Spacer(),
                                      Container(
                                        child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                child: IntrinsicWidth(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                    children: [
                                                      Text(Date),
                                                      Divider(
                                                        thickness: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    width: Lenght*(9/10),
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * (125/1032),

                                    child: LayoutBuilder(
                                      builder: (BuildContext context, BoxConstraints constraints) {
                                        int maxLines = (constraints.maxHeight.isFinite ? constraints.maxHeight / 32 : 1).floor(); // 32 is the font size, adjust as needed
                                        return Text(
                                          Event.description,
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                          ),
                                          maxLines: maxLines >2? 3:maxLines ,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .height * (41/982),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * (10 / 491),
                    right: MediaQuery.of(context).size.width * (10 / 491),
                    child: GestureDetector(
                      onTap: () async {
                        DetailedHubInfoProvider detailedHubInfoProvider =
                        Provider.of<DetailedHubInfoProvider>(context, listen: false);
                        InnovationHubProvider provider2 = Provider.of<InnovationHubProvider>(context, listen: false);
                        InnovationHub Hub = provider2.innovationHubs[0];
                        if(Event.HubCode != ""){
                          Hub = provider2.getInnovationHubByCode(Event.HubCode);
                          await detailedHubInfoProvider.getHubInfoByCode(Event.HubCode,Hub.filtered_chips);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventsDetailedPage(Event,timeRange,Detailed,Hub),
                            ),
                          );
                        }
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventsDetailedPageNoHub(
                                      Event, timeRange, Detailed),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.height*(29/491),
                        height: MediaQuery.of(context).size.height*(29/491),
                        decoration: BoxDecoration(
                            color: detail? tWhite: tBackground,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*(29/491))
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
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
}