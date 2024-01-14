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
import 'Events.dart';
import 'Homepage.dart';
import 'InnoHubGeneral.dart';
import 'InnovationHubs.dart';
import 'constants/colors.dart';
import 'datamanager/DetailedHubInfoProvider.dart';
import 'datamanager/EventProvieder.dart';
import 'datamanager/Events.dart';
import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'datamanager/QuestionProvider.dart';
import 'datamanager/WorkProvider.dart';

class GuideHome extends StatefulWidget {
  const GuideHome({Key? key}) : super(key: key);

  @override
  State<GuideHome> createState() => _GuideHome();
}

class _GuideHome extends State<GuideHome> {
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
                    bottom: BorderSide(width: 1, color: tBackground),
                  )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30,
                    vertical: 0.0),
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
                            future: _loadLeadingImage(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // Wenn das Bild geladen wurde, zeige es an
                                return snapshot.data!;
                              } else if (snapshot.hasError) {
                                // Wenn ein Fehler aufgetreten ist, zeige eine Fehlermeldung an
                                return Icon(Icons
                                    .error); // Hier könntest du eine andere Fehleranzeige verwenden
                              } else {
                                // Ansonsten zeige einen Ladeindikator oder ein Platzhalterbild an
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                          Text(
                            "fau innohub",
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.455,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.031,
                          )),
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
                            child: Text(
                              "Innovation Guide",
                              style: TextStyle(
                                  fontWeight: isGuideViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "Community",
                              style: TextStyle(
                                  fontWeight: isCommunityViewSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
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
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 10,
                        ),
                        child: Container(
                          child: Text(
                            questions[currentQuestionIndex],
                            style: TextStyle(
                              fontSize: 64,
                              color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Builder(
                          builder: (context) {
                            if (currentQuestion == "Are you from Fürth?") {
                              if (questions.isNotEmpty &&
                                  answerOptions_Furth.isNotEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  // Setzen Sie hier die maximale Höhe nach Bedarf
                                  child: RepaintBoundary(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: answerOptions_Furth.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // Toggle the selection status of the answer
                                              if (selectedAnswers_Furth
                                                  .contains(answerOptions_Furth[index])) {
                                                selectedAnswers_Furth
                                                    .remove(answerOptions_Furth[index]);
                                              } else {
                                                selectedAnswers_Furth
                                                    .add(answerOptions_Furth[index]);
                                                if (currentQuestionIndex ==
                                                    questions.length - 1) {
                                                  print(selectedAnswers_Furth);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyHomePage()),
                                                  );
                                                } else {
                                                  // Ansonsten gehe zur nächsten Frage
                                                  setState(() {
                                                    currentQuestionIndex++;
                                                  });
                                                }
                                              }
                                            });
                                            String selectedAnswer =
                                            answerOptions_Furth[index];
                                            print('Selected Answer: $selectedAnswer');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Hero(
                                                  tag: answerOptions_Furth[index],
                                                  // Unique tag for each image
                                                  child: FutureBuilder(
                                                    future: _loadProfileImage(
                                                        answerOptions_Furth[index]),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState ==
                                                          ConnectionState.done) {
                                                        return SizedBox(
                                                          height: MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              4,
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              4,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                            snapshot.data as String,
                                                            width: MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                4,
                                                            height: MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                4,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Container(),
                                                            errorWidget:
                                                                (context, url, error) =>
                                                                Icon(Icons.error),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(); // Ladeindikator kann hier eingefügt werden
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                    child: RepaintBoundary(
                                                      child: Hero(
                                                        tag:
                                                        'text_${answerOptions_Furth[index]}',
                                                        child: Text(
                                                          answerOptions_Furth[index],
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: tPrimaryColorText,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ), // Counter und Next/Finish Button
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            } else if (currentQuestion ==
                                "What best matches your Intrests?") {
                              if (questions.isNotEmpty &&
                                  answerOptions_topic.isNotEmpty) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height *
                                          (280 / 1080),
                                      width: MediaQuery.of(context).size.width *
                                          (1053 / 1728),
                                      child: InlineChoice<String>(
                                        multiple: true,
                                        clearable: true,
                                        value: selectedAnswers_topic,
                                        onChanged: setSelectedValue,
                                        itemCount: answerOptions_topic.length,
                                        itemBuilder: (selection, i) {
                                          return ChoiceChip(
                                            selected: selection
                                                .selected(answerOptions_topic[i]),
                                            onSelected: selection
                                                .onSelected(answerOptions_topic[i]),
                                            label: Text(answerOptions_topic[i]),
                                          );
                                        },
                                        listBuilder: ChoiceList.createWrapped(
                                          spacing: 10,
                                          runSpacing: 10,
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            } else {
                              if (questions.isNotEmpty && answerOptions_Type.isNotEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  // Setzen Sie hier die maximale Höhe nach Bedarf
                                  child: RepaintBoundary(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: answerOptions_Type.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // Toggle the selection status of the answer
                                              if (selectedAnswers_Type
                                                  .contains(answerOptions_Type[index])) {
                                                selectedAnswers_Type
                                                    .remove(answerOptions_Type[index]);
                                              } else {
                                                selectedAnswers_Type
                                                    .add(answerOptions_Type[index]);
                                                if (currentQuestionIndex ==
                                                    questions.length - 1) {
                                                  print(selectedAnswers_Type);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyHomePage()),
                                                  );
                                                } else {
                                                  // Ansonsten gehe zur nächsten Frage
                                                  setState(() {
                                                    currentQuestionIndex++;
                                                  });
                                                }
                                              }
                                            });
                                            String selectedAnswer =
                                            answerOptions_Type[index];
                                            print('Selected Answer: $selectedAnswer');
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Hero(
                                                  tag: answerOptions_Type[index],
                                                  // Unique tag for each image
                                                  child: FutureBuilder(
                                                    future: _loadProfileImage(
                                                        answerOptions_Type[index]),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState ==
                                                          ConnectionState.done) {
                                                        return SizedBox(
                                                          height: MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              4,
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              4,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                            snapshot.data as String,
                                                            width: MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                4,
                                                            height: MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                4,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Container(),
                                                            errorWidget:
                                                                (context, url, error) =>
                                                                Icon(Icons.error),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(); // Ladeindikator kann hier eingefügt werden
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                    child: RepaintBoundary(
                                                      child: Hero(
                                                        tag:
                                                        'text_${answerOptions_Type[index]}',
                                                        child: Text(
                                                          answerOptions_Type[index],
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: tPrimaryColorText,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ), // Counter und Next/Finish Button
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }
                          },
                        ),
                      ),
                      if (currentQuestionIndex == questions.length - 1)
                        GestureDetector(
                          onTap: () async {
                            String result = GetIndex();

                            print('Filter tags match an array in Arrays. Corresponding path: $result');
                            final ref = firebase_storage.FirebaseStorage.instance.ref(result);
                            final url = await ref.getDownloadURL();

                            String? downloadUrl = await url;
                            if (downloadUrl != null) {
                              // Open the URL in the browser
                              if (await canLaunch(downloadUrl)) {
                                setState(() {
                                  generating =true;
                                });
                                const duration = Duration(seconds: 3);
                                await Future.delayed(duration);
                                await launch(downloadUrl);
                                setState(() {
                                  generating =false;
                                });
                              } else {
                                print("Could not launch $downloadUrl");
                              }
                            } else {
                              print("Matching entry not found in PathList");
                            }

                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * (60 / 982),
                            width: MediaQuery.of(context).size.width * (317 / 1512),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                  (MediaQuery.of(context).size.height * (60 / 982)) / 2,
                                )),
                            child: Center(
                              child: Text(generating? "Generating": 'View Reccomendations',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 30),
                          child: Text('${currentQuestionIndex + 1} / ${questions.length}',
                              style: TextStyle(
                                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                  fontSize: 64)),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *(124/1080),
                      )
                    ],
                  ),
            )
            )
          ]),
    );
  }

  void _restartFilter() {
    currentQuestionIndex = 0;
  }

  Future<Object> _loadProfileImage(String selectedAnswer) async {
    String imagePath = "";
    try {
      print(selectedAnswer);
      if (selectedAnswer == "StartUps") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/StartUp.svg";
      } else if (selectedAnswer == "Yes") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "No") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "Research Institutions") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Company.svg";
      } else if (selectedAnswer == "University Chair") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Chair.svg";
      } else if (selectedAnswer == "Not Sure") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/Beer Celebration-cuate.svg";
      }
      final ref = firebase_storage.FirebaseStorage.instance.ref(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Fehlerbehandlung, wenn das Bild nicht geladen werden kann
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }
}

