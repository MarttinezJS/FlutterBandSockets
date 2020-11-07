import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/pages/status.dart';
import 'package:band_names/src/pages/home_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: ( _ ) => HomePage(),
          StatusPage.routeName: ( _ ) => StatusPage()
        },
      ),
    );
  }
}
