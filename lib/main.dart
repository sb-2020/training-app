import 'package:flutter/material.dart';
import 'package:training/providers/schools.dart';
import 'package:training/screens/classes_conducted_screen.dart';
import 'package:training/screens/school_visits_screen.dart';
import 'package:training/screens/schools_screen.dart';
import './screens/authentication_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/classes.dart';
import './screens/edit_classes_screen.dart';
import './providers/visits.dart';
import './screens/edit_school_visits_screen.dart';
import './screens/class_observations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Schools>(
          builder: (ctx, auth, prevSchools) =>
              Schools(auth.token, auth.phoneNumber, []),
        ),
        ChangeNotifierProxyProvider<Auth, Classes>(
          builder: (ctx, auth, prevClasses) =>
              Classes(auth.token, auth.phoneNumber, []),
        ),
        ChangeNotifierProxyProvider<Auth, Visits>(
          builder: (ctx, auth, prevVisits) =>
              Visits(auth.token, auth.phoneNumber, []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Training Info',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isUserAuthenticated()
              ? (auth.userType == UserType.Teacher
                  ? ClassesConductedScreen()
                  : SchoolsScreen())
              : FutureBuilder(
                  future: auth.attemptAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : AuthenticationScreen(),
                ),
          routes: {
            ClassesConductedScreen.routeName: (ctx) => ClassesConductedScreen(),
            SchoolsScreen.routeName: (ctx) => SchoolsScreen(),
            SchoolVisitsScreen.routeName: (ctx) => SchoolVisitsScreen(),
            EditClassesScreen.routeName: (ctx) => EditClassesScreen(),
            EditSchoolVisitsScreen.routeName: (ctx) => EditSchoolVisitsScreen(),
            ClassObservations.routeName: (ctx) => ClassObservations(),
          },
        ),
      ),
    );
  }
}
