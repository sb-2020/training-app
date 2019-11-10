import 'package:flutter/material.dart';

class School {
  final String id;
  final String name;

  School({
    @required this.id,
    @required this.name,
  });
}

class Schools with ChangeNotifier {
  List<School> _schools;

  final String token;
  final String phoneNumber;

  Schools(this.token, this.phoneNumber, this._schools);

  List<School> get schools {
    return [..._schools];
  }

  Future<void> getAndSetData() async {
    //INTEGRATION TO DO: Real data for the logged on user will need to be fetched from the server,
    //extracted from the JSON-encoded body of the response, and stored into the
    //schools variable in this class
    //Note: data can be fetch only if the user is logged on and has the correct profile(resource person in this case)

    //Using dummy hardcoded data for now
    final List<School> fetchedSchoolsList = [
      School(id: "sch1", name: "School Number 1"),
      School(id: "sch2", name: "School Number 2"),
      School(id: "sch3", name: "School Number 3"),
      School(id: "sch4", name: "School Number 4"),
      School(id: "sch5", name: "School Number 5"),
      School(id: "sch6", name: "School Number 6"),
    ];

    //TO DO error handling

    _schools = fetchedSchoolsList;

    notifyListeners();
  }
}
