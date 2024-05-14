import 'dart:convert';

import 'package:mqtt_bloc/features/swcu_unit/data/models/swcu_device_model.dart';
import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_unit.dart';

class SwcuUnitModel extends SwcuUnit {
  const SwcuUnitModel({
    required super.devices,
    required super.devicesNumber,
    required super.topics,
  });

  factory SwcuUnitModel.fromMap(Map<String, dynamic> json) {
    return SwcuUnitModel(
      devices: (json['devices'] as List).map((e) => SwcuDeviceModel.fromMap(e)).toList(),
      devicesNumber: json['devicesNumber'],
      topics: List<String>.from(json['topic']),
    );
  }

  factory SwcuUnitModel.fromJson(String json) => SwcuUnitModel.fromMap(jsonDecode(json));
}
