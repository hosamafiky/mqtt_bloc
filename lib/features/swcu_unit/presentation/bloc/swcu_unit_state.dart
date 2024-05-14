part of 'swcu_unit_bloc.dart';

class SwcuUnitState extends Equatable {
  final List<SwcuUnit> units;

  const SwcuUnitState({
    this.units = const <SwcuUnit>[],
  });

  SwcuUnitState copyWith({
    List<SwcuUnit>? units,
  }) {
    return SwcuUnitState(
      units: units ?? this.units,
    );
  }

  @override
  List<Object?> get props => [units];
}
