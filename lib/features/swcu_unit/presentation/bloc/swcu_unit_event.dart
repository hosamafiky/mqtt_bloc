part of 'swcu_unit_bloc.dart';

abstract class SwcuUnitEvent extends Equatable {
  const SwcuUnitEvent();

  @override
  List<Object> get props => [];
}

class LoadSwcuUnitsEvent extends SwcuUnitEvent {}

class SubscribeToUnitsTopics extends SwcuUnitEvent {
  final Function(String) subscribeCallback;
  const SubscribeToUnitsTopics(this.subscribeCallback);
}

class UpdateUnitDeviceState extends SwcuUnitEvent {
  final String topic;
  final int deviceIndex;
  final bool state;
  const UpdateUnitDeviceState(this.topic, this.deviceIndex, this.state);
}

class PublishMessageToTopic extends SwcuUnitEvent {
  final String topic;
  final String message;
  const PublishMessageToTopic(this.topic, this.message);
}
