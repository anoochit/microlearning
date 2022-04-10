import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/location/payment_location.dart';
import 'package:microlearning/location/contact_location.dart';
import 'package:microlearning/location/course_location.dart';
import 'package:microlearning/location/home_location.dart';
import 'package:microlearning/location/informpayment_location.dart';
import 'package:microlearning/location/profile_location.dart';
import 'package:microlearning/location/signin_location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:microlearning/services/authentication_service.dart';
import 'package:microlearning/themes/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Beamer.setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bind app controller
  AppController controller = Get.put(AppController());

  late final BeamerDelegate routerDelegate;

  @override
  void initState() {
    super.initState();

    // set router delegate
    routerDelegate = BeamerDelegate(
      locationBuilder: BeamerLocationBuilder(
        beamLocations: [
          HomeLocation(),
          SignInLocation(),
          ProfileLocation(),
          CourseLocation(),
          ContactLocation(),
          PaymentLocation(),
          InformPaymentLocation(),
        ],
      ),
      guards: [
        // Guard to check if user is logged in
        BeamGuard(
          pathPatterns: [
            '/profile',
            '/payment',
            '/informpayment',
          ],
          check: (context, location) => isSignIn(),
          beamToNamed: (_, __) => '/signin',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: const Locale('th'),
      localizationsDelegates: [
        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // Delegate to provide custom translations
        FlutterFireUILocalizations.delegate,
      ],
      title: 'เขียน Flutter ง่ายนิดเดียว',
      theme: ThemeData(
        canvasColor: Colors.white,
        primarySwatch: kMaterialColor,
        textTheme: GoogleFonts.promptTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 3.0),
        cardTheme: const CardTheme(elevation: 2.0),
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}
