import 'package:flutter/material.dart';
import '../providers/classes.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EditClassesScreen extends StatefulWidget {
  static const routeName = '/edit-classes';

  EditClassesScreen({Key key}) : super(key: key);

  @override
  _EditClassesScreenState createState() => _EditClassesScreenState();
}

class _EditClassesScreenState extends State<EditClassesScreen> {
  var _isInit = true;

  var _initValues = {
    "venue": "",
    "date": null,
  };

  var _editedClass = Class(
    id: "",
    venue: "",
    date: null,
  );

  final GlobalKey<FormState> _classesForm = GlobalKey();

  var _isLoading = false;

  var _editing = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final String classID = ModalRoute.of(context).settings.arguments;
      if (classID != "") {
        _editing = true;
        _editedClass =
            Provider.of<Classes>(context, listen: false).findClassById(classID);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    _classesForm.currentState.save();

    if (_editedClass.id != "") {
      Provider.of<Classes>(context, listen: false).updateClass(_editedClass);
    } else {
      Provider.of<Classes>(context, listen: false).addNewClass(_editedClass);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: _editing ? Text("Edit class details") : Text("Add new class"),
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
        height: deviceSize.height,
        width: deviceSize.width,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _classesForm,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Venue"),
                  initialValue:
                      _editing ? _editedClass.venue : _initValues["venue"],
                  onSaved: (value) {
                    _editedClass = Class(
                      id: _editedClass.id,
                      venue: value,
                      date: _editedClass.date,
                    );
                  },
                ),
                DateTimeField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(labelText: "Date"),
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, date) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.parse("2019-01-01"),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                        initialDate:
                            //_editing ? _editedClass.date : _initValues["date"],
                            DateTime.now(),
                      );
                      return date;
                    },
                    onSaved: (value) {
                      _editedClass = Class(
                        id: _editedClass.id,
                        venue: _editedClass.venue,
                        date: value,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
