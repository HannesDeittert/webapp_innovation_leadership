import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp_innovation_leadership/constants/colors.dart';
import 'package:webapp_innovation_leadership/datamanager/Events.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:webapp_innovation_leadership/datamanager/InnovationHub.dart';
import 'package:webapp_innovation_leadership/datamanager/Work.dart';
import 'package:webapp_innovation_leadership/widget/detailed_widget/ResearchDetailedSearch.dart';
import '../constants/colors.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/InnovationHubProvider.dart';

class ResearchListItem extends StatelessWidget {
  final HubWork Work;
  final double Lenght;
  final bool detail;



  ResearchListItem({required this.Work,required this.Lenght, required this.detail});




  @override
  Widget build(BuildContext context) {


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
                            future: _loadProfileImage(Work.TitleImage),
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
                          /*Positioned(
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
                              ))*/
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
                                    Text(
                                      Work.title,
                                      style: TextStyle(fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55)),
                                    ),
                                    Container(
                                      child: IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [

                                            Wrap(
                                              runSpacing: 5,
                                              spacing: MediaQuery.of(context).size.width * (16 / 1512),
                                              children: Work.tags.map((chip) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 2,
                                                      color: tBlue,
                                                    ),
                                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height *(22/982), ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                                    child: Center(
                                                      child: Text(

                                                        chip,

                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.w600,
                                                          color: tBlue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  width: Lenght*(900/1384),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * (125/1032),

                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      int maxLines = (constraints.maxHeight.isFinite ? constraints.maxHeight / 32 : 1).floor(); // 32 is the font size, adjust as needed
                                      return Text(
                                        Work.shortdescription,
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
                        String Code = detailedHubInfoProvider.detailedInnovationHub.code;
                        InnovationHub Hub = provider2.getInnovationHubByCode(Code);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResearchDetailedPage(Work,Hub)),
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