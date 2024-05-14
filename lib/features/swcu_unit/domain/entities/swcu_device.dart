import 'package:equatable/equatable.dart';

class SwcuDevice extends Equatable {
  final String name;
  final bool state;
  final int dimming;

  const SwcuDevice({
    required this.name,
    required this.state,
    required this.dimming,
  });

  SwcuDevice copyWith({
    String? name,
    bool? state,
    int? dimming,
  }) {
    return SwcuDevice(
      name: name ?? this.name,
      state: state ?? this.state,
      dimming: dimming ?? this.dimming,
    );
  }

  @override
  List<Object?> get props => [name, state, dimming];
}
