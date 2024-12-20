// ignore_for_file: deprecated_member_use, unused_import

import 'dart:io';

import 'package:buonappetito/api/firebase_api.dart';
import 'package:buonappetito/firebase_options.dart';
import 'package:buonappetito/models/Ricetta.dart';
import 'package:buonappetito/models/Categoria.dart';
import 'package:buonappetito/pages/CarrelloPage.dart';
import 'package:buonappetito/pages/CategoriaPage.dart';
import 'package:buonappetito/pages/CreaCategoriaPage.dart';
import 'package:buonappetito/pages/DashboardPage.dart';
import 'package:buonappetito/pages/FirstPage.dart';
import 'package:buonappetito/pages/ImpostazioniPage.dart';
import 'package:buonappetito/pages/NuovaRicettaPage.dart';
import 'package:buonappetito/pages/PreferitiPage.dart';
import 'package:buonappetito/pages/RicettaPage.dart';
import 'package:buonappetito/pages/RicettePerCategoriePage.dart';
import 'package:buonappetito/pages/SearchPage.dart';
import 'package:buonappetito/pages/TutorialScreen.dart';
import 'package:buonappetito/providers/DifficultyProvider.dart';
import 'package:buonappetito/providers/TimeProvider.dart';
import 'package:buonappetito/providers/ColorsProvider.dart';
import 'package:buonappetito/providers/RicetteProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenTutorial = prefs.getBool('seenTutorial') ?? false;

  // Ottieni la directory dei documenti dell'app
  final appDocsDir = await getApplicationDocumentsDirectory();

  // Inizializza Hive e specifica la directory
  await Hive.initFlutter(appDocsDir.path);

  // Registra gli adattatori
  Hive.registerAdapter(RicettaAdapter());
  Hive.registerAdapter(CategoriaAdapter());

  await Hive.openBox('Ricette');
  await Hive.openBox('Colori');

  // essendo necessario l'account da apple developer (di cui il gruppo non era provvisto) 
  // per poter inserire la capability per le notifiche push
  // si è deciso di implementare le notifiche solo sui dispositivi android

  if(Platform.isAndroid){
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseApi().initNotification();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorsProvider()),
        ChangeNotifierProvider(create: (_) => RicetteProvider()),
        ChangeNotifierProvider(create: (_) => DifficultyProvider()),
        ChangeNotifierProvider(create: (_) => Timeprovider()),
      ],
      child: MyApp(seenTutorial: seenTutorial),
    ),
  );
}





class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.seenTutorial});

  final bool seenTutorial;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print("recived a message while in the foreground");
      if(message.notification != null){
        print("Message also contained notification: " +message.notification.toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print("Message clicked");
    });

    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      await colorsProvider.initializationDone;  // aspetto che i dati siano in uno stato consistente 
      colorsProvider.initLightMode(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if(Provider.of<ColorsProvider>(context, listen: false).temaAttuale == "Sistema Operativo"){
      final colorsProvider = Provider.of<ColorsProvider>(context, listen: false);
      colorsProvider.updateLightMode(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('App is inactive');
        break;
      case AppLifecycleState.paused:
        print('App is paused');
        break;
      case AppLifecycleState.resumed:
        print('App is resumed');
        break;
      case AppLifecycleState.detached:
        print('App is detached');
        break;
      case AppLifecycleState.hidden:
        print('App is hidden');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ColorsProvider, RicetteProvider>(builder: (context, colorsModel, ricetteModel, _) {
      return MaterialApp(
        title: 'buonAPPetito',
        debugShowCheckedModeBanner: false,
        home: widget.seenTutorial? FirstPage() : TutorialScreen(),
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/dashboardpage': (context) => DashboardPage(),
          '/searchpage': (context) => SearchPage(),
          '/preferitipage': (context) => PreferitiPage(),
          '/impostazionipage': (context) => ImpostazioniPage(),
          '/nuovaricettapage': (context) => NuovaRicettaPage(),
          '/carrellopage': (context) => CarrelloPage(),
          '/categoriapage': (context) => CategoriaPage(),
          '/creacategoriapage': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CreaCategoriaPage(
            onUpdate: args['onUpdate'],
          );
          },
          '/ricettepercategoriepage': (context) => RicettePerCategoriePage(nomeCategorie: ModalRoute.of(context)!.settings.arguments as String),
        },
      );
    });
  }
}
