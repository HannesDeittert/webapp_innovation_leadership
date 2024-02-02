import 'package:cached_network_image/cached_network_image.dart';
import 'package:choice/choice.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/widget/Calender.dart';
import 'package:webapp_innovation_leadership/widget/EventListItem.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import '../Constants/Colors.dart';
import '../Events.dart';
import '../Homepage.dart';
import '../InnovationGuide.dart';
import '../InnovationHubs.dart';
import '../datamanager/DetailedHubInfoProvider.dart';
import '../datamanager/EventProvieder.dart';
import '../datamanager/Events.dart';
import '../datamanager/WorkProvider.dart';
import '../login/login_screen.dart';

class GuideFinishedHome extends StatefulWidget {
  const GuideFinishedHome({Key? key}) : super(key: key);

  @override
  State<GuideFinishedHome> createState() => _GuideFinishedHome();
}

class _GuideFinishedHome extends State<GuideFinishedHome> {
  bool generating = false;
  bool isHomeViewSelected = false;
  bool isHubViewSelected = false;
  bool isEventViewSelected = false;
  bool isGuideViewSelected = true;
  bool isCommunityViewSelected = false;
  bool isDetailedViewSelected = false;
  int currentQuestionIndex = 0;
  List<String> questions = [
    "Are you from Fürth?",
    "What type of innovation location are you intrested in?",
    "What best matches your Intrests?"
  ];
  List<String> answerOptions_Furth = ["Yes", "No"];
  List<String> answerOptions_Type = [
    "University Chair",
    "StartUps",
    "Research Institutions",
    "Not Sure"
  ];
  final String imagePath = 'Images/FAU_INNOVATION_LOGO.png';
  List<String> answerOptions_topic = [
    "Information Technology / AI",
    "Business / Economics",
    "Sustainability",
    "Healthcare",
    "Education",
    "Research",
    "Automotive",
    "Mechanics",
    "Finance",
    "Insurance",
    "Social Science",
    "Creativity",
    "Communications",
    "Manufacturing",
    "FAU",
    "Sports"
  ];
  List<String> selectedAnswers_Furth = [];
  List<String> selectedAnswers_Type = [];
  List<String> selectedAnswers_topic = [];

