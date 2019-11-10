import 'package:flutter/material.dart';

class Class {
  String id;
  String venue;
  DateTime date;

  Class({
    @required this.id,
    @required this.venue,
    @required this.date,
  });
}

class Classes with ChangeNotifier {
  final String _token;
  final String _phoneNumber;

  List<Class> _classes = [];

  Classes(this._token, this._phoneNumber, this._classes);

  List<Class> get classes {
    return [..._classes];
  }

  Future<void> getAndSetData() async {
    //INTEGRATION TO DO: An asynchronous http call to the server needs to be made here
    //to fetch the list of conducted classes for a particular logged on teacher.

    //User hardcoded dummy data for now.

    List<Class> loadedClassesList = [
      Class(
          id: "cls1",
          venue: "School 1, Locality A",
          date: DateTime.now().subtract(Duration(days: 50))),
      Class(
          id: "cls2",
          venue: "School 2, Locality B",
          date: DateTime.now().subtract(Duration(days: 47))),
      Class(
          id: "cls3",
          venue: "School 3, Locality C",
          date: DateTime.now().subtract(Duration(days: 25))),
      Class(
          id: "cls4",
          venue: "School 4, Locality D",
          date: DateTime.now().subtract(Duration(days: 18))),
      Class(
          id: "cls5",
          venue: "School 5, Locality E",
          date: DateTime.now().subtract(Duration(days: 7))),
      Class(
          id: "cls6",
          venue: "School 6, Locality F",
          date: DateTime.now().subtract(Duration(days: 1))),
    ];

    _classes = loadedClassesList;

    notifyListeners();
  }

  Class findClassById(String id) {
    Class cls = _classes.firstWhere((c) {
      return c.id == id;
    });
    return Class(id: cls.id, venue: cls.venue, date: cls.date);
  }

  Future<void> addNewClass(Class cls) async {
    //TO DO INTEGRATION: the new class needs to be saved on the server
    //(which will automatically generated a new unique ID for it )
    //The class list in memory then needs to be updated.

    //For now, simply adding the class to the list of classes in memory.

    cls.id = DateTime.now().toIso8601String(); //to simulate a unique ID for now

    _classes.add(cls);

    notifyListeners();
  }

  Future<void> updateClass(Class cls) async {
    //TO DO INTEGRATION: Updation needs to happen at the backend
    final idx = _classes.indexWhere((c) => c.id == cls.id);
    if (idx == -1) throw Error();
    _classes[idx].venue = cls.venue;
    _classes[idx].date = cls.date;

    notifyListeners();
  }
}
