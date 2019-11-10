import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/classes.dart';
import '../screens/edit_classes_screen.dart';
import 'package:intl/intl.dart';

class ClassesConductedScreen extends StatefulWidget {
  static const routeName = '/classes_conducted';

  @override
  _ClassesConductedScreenState createState() => _ClassesConductedScreenState();
}

class _ClassesConductedScreenState extends State<ClassesConductedScreen> {
  @override
  void initState() {
    Provider.of<Classes>(context, listen: false).getAndSetData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes Conducted"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditClassesScreen.routeName, arguments: "");
            },
          )
        ],
      ),
      body: Consumer<Classes>(
          builder: (ctx, classes, _) => ListView.builder(
                itemCount: classes.classes.length,
                itemBuilder: (ctx, idx) => Card(
                  elevation: 16.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: ListTile(
                    title: Text(classes.classes[idx].venue),
                    //subtitle: Text(classes.classes[idx].date.toIso8601String()),
                    subtitle: Text(DateFormat("yyyy-MM-dd")
                        .format(classes.classes[idx].date)),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            EditClassesScreen.routeName,
                            arguments: classes.classes[idx].id);
                      },
                    ),
                  ),
                ),
              )),
    );
  }
}
