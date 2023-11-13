import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'filter_dropdown.dart';

class MyListView extends StatefulWidget {
  final List<InnovationHub> hubs;

  MyListView({required this.hubs});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  String filter = '';
  late List<InnovationHub> filteredHubs;

  @override
  void initState() {
    super.initState();
    filteredHubs = widget.hubs;
    print(filteredHubs[0]);
  }

  void filterHubs(String query, BuildContext context) {
    // Zugriff auf den InnovationHubProvider
    InnovationHubProvider provider = Provider.of<InnovationHubProvider>(context, listen: false);

    setState(() {
      filteredHubs = query == ''
          ? widget.hubs
          : widget.hubs
          .where((hub) => hub.category == query)
          .toList();
    });

    // Aufrufen der Methode createFilterdHubList aus dem Provider
    provider.createFilterdHubList(filteredHubs);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
          width: MediaQuery.of(context).size.width / 40,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 60,
              vertical: MediaQuery.of(context).size.height / 40),
          child: FilterDropdown(
            filter: filter,
            onFilterChanged: (value) {
              setState(() {
                filter = value;
                filterHubs(filter, context);
              });
            },
            hubs: widget.hubs,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredHubs.length,
            itemBuilder: (context, index) => HubListTile(hub: filteredHubs[index]),
          ),
        ),
      ],
    );
  }
}