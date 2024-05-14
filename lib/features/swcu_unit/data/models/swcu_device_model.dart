import 'dart:convert';

import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_device.dart';

class SwcuDeviceModel extends SwcuDevice {
  const SwcuDeviceModel({
    required super.name,
    required super.state,
    required super.dimming,
  });

  factory SwcuDeviceModel.fromMap(Map<String, dynamic> json) {
    return SwcuDeviceModel(
      name: json['deviceName'],
      state: json['light'],
      dimming: json['lighting'],
    );
  }

  factory SwcuDeviceModel.fromJson(String json) => SwcuDeviceModel.fromMap(jsonDecode(json));
}
