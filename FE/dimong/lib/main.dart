import 'package:dimong/ui/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dimong/ui/screens/login/login_page.dart';
import 'package:dimong/ui/screens/home/home_page.dart';
import 'package:dimong/ui/screens/drawing/drawing.dart';
import 'package:dimong/ui/screens/dic_dino/dic_dino.dart';

import 'package:dimong/ui/screens/drawing/dino_canvas.dart';
import 'package:provider/provider.dart';
import 'package:dimong/ui/screens/drawing/draw_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => DrawProvider(), child: DinoCanvas()),
      ],
      child: MaterialApp(
        title: 'My App',
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          //'/home': (context) => HomePage(),
        },
      ),
    );
  }
}
