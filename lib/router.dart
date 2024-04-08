import 'package:flutter/material.dart';
import 'package:test_package_call/audio_wafe.dart';

import 'package:test_package_call/list_solicitantes.dart';
import 'package:test_package_call/phone_state.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case ListSolicitantes.route:
      return MaterialPageRoute(builder: (_) => const ListSolicitantes());
    case PhoneStatePage.route:
      return MaterialPageRoute(builder: (_) => const PhoneStatePage());
    case Home.route:
      return MaterialPageRoute(builder: (_) => const Home());

    default:
      throw ('This route nae does not exist');
  }
}
