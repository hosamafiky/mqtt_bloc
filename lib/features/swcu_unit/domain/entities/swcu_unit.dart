import 'package:equatable/equatable.dart';
import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_device.dart';

class SwcuUnit extends Equatable {
  final List<String> topics;
  final int devicesNumber;
  final List<SwcuDevice> devices;

  const SwcuUnit({
    required this.topics,
    required this.devicesNumber,
    required this.devices,
  });

  SwcuUnit copyWith({
    List<String>? topics,
    int? devicesNumber,
    List<SwcuDevice>? devices,
  }) {
    return SwcuUnit(
      topics: topics ?? this.topics,
      devicesNumber: devicesNumber ?? this.devicesNumber,
      devices: devices ?? this.devices,
    );
  }

  @override
  List<Object?> get props => [topics, devicesNumber, devices];
}
