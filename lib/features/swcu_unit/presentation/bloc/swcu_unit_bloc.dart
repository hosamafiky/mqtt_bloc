import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_bloc/core/helpers/mqtt_helper.dart';
import 'package:mqtt_bloc/features/swcu_unit/data/models/swcu_unit_model.dart';
import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_unit.dart';

import '../../domain/entities/swcu_device.dart';

part 'swcu_unit_event.dart';
part 'swcu_unit_state.dart';

class SwcuUnitBloc extends Bloc<SwcuUnitEvent, SwcuUnitState> {
  SwcuUnitBloc() : super(const SwcuUnitState()) {
    final tempJson = [
      {
        "topic": [
          "HI-58a5fd94-2cec-42ff-9bf2-8d8564d843c0p/SW",
          "HI-58a5fd94-2cec-42ff-9bf2-8d8564d843c0p/CMD",
          "HI-58a5fd94-2cec-42ff-9bf2-8d8564d843c0p/SENSE"
        ],
        "devicesNumber": 3,
        "devices": [
          {
            "deviceName": "Strip Light",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Window Light",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Wall Light",
            "light": false,
            "lighting": 8,
          }
        ]
      },
      {
        "topic": ["HMB_Main_EGY/025/SW", "HMB_Main_EGY/025/CMD", "HMB_Main_EGY/025/SENSE"],
        "devicesNumber": 3,
        "devices": [
          {
            "deviceName": "Light 1",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 2",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 3",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 4",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 5",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 6",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 7",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 8",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 9",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 10",
            "light": false,
            "lighting": 8,
          },
          {
            "deviceName": "Light 11",
            "light": false,
            "lighting": 8,
          }
        ]
      },
    ];
    on<SwcuUnitEvent>((event, emit) {
      if (event is LoadSwcuUnitsEvent) {
        final units = List<SwcuUnit>.from(tempJson.map((unit) => SwcuUnitModel.fromMap(unit)));
        emit(state.copyWith(units: units));
      }
      if (event is SubscribeToUnitsTopics) {
        for (var unit in state.units) {
          for (var topic in unit.topics) {
            event.subscribeCallback(topic);
          }
        }
      }
      if (event is UpdateUnitDeviceState) {
        final unit = state.units.firstWhere((unit) => unit.topics.contains(event.topic));
        final device = unit.devices[event.deviceIndex];
        final updatedDevice = device.copyWith(state: event.state);
        final updatedDevices = List<SwcuDevice>.from(unit.devices);
        updatedDevices[event.deviceIndex] = updatedDevice;
        final updatedUnit = unit.copyWith(devices: updatedDevices);
        final updatedUnits = List<SwcuUnit>.from(state.units);
        updatedUnits[state.units.indexOf(unit)] = updatedUnit;
        emit(state.copyWith(units: updatedUnits));
      }

      if (event is PublishMessageToTopic) {
        print('Publishing message to topic: ${event.topic}');
        final id = MqttHelper.instance.publish(event.topic, event.message);
        print('Published message with id: $id');
      }
    });
  }
}
