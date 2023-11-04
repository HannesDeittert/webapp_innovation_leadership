import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../datamanager/InnovationHub.dart';
import '../datamanager/InnovationHubProvider.dart';
import 'filter_dropdown.dart';


List<InnovationHub> filteredHubs = [];

class MyListView extends StatefulWidget {
  final List<InnovationHub> hubs;

  MyListView({required this.hubs});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  String filter = '';

  @override
  void initState() {
    super.initState();
    filteredHubs = widget.hubs;
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