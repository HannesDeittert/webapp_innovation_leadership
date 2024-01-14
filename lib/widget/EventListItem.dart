import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:webapp_innovation_leadership/datamanager/Events.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../constants/colors.dart';
import '../datamanager/EventProvieder.dart';

class EventListItem extends StatelessWidget {
  final HubEvents Event;
  final double Lenght;
  final bool detail;



  EventListItem({required this.Event,required this.Lenght, required this.detail});




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

    if(Event.free == true){
      Cost = "Free";
    }

    if(startMonth == "1"){
      startMonth = "JAN";
    }
    if(startMonth == "2"){
      startMonth = "FEB";
    }
    if(startMonth == "3"){
      startMonth = "MRZ";
    }
    if(startMonth == "4"){
      startMonth = "APR";
    }
    if(startMonth == "5"){
      startMonth = "MAI";
    }
    if(startMonth == "6"){
      startMonth = "JUN";
    }
    if(startMonth == "7"){
      startMonth = "JUL";
    }
    if(startMonth == "8"){
      startMonth = "AUG";
    }
    if(startMonth == "9"){
      startMonth = "SPT";
    }
    if(startMonth == "10"){
      startMonth = "OKT";
    }
    if(startMonth == "11"){
      startMonth = "NOV";
    }
    if(startMonth == "12"){
      startMonth = "DEZ";
    }
    if(endMonth == "1"){
      endMonth = "JAN";
    }
    if(endMonth == "2"){
      endMonth = "FEB";
    }
    if(endMonth == "3"){
      endMonth = "MRZ";
    }
    if(endMonth == "4"){
      endMonth = "APR";
    }
    if(endMonth == "5"){
      endMonth = "MAI";
    }
    if(endMonth == "6"){
      endMonth = "JUN";
    }
    if(endMonth == "7"){
      endMonth = "JUL";
    }
    if(endMonth == "8"){
      endMonth = "AUG";
    }
    if(endMonth == "9"){
      endMonth = "SPT";
    }
    if(endMonth == "10"){
      endMonth = "OKT";
    }
    if(endMonth == "11"){
      endMonth = "NOV";
    }
    if(endMonth == "12"){
      endMonth = "DEZ";
    }

    String Date = "SAVE THE DATE: $startday $startMonth $startYear, $starthour:$startMin CET";
    if(Event.startTime.difference(Event.endTime) > Duration(hours: 24)){
      Date = "SAVE THE DATE: $startday $startMonth $startYear - $endday $endMonth $endYear  CET";
    }


    return Consumer<EventProvider>(
        builder: (context, provider, child) {
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
                                      child: IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text(Date),
                                            Divider(
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: Lenght*(900/1384),
                                      child: Text(
                                        Event.title,
                                        style: TextStyle(fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: Lenght*(900/1384),
                                      child: Text(
                                        Event.description,
                                        style: TextStyle(fontSize: 32,
                                            color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
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
                  ],
          ),
              );
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