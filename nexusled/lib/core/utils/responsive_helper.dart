import 'package:flutter/widgets.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double widescreen = 1600;
}

class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < Breakpoints.mobile;
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.mobile &&
      MediaQuery.sizeOf(context).width < Breakpoints.desktop;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.desktop;
  static bool showSidebar(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
}
