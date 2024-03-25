/// schedules : ["$selectedBankerEmailId"]
/// startTime : {"dateTime":"","timeZone":"UTC"}
/// endTime : {"dateTime":"","timeZone":"UTC"}
/// availabilityViewInterval : 30

//SAMPLE REQUEST BODY
// final body = {
//   "schedules": ["$selectedBankerEmailId"],
//   "startTime": {
//     "dateTime": utcStartTime
//         .toUtc()
//         .toString()
//         .replaceAll(' ', "T")
//         .replaceAll('.000Z', ""),
//     "timeZone": "UTC"
//   },
//   "endTime": {
//     "dateTime": utcEndTime
//         .toUtc()
//         .toString()
//         .replaceAll(' ', "T")
//         .replaceAll('.000Z', ""),
//     "timeZone": "UTC"
//   },
//   "availabilityViewInterval": 30
// };

class GetScheduleRequest {
  GetScheduleRequest({
    List<String>? schedules,
    StartTime? startTime,
    EndTime? endTime,
    num? availabilityViewInterval,
  }) {
    _schedules = schedules;
    _startTime = startTime;
    _endTime = endTime;
    _availabilityViewInterval = availabilityViewInterval;
  }

  GetScheduleRequest.fromJson(dynamic json) {
    _schedules =
        json['schedules'] != null ? json['schedules'].cast<String?>() : [];
    _startTime = json['startTime'] != null
        ? StartTime.fromJson(json['startTime'])
        : null;
    _endTime =
        json['endTime'] != null ? EndTime.fromJson(json['endTime']) : null;
    _availabilityViewInterval = json['availabilityViewInterval'];
  }

  List<String>? _schedules;
  StartTime? _startTime;
  EndTime? _endTime;
  num? _availabilityViewInterval;

  GetScheduleRequest copyWith(
    List<String>? schedules,
    StartTime? startTime,
    EndTime? endTime,
    num? availabilityViewInterval,
  ) =>
      GetScheduleRequest(
        schedules: schedules ?? _schedules,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        availabilityViewInterval:
            availabilityViewInterval ?? _availabilityViewInterval,
      );

  List<String>? get schedules => _schedules;

  StartTime? get startTime => _startTime;

  EndTime? get endTime => _endTime;

  num? get availabilityViewInterval => _availabilityViewInterval;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schedules'] = _schedules;
    if (_startTime != null) {
      map['startTime'] = _startTime?.toJson();
    }
    if (_endTime != null) {
      map['endTime'] = _endTime?.toJson();
    }
    map['availabilityViewInterval'] = _availabilityViewInterval;
    return map;
  }
}

/// dateTime : ""
/// timeZone : "UTC"

class EndTime {
  EndTime({
    String? dateTime,
    String? timeZone,
  }) {
    _dateTime = dateTime;
    _timeZone = timeZone;
  }

  EndTime.fromJson(dynamic json) {
    _dateTime = json['dateTime'];
    _timeZone = json['timeZone'];
  }

  String? _dateTime;
  String? _timeZone;

  EndTime copyWith(
    String? dateTime,
    String? timeZone,
  ) =>
      EndTime(
        dateTime: dateTime ?? _dateTime,
        timeZone: timeZone ?? _timeZone,
      );

  String? get dateTime => _dateTime;

  String? get timeZone => _timeZone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dateTime'] = _dateTime;
    map['timeZone'] = _timeZone;
    return map;
  }
}

/// dateTime : ""
/// timeZone : "UTC"

class StartTime {
  StartTime({
    String? dateTime,
    String? timeZone,
  }) {
    _dateTime = dateTime;
    _timeZone = timeZone;
  }

  StartTime.fromJson(dynamic json) {
    _dateTime = json['dateTime'];
    _timeZone = json['timeZone'];
  }

  String? _dateTime;
  String? _timeZone;

  StartTime copyWith(
    String? dateTime,
    String? timeZone,
  ) =>
      StartTime(
        dateTime: dateTime ?? _dateTime,
        timeZone: timeZone ?? _timeZone,
      );

  String? get dateTime => _dateTime;

  String? get timeZone => _timeZone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dateTime'] = _dateTime;
    map['timeZone'] = _timeZone;
    return map;
  }
}
