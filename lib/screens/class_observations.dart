import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visits.dart';

class ClassObservations extends StatefulWidget {
  static const routeName = '/class-observations';
  @override
  _ClassObservationsState createState() => _ClassObservationsState();
}

class _ClassObservationsState extends State<ClassObservations> {
  var _isInit = true;
  var _visitId = "";
  final _classObsText = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _visitId = ModalRoute.of(context).settings.arguments;
      Provider.of<Visits>(context, listen: false)
          .getClassObservationText(_visitId)
          .then((obs) {
        _classObsText.text = obs;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _classObsText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Edit class observations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _classObsText,
            maxLines: null,
          ),
          FlatButton(
            child: Text("Update"),
            onPressed: () {
              Provider.of<Visits>(context, listen: false)
                  .addOrUpdateClassObservations(_visitId, _classObsText.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
