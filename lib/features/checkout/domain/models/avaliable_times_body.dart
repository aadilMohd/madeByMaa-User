// To parse this JSON data, do
//
//     final availableTimes = availableTimesFromJson(jsonString);

import 'dart:convert';

AvailableTimes availableTimesFromJson(String str) => AvailableTimes.fromJson(json.decode(str));

String availableTimesToJson(AvailableTimes data) => json.encode(data.toJson());

class AvailableTimes {
  Day? sunday;
  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;

  AvailableTimes({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory AvailableTimes.fromJson(Map<String, dynamic> json) => AvailableTimes(
    sunday: json["sunday"] == null ? null : Day.fromJson(json["sunday"]),
    monday: json["monday"] == null ? null : Day.fromJson(json["monday"]),
    tuesday: json["tuesday"] == null ? null : Day.fromJson(json["tuesday"]),
    wednesday: json["wednesday"] == null ? null : Day.fromJson(json["wednesday"]),
    thursday: json["thursday"] == null ? null : Day.fromJson(json["thursday"]),
    friday: json["friday"] == null ? null : Day.fromJson(json["friday"]),
    saturday: json["saturday"] == null ? null : Day.fromJson(json["saturday"]),
  );

  Map<String, dynamic> toJson() => {
    "sunday": sunday?.toJson(),
    "monday": monday?.toJson(),
    "tuesday": tuesday?.toJson(),
    "wednesday": wednesday?.toJson(),
    "thursday": thursday?.toJson(),
    "friday": friday?.toJson(),
    "saturday": saturday?.toJson(),
  };
}

class Day {
  List<Slot>? slots;

  Day({
    this.slots,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    slots: json["slots"] == null ? [] : List<Slot>.from(json["slots"]!.map((x) => Slot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slots": slots == null ? [] : List<dynamic>.from(slots!.map((x) => x.toJson())),
  };
}

class Slot {
  String? start;
  String? end;

  Slot({
    this.start,
    this.end,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "end": end,
  };
}
