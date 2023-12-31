import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/dashboard/desktop/desktop.dart';
import 'package:webapp_innovation_leadership/dashboard/mobile/mobile.dart';
import 'package:webapp_innovation_leadership/dashboard/tablet/tablet.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';

import 'datamanager/InnovationHub.dart';



class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: DesktopDashboard(),
        mobile: MobileDashboard(),
        tablet: TabletDashboard()
    );
  }
}