import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

//* Firebase
//? Note that Firebase can't load when running on a Windows application, use web browser instead.
import 'package:firebase_core/firebase_core.dart';
import 'package:sisfo/app/controllers/index_page_controller.dart';
import 'firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  RenderErrorBox.backgroundColor = Colors.blueAccent;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final PageC = Get.put(IndexPageController(), permanent: true);
  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          print(snapshot.data);
          return GetMaterialApp(
            title: 'Application',
            initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
            //? Route to Login
            // initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
              // primarySwatch: Colors.lightBlue,
            ),
          );
        }),
  );
}
