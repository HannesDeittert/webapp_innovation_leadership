import 'package:cached_network_image/cached_network_image.dart';
import 'package:choice/choice.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp_innovation_leadership/widget/Calender.dart';
import 'package:webapp_innovation_leadership/widget/EventListItem.dart';
import 'package:webapp_innovation_leadership/widget/GenerateFinished.dart';
import 'package:webapp_innovation_leadership/widget/InnoHubListWidget.dart';
import 'package:webapp_innovation_leadership/widget/map.dart';
import 'CommunityPages/Community.dart';
import 'Events.dart';
import 'Homepage.dart';
import 'InnovationHubs.dart';
import 'constants/colors.dart';
import 'datamanager/DetailedHubInfoProvider.dart';
import 'datamanager/EventProvieder.dart';
import 'datamanager/Events.dart';
import 'datamanager/InnovationHub.dart';
import 'datamanager/InnovationHubProvider.dart';
import 'datamanager/QuestionProvider.dart';
import 'datamanager/WorkProvider.dart';
import 'login/login_screen.dart';

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
    "What type of innovation location you´re interested in?",
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
    "Technology",
    "Education",
    "Research",
    "Automotive",
    "Mechanics",
    "Finance",
    "Insurance",
    "Social Science",
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
    List<List<String>> Arrays = [['No', 'StartUps','Information Technology / AI',"Finance"],['Yes', 'Information Technology / AI',],['Yes', 'University Chair'],['No', 'StartUps','Insurance'],['No', 'Not Sure'],['No', 'Research Institutions']];
    List<String> PathList = ['pdf/Innovation Guide.pdf','pdf/Innovation Guide.pdf', 'pdf/Innovation Guide.pdf','pdf/Innovation Guide.pdf','pdf/Innovation Guide.pdf','pdf/Innovation Guide.pdf'];
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

    // Checking for the index with the highest correlation
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
                                    builder: (context) => Community()),
                              );
                              /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );*/
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
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (80/ 1080),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: MediaQuery.of(context).size.height *
                                        (20/ 1080),),
                                child: Text('${currentQuestionIndex + 1} / ${questions.length}',
                                    style: TextStyle(
                                        fontSize: 20)),
                              ),
                              Text(
                                questions[currentQuestionIndex],
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(0xFF, 0x55, 0x55, 0x55),
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              currentQuestion == "What best matches your Intrests?" ?
                                Text("Select minimum 2 categories",style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                                ),): SizedBox(height: 0.1,),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (80/ 1080),
                              ),
                            ],
                          ),
                        ),
                      Flexible(
                        child: Builder(
                          builder: (context) {
                            if (currentQuestion == "Are you from Fürth?") {
                              if (questions.isNotEmpty &&
                                  answerOptions_Furth.isNotEmpty) {
                                return Container(
                                  height: 250,
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
                                      if (selectedAnswers_Furth.contains(
                                          answerOptions_Furth[index])) {
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
                                        horizontal: 36),
                                    child: answerOptions_Furth[index] == "Yes"
                                        ? Container(
                                            width: 250,
                                            height: 250,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: tBlue),
                                            child: Center(
                                              child: Text(
                                                'Yes, I am',
                                                style: TextStyle(
                                                    color: tWhite,
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ) // Replace YourWidgetToReturnIfYes with the actual widget
                                        : Container(
                                            width: 250,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blue, // Set the border color here
                                                  width: 3, // Set the border width if needed
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: tWhite),
                                            child: Center(
                                              child: Text(
                                                "No, I'm not",
                                                style: TextStyle(
                                                    color: tBlue,
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
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
                                            backgroundColor: tWhite,
                                            selectedColor: tBlue.withAlpha(95),
                                            selected: selection.selected(answerOptions_topic[i]),
                                            onSelected: selection.onSelected(answerOptions_topic[i]),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: Colors.blue, width: 2),
                                              borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                                            ),
                                            label: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                              child: Text(
                                                answerOptions_topic[i],
                                                style: selectedAnswers_topic.contains(answerOptions_topic[i]) ? TextStyle(color: Colors.white) : TextStyle(color: tBlue),
                                              ),
                                            ),
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
                                  height: 293,
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
                                            padding: const EdgeInsets.symmetric(horizontal: 36),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 250,
                                                  width: 250,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.blue, // Set the border color here
                                                        width: 3, // Set the border width if needed
                                                      ),
                                                      borderRadius:
                                                      BorderRadius.circular(20),
                                                      color: tWhite),
                                                  child: Center(
                                                    child: Container(
                                                      height: 106,
                                                      width: 106,
                                                      child: Expanded(
                                                        child: FutureBuilder(
                                                          future: _loadProfileImage(
                                                              answerOptions_Type[index]),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState ==
                                                                ConnectionState.done) {
                                                              return CachedNetworkImage(
                                                                width: 106,
                                                                imageUrl:
                                                                snapshot.data as String,
                                                                placeholder: (context, url) =>
                                                                    Container(),
                                                                errorWidget:
                                                                    (context, url, error) =>
                                                                    Icon(Icons.error),
                                                              );
                                                            } else {
                                                              return Container(); // Ladeindikator kann hier eingefügt werden
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  answerOptions_Type[index],
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GuideFinishedHome()),
                            );

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
                        ),
                      if(currentQuestionIndex != 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *(64/1512),vertical:MediaQuery.of(context).size.width *(64/1512)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    currentQuestionIndex = currentQuestionIndex-1;
                                    if(currentQuestionIndex == 0){
                                      selectedAnswers_Furth.clear();
                                    }
                                    if(currentQuestionIndex == 1){
                                      selectedAnswers_Type.clear();
                                    }
                                    if(currentQuestionIndex == 2){
                                      selectedAnswers_topic.clear();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back,
                                    color: tBlue,),
                                    Text("Previous",style: TextStyle(
                                      color: tBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                    ),)
                                  ],
                                )
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      if(currentQuestionIndex == 0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height *(124/1080),
                        ),
                    ],
                  ),
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
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/StartUP.png";
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
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/covid_virus-lab-research-test-tube.png";
      } else if (selectedAnswer == "University Chair") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/University Chair.png";
      } else if (selectedAnswer == "Not Sure") {
        print("object");
        // Verwende hier die Referenz für StartUp
        imagePath =
        "gs://cohort1innovationandleadership.appspot.com/Images/Filter/notsure.png";
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

