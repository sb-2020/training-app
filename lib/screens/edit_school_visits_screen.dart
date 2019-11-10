import 'package:flutter/material.dart';
import './school_visits_screen.dart';
import '../providers/visits.dart';
import 'package:provider/provider.dart';

class EditSchoolVisitsScreen extends StatefulWidget {
  static const routeName = 'edit-school-visits';
  @override
  _EditSchoolVisitsScreenState createState() => _EditSchoolVisitsScreenState();
}

class _EditSchoolVisitsScreenState extends State<EditSchoolVisitsScreen> {
  bool _editing = false;
  bool _isInit = true;

  var _editedVisit = Visit(
    id: "",
    visitType: "",
    date: null,
    classObservation: "",
  );

  GlobalKey<FormState> _visitForm = GlobalKey();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String visitId = ModalRoute.of(context).settings.arguments;
      if (visitId != "") {
        _editing = true;
        Provider.of<Visits>(context, listen: false)
            .findVisitByID(visitId)
            .then((visit) {
          _editedVisit = visit;
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _saveForm() async {
    _visitForm.currentState.save();
    if (_editing) {
      await Provider.of<Visits>(context, listen: false)
          .updateVisit(_editedVisit);
    } else {
      await Provider.of<Visits>(context, listen: false)
          .addNewVisit(_editedVisit);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: _editing ? Text("Edit visit details") : Text("Add new visit"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _visitForm,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Visit Type"),
                  onSaved: (value) {
                    _editedVisit = Visit(
                        id: _editedVisit.id,
                        visitType: value,
                        date: _editedVisit.date,
                        classObservation: _editedVisit.classObservation);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
