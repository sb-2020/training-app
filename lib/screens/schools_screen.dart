import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schools.dart';
import '../screens/school_visits_screen.dart';

class SchoolsScreen extends StatefulWidget {
  static const routeName = '/schools';

  @override
  _SchoolsScreenState createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  @override
  void initState() {
    Provider.of<Schools>(context, listen: false).getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schools"),
      ),
      body: Consumer<Schools>(
        builder: (ctx, schools, _) => ListView.builder(
          itemBuilder: (ctx, idx) => Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            elevation: 20.0,
            child: InkWell(
              child: ListTile(
                title: Text(schools.schools[idx].name),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(SchoolVisitsScreen.routeName);
              },
            ),
          ),
          itemCount: schools.schools.length,
        ),
      ),
    );
  }
}
