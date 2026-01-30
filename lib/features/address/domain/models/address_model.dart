import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';

class AddressModel {
  int? id;
  String? addressType;
  String? contactPersonNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? zoneId;
  List<int>? zoneIds;
  String? method;
  String? contactPersonName;
  String? road;
  String? house;
  String? floor;
  List<ZoneData>? zoneData;
  String? email;
  String? description;

  String? streetName;
  String? cityName;
  String? stateName;
  String? countryName;
  String? pincode;

  AddressModel({
    this.id,
    this.addressType,
    this.contactPersonNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.zoneId,
    this.zoneIds,
    this.method,
    this.contactPersonName,
    this.road,
    this.house,
    this.floor,
    this.zoneData,
    this.email,
    this.description,
    this.streetName,
    this.cityName,
    this.stateName,
    this.countryName,
    this.pincode,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    contactPersonNumber = json['contact_person_number'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    zoneIds = json['zone_ids']?.cast<int>();
    method = json['_method'];
    contactPersonName = json['contact_person_name'];
    floor = json['floor'];
    road = json['road'];
    house = json['house'];
    description = json['description'];
    streetName = json["street_name"];
    cityName = json["city_name"];
    stateName = json["state_name"];
    countryName = json["country_name"];
    pincode = json["pincode"];
    if (json['zone_data'] != null) {
      zoneData = [];
      json['zone_data'].forEach((v) {
        zoneData!.add(ZoneData.fromJson(v));
      });
    }
    if(json['contact_person_email'] != null) {
      email = json['contact_person_email'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_type'] = addressType;
    data['contact_person_number'] = contactPersonNumber;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['zone_id'] = zoneId;
    data['zone_ids'] = zoneIds;
    data['_method'] = method;
    data['contact_person_name'] = contactPersonName;
    data['road'] = road;
    data['house'] = house;
    data['description'] = description;
    data['floor'] = floor;
    data['street_name'] = streetName;
    data['city_name'] = cityName;
    data['state_name'] = stateName;
    data['country_name'] = countryName;
    data['pincode'] = pincode;
    if (zoneData != null) {
      data['zone_data'] = zoneData!.map((v) => v.toJson()).toList();
    }
    if(email != null) {
      data['contact_person_email'] = email;
    }
    return data;
  }
}
