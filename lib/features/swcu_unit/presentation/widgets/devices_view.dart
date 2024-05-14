import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_bloc/core/extensions/swcu_unit_build_when.dart';

import '../bloc/swcu_unit_bloc.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwcuUnitBloc, SwcuUnitState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          children: [
            for (var unit in state.units)
              for (var device in unit.devices)
                BlocBuilder<SwcuUnitBloc, SwcuUnitState>(
                  buildWhen: (previous, current) => swcuDeviceComparator(
                    previous,
                    current,
                    unit,
                    device,
                    (a, b) => a.state != b.state,
                  ),
                  builder: (context, state) {
                    print("rebuilt");
                    return Column(
                      children: [
                        Text("Unit ${unit.topics[0].split("/").last}"),
                        Text(
                          "Device name :\n${device.name}",
                          textAlign: TextAlign.center,
                        ),
                        Text("Device state: ${device.state}"),
                      ],
                    );
                  },
                ),
          ],
        );
      },
    );
  }
}
