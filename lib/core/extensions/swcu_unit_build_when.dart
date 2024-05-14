import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_device.dart';
import 'package:mqtt_bloc/features/swcu_unit/domain/entities/swcu_unit.dart';
import 'package:mqtt_bloc/features/swcu_unit/presentation/bloc/swcu_unit_bloc.dart';

bool swcuUnitComparator(SwcuUnitState previous, SwcuUnitState current, SwcuUnit unit, bool Function(SwcuUnit, SwcuUnit) comparator) {
  return comparator(
    previous.units.firstWhere((element) => element.topics == unit.topics),
    current.units.firstWhere((element) => element.topics == unit.topics),
  );
}

bool swcuDeviceComparator(SwcuUnitState previous, SwcuUnitState current, SwcuUnit unit, SwcuDevice device, bool Function(SwcuDevice, SwcuDevice) comparator) {
  return comparator(
    previous.units.firstWhere((element) => element.topics == unit.topics).devices.firstWhere((element) => element.name == device.name),
    current.units.firstWhere((element) => element.topics == unit.topics).devices.firstWhere((element) => element.name == device.name),
  );
}
