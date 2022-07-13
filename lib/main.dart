import 'package:flutter/material.dart';
import 'package:pinterest_clone_me_flutter/pages/account_page.dart';
import 'package:pinterest_clone_me_flutter/pages/header_page.dart';
import 'package:pinterest_clone_me_flutter/pages/home_page.dart';
import 'package:pinterest_clone_me_flutter/pages/search_page.dart';
import 'package:pinterest_clone_me_flutter/pages/temp_page.dart';

void main(){
  runApp(const MyApp());
}

///negadir crashylistni o'rnatsam ishlamayapti.


/*Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(

    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),


      home: const HeaderPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SearchPage.id: (context) => const SearchPage(),
        AccountPage.id: (context) => const AccountPage(),
        HeaderPage.id:(context)=>const HeaderPage(),
        SearchPhotoTest.id:(context)=>SearchPhotoTest(),
      },
    );
  }
}


