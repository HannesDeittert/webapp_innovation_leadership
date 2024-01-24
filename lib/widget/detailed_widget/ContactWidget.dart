import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/Colors.dart';

class ContactWidget extends StatelessWidget {
  final Map<String, String> contacts;
  final String name;
  final bool detail;

  ContactWidget(this.contacts,this.name,this.detail );

  @override
  Widget build(BuildContext context) {
    return detail?  Container(
        width: MediaQuery.of(context).size.width *(1156/1512),
        color: tBackground,
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: Row(
            children: [
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *(1156/1512)-32,
                    child: Column(
                      children: [
                        Text("Feel Free To Contact",
                          style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w700,
                              color: tPrimaryColorText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(name,
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            color: tPrimaryColorText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height* 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContactInfo("Website", contacts["Website"], Uri(
                          scheme: 'https',
                          path: contacts["Website"]
                      )),
                      _buildContactInfo("TeleContact", contacts["TeleContact"], Uri(
                          scheme: 'tel',
                          path: contacts["TeleContact"]
                      )),
                      _buildContactInfo("EmailContact", contacts["EmailContact"], Uri(
                          scheme: 'mailto',
                          path: contacts["EmailContact"]
                      )),
                      _buildContactInfo("Latitude", contacts["Latitude"], Uri(
                          scheme: 'https',
                          path: contacts["Latitud"]
                      )),
                    ],
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
    ):
    Container(
          color: tWhite,
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *(1092/1512)-32,
                    child: Column(
                      children: [
                        Text("Feel Free To Contact",
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            color: tPrimaryColorText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(name,
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            color: tPrimaryColorText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height* 0.1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContactInfo("Website", contacts["Website"], Uri(
                          scheme: 'https',
                          path: contacts["Website"]
                      )),
                      _buildContactInfo("TeleContact", contacts["TeleContact"], Uri(
                          scheme: 'tel',
                          path: contacts["TeleContact"]
                      )),
                      _buildContactInfo("EmailContact", contacts["EmailContact"], Uri(
                          scheme: 'mailto',
                          path: contacts["EmailContact"]
                      )),
                      _buildContactInfo("Latitude", contacts["Latitude"], Uri(
                          scheme: 'https',
                          path: contacts["Latitud"]
                      )),
                    ],
                  ),
                ],
              ),
              Spacer(),
            ],
          ),

      );
  }

  Widget _buildContactInfo(String label, String? value, Uri link) {

    if (value != null && value.isNotEmpty) {
      IconData icon;
      String iconName = label.toLowerCase();

      switch (iconName) {
        case "website":
          icon = Icons.link;
          break;
        case "telecontact":
          icon = Icons.phone;
          break;
        case "emailcontact":
          icon = Icons.email;
          break;
        case "latitude":
        case "longitude":
          icon = Icons.location_on;
          break;
        default:
          icon = Icons.info;
      }

      // Wenn es Latitude oder Longitude ist, die beiden Informationen in einer Zeile anzeigen
      if (iconName == "latitude" ) {
        String? Lon = contacts["Longitude"];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Text(
              "$value , $Lon",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        );
      } else {
        return Row(
              children: [
                Icon(
                  icon,
                  size: 20.0,
                ),
                SizedBox(width: 8.0),
                buildLinkText(link, value),
              ],
            );
      }
    } else {
      return Container();
    }
  }
}

Widget buildLinkText(Uri link, String linkstring) {
  // Erstelle einen klickbaren Link
  final recognizer = TapGestureRecognizer()
    ..onTap = () async {
      _launchInBrowser(link);
    };

  return RichText(
    text: TextSpan(
          text: linkstring,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: recognizer,
        ),
  );
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}