  void setSelectedValue(List<String> value) {
    setState(() => selectedAnswers_topic = value);
  }
  Future<Widget> _loadImage(width,height,path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width,  // Ändere dies nach Bedarf
        height: height,  // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset('assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }

  String GetIndex() {
    List<List<String>> Arrays = [['Yes', 'StartUps',],['Yes', 'University Chair'],['No', 'StartUps'],['No', 'Not Sure'],['No', 'Research Institutions']];
    List<String> PathList = ['pdf/231117_Innovation_Lecture_upload.pdf', 'pdf/231117_Innovation_Lecture_upload.pdf','pdf/Exercise_2.pdf','pdf/InnoHikes Factsheet Promotion Hike 2.pdf','pdf/InnoHikes Factsheet Promotion Hike 2.pdf'];
    List<int> match = List.filled(Arrays.length, 0);
    List<int> matchInd =[];
    List<String?> filterTags= [selectedAnswers_Furth[0] , selectedAnswers_Type[0]];
    //filterTags.addAll(selectedAnswers_topic);
    print(filterTags);
    int counter = 0;
    for(List<String> List_ in Arrays){
      List<int> match =[];
      List<String> oneandtwo = [];
      oneandtwo.add(List_[0]);
      oneandtwo.add(List_[1]);
      String filterTagsString = filterTags.join(',');
      String PDFTagsString = oneandtwo.join(',');
      if(filterTagsString == PDFTagsString){
        matchInd.add(counter);
      }
      counter = counter+1;
    }
    for(int index in matchInd){
      List<String> compareArray = Arrays[index];
      for(String topic in selectedAnswers_topic){
        if(compareArray.contains(topic)){
          match[index] = match[index]+1;
        }
      }
    }
    int maxIndex = 0;
    int maxValue = match[0];

    for (int i = 1; i < match.length; i++) {
      if (match[i] > maxValue) {
        maxValue = match[i];
        maxIndex = i;
      }
    }
    return PathList[maxIndex];
  }


  Future<Widget> _loadLeadingImage(width, height) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();

      // Lade das Bild von der URL
      final imageWidget = Image.network(url);

      // Du kannst die Größe des Bildes anpassen, indem du eine `Container`-Umgebung verwendest
      return Container(
        width: width * 0.03248, // Ändere dies nach Bedarf
        height: height * 0.05, // Ändere dies nach Bedarf
        child: imageWidget,
      );
    } catch (e) {
      print('Fehler beim Laden des Bildes: $e');
      // Hier könntest du ein Standardbild zurückgeben oder eine Fehlermeldung anzeigen
      return Image.asset(
          'assets/placeholder_image.jpg'); // Beispiel für ein Standardbild
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current question based on the index
    String currentQuestion = questions[currentQuestionIndex];
    EventProvider provider3 = Provider.of<EventProvider>(context);
    List<HubEvents> fevents = provider3.filteredEvents;
    print("Hier$fevents");
    return Scaffold(
      backgroundColor: tBackground,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0155,
            ),
            Container(
              decoration: BoxDecoration(
                  color: tBackground,
                  border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color:  tBackground),
                  )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30,vertical: 0.0 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          FutureBuilder(
                            future: _loadLeadingImage(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // Wenn das Bild geladen wurde, zeige es an
                                return snapshot.data!;
                              } else if (snapshot.hasError) {
                                // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                                return Icon(Icons.error); // Hier könntest du eine andere Fehleranzeige verwenden
                              } else {
                                // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Text("innohub",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),)
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.455,
                      height: MediaQuery.of(context).size.height*0.062,
                      decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.031,)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InnovationHubs(),
                              ),
                            );
                          },
                            child: Text(
                              "Innovation hubs",
                              style: TextStyle(
                                  fontWeight: isHubViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Den DetailedHubInfoProvider vom Kontext abrufen
                              DetailedHubInfoProvider detailedHubInfoProvider = Provider.of<DetailedHubInfoProvider>(context, listen: false);
                              EventProvider provider3 = Provider.of<EventProvider>(context, listen:  false);
                              WorkProvider provider4 = Provider.of<WorkProvider>(context, listen:  false);
                              // _detailedHubInfo über die loadDetailedHubInfo-Methode initialisieren
                              await provider3.loadAllEvents();
                              await provider4.loadAllHubworks();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsHome()),
                              );
                            },
                            child: Text(
                              "Events",
                              style: TextStyle(
                                  fontWeight: isEventViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GuideHome()),
                              );
                            },
                            child: Text(
                              "Innovation Guide",
                              style: TextStyle(
                                  fontWeight: isGuideViewSelected ?FontWeight.w700: FontWeight.w500,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              "Community",
                              style: TextStyle(
                                  fontWeight: isCommunityViewSelected ?FontWeight.w700: FontWeight.w500,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 0,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child:
                Center(
                  child: Container(
                    width: 770,
                    height: 478,
                    child: Center(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: _loadImage(MediaQuery.of(context).size.height * (77 / 491),MediaQuery.of(context).size.height * (77 / 491),"Images/Storysetdump/3d-fluency-world-map 1.png"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // Wenn das Bild geladen wurde, zeige es an
                              return snapshot.data!;
                            } else if (snapshot.hasError) {
                              // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                              return Icon(Icons.error); // Hier könntest du eine andere Fehleranzeige verwenden
                            } else {
                              // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Spacer(),
                        Text("Congratulations on completing the quiz",style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),),
                        Text("Innovation Guide awaits! Explore unique insights and ideas crafted just for you.",style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 267,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * (60 / 982)) / 2,
                                )),
                            child: Center(
                              child: Text("Back to Home",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

    ],
                    )
            ),
                  ),
                )
            )
          ]),
    );
  }
}