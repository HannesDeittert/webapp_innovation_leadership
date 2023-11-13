import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webapp_innovation_leadership/dashboard/desktop/desktop.dart';
import 'package:webapp_innovation_leadership/dashboard/desktop/desktop_footer.dart';
import 'package:webapp_innovation_leadership/dashboard/mobile/mobile.dart';
import 'package:webapp_innovation_leadership/dashboard/mobile/mobile_footer.dart';
import 'package:webapp_innovation_leadership/dashboard/tablet/tablet.dart';
import 'package:webapp_innovation_leadership/widget/responsive.dart';

import 'dashboard/tablet/tablet_footer.dart';
import 'datamanager/InnovationHub.dart';



class Footer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Responsive(
        desktop: DesktopFooter(),
        mobile: MobileFooter(),
        tablet: TabletFooter()
    );
  }
}