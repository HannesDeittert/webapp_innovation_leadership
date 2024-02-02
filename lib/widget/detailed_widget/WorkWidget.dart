import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Constants/Colors.dart';


class WorkWidget extends StatelessWidget {
  String WorkText;
  String WorkHeader;
  String WorkName;


  Future<ImageProvider> _loadProfileImage(String path) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(path);
      final url = await ref.getDownloadURL();
      return NetworkImage(url);
    } catch (e) {
      print('Fehler beim Laden des Profilbildes: $e');
      return AssetImage('assets/placeholder_image.jpg');
    }
  }



  WorkWidget(this.WorkText, this.WorkHeader, this.WorkName);

  @override
  Widget build(BuildContext context) {
    final image_width = MediaQuery.of(context).size.width *(1259/1920);
    final image_height = MediaQuery.of(context).size.height *(541/1080);
    return SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width *(1156/1512),
          color: tBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _loadProfileImage(WorkHeader),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.done) {
                    return SizedBox(
                      height: image_height,
                      width: image_width,
                      child: Image(
                        image: snapshot.data as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (36/1080) ,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Research",style:
                TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),),
              ),
              Text(WorkText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
      ),
    );
  }
}