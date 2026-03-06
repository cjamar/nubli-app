import 'package:flutter/widgets.dart';
import '../../features/entry/presentation/pages/home_page.dart';

class AppRoutes {
  static String initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, WidgetBuilder> routes = {'home': (context) => const HomePage()};
    return routes;
  }
}
