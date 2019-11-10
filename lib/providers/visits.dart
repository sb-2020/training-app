import 'package:flutter/material.dart';

class Visit {
  String id;
  String visitType;
  DateTime date;
  String classObservation;

  Visit({
    @required this.id,
    @required this.visitType,
    @required this.date,
    this.classObservation,
  });
}

class Visits with ChangeNotifier {
  List<Visit> _visits;
  String _token;
  String _phoneNumber;

  Visits(this._token, this._phoneNumber, this._visits);

  List<Visit> get visits {
    return [..._visits];
  }

  Future<void> getAndSetData() async {
    //TO DO INTEGRATION: fetch the visits data from the server

    //For now, using hardcoded data

    List<Visit> fetchedVisitsData = [
      Visit(
          id: "v1",
          visitType: "A",
          date: DateTime.now().subtract(Duration(days: 27)),
          classObservation: ""),
      Visit(
          id: "v2",
          visitType: "B",
          date: DateTime.now().subtract(Duration(days: 15)),
          classObservation: ""),
      Visit(
          id: "v3",
          visitType: "C",
          date: DateTime.now().subtract(Duration(days: 6)),
          classObservation: ""),
      Visit(
          id: "v4",
          visitType: "D",
          date: DateTime.now().subtract(Duration(days: 2)),
          classObservation: ""),
    ];

    _visits = fetchedVisitsData;

    notifyListeners();
  }

  Future<void> addNewVisit(Visit visit) async {
    //TO DO INTEGRATION: Save on server, which will autogenerate the visit id.

    //For now, generate a dummy visit id, and add the visit to the list of hardcoded visits.
    visit.id = DateTime.now().toIso8601String();
    visit.date = DateTime.now();
    _visits.add(visit);
    notifyListeners();
  }

  Future<void> updateVisit(Visit visit) async {
    //TO DO INTEGRATION: update on server

    final idx = _visits.indexWhere((v) => v.id == visit.id);
    _visits[idx].visitType = visit.visitType;
    _visits[idx].date = visit.date;
    _visits[idx].classObservation = visit.classObservation;
    notifyListeners();
  }

  Future<void> addOrUpdateClassObservations(String visitId, String obs) async {
    //TO DO INTEGRATION: Update class observations on the server

    final idx = _visits.indexWhere((v) => v.id == visitId);
    _visits[idx].classObservation = obs;
    notifyListeners();
  }

  Future<String> getClassObservationText(String visitId) async {
    final idx = visits.indexWhere((v) => v.id == visitId);
    return _visits[idx].classObservation;
  }

  Future<Visit> findVisitByID(String vID) async {
    //TO DO integration: Fetch from server

    final idx = _visits.indexWhere((v) => v.id == vID);
    if (idx == -1) {
      return null;
    }
    final Visit v = _visits[idx];
    return Visit(
        id: v.id,
        visitType: v.visitType,
        date: v.date,
        classObservation: v.classObservation);
  }
}
