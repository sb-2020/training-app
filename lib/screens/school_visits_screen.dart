import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visits.dart';
import './edit_school_visits_screen.dart';
import './class_observations.dart';
import 'package:intl/intl.dart';

class SchoolVisitsScreen extends StatefulWidget {
  static const routeName = '/school-visits';

  @override
  _SchoolVisitsScreenState createState() => _SchoolVisitsScreenState();
}

class _SchoolVisitsScreenState extends State<SchoolVisitsScreen> {
  @override
  void initState() {
    Provider.of<Visits>(context, listen: false).getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("School Visits"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditSchoolVisitsScreen.routeName, arguments: "");
              },
            )
          ],
        ),
        body: Consumer<Visits>(
          builder: (ctx, visits, _) => ListView.builder(
            itemCount: visits.visits.length,
            itemBuilder: (ctx, idx) => Card(
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ListTile(
                title: Text(visits.visits[idx].visitType),
                subtitle: Text(
                    DateFormat("yyyy-MM-dd").format(visits.visits[idx].date)),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EditSchoolVisitsScreen.routeName,
                              arguments: visits.visits[idx].id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add_comment),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ClassObservations.routeName,
                              arguments: visits.visits[idx].id);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
