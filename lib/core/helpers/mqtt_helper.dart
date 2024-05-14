import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_bloc/core/globals/global_keys.dart';
import 'package:mqtt_bloc/features/swcu_unit/presentation/bloc/swcu_unit_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHelper {
  static final MqttHelper instance = MqttHelper._internal();
  MqttHelper._internal();

  late final MqttServerClient _client;
  MqttServerClient get client => _client;

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? subscription;

  late String _username, _password;

  Future<void> initialize({
    required String clientId,
    required String username,
    String broker = '3.21.63.175',
    required String password,
    int port = 1883,
    int maxConnectionAttempts = 65535,
  }) async {
    _username = username;
    _password = password;
    _client = MqttServerClient.withPort(
      broker,
      clientId,
      port,
      maxConnectionAttempts: maxConnectionAttempts,
    );

    final connectionMessage = MqttConnectMessage().withClientIdentifier(clientId).startClean().withWillQos(MqttQos.atLeastOnce);
    _client.logging(on: false);
    _client.connectionMessage = connectionMessage;
    _client.keepAlivePeriod = 65535;
    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.onSubscribeFail = _onSubscribeFail;
    _client.onAutoReconnected = _onAutoReconnected;
  }

  Future<MqttClientConnectionStatus?> connect() async {
    return await _client.connect(_username, _password);
  }

  void _onConnected() {
    log('MQTT : Connected');
    subscription = _client.updates?.listen(_handleUpdates);
    navigatorKey.currentContext?.read<SwcuUnitBloc>().add(SubscribeToUnitsTopics(subscribeToTopic));
  }

  void _onDisconnected() => _client.doAutoReconnect(force: true);

  void _onSubscribed(String topic) {
    log("MQTT : Subscribed to $topic");
  }

  void _onUnsubscribed(String? topic) {
    log('MQTT : Unsubscribed from $topic');
  }

  void _onSubscribeFail(String topic) {
    log('MQTT : Failed to subscribe to $topic');
  }

  void _onAutoReconnected() {
    log('MQTT : Auto-reconnected');
  }

  Subscription? subscribeToTopic(String topic) {
    return _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unsubscribeFromTopic(String topic) {
    log('MQTT : Unsubscribed from $topic');
    return _client.unsubscribe(topic);
  }

  void subscribeToTopics(List<String> topics) {
    for (var topic in topics) {
      subscribeToTopic(topic);
    }
  }

  int publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    return _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  _handleUpdates(List<MqttReceivedMessage<MqttMessage>> update) {
    final MqttPublishMessage recMess = update[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    final String topic = update[0].topic;
    log('MQTT : I got a message on topic $topic');
    log('MQTT : Message --> $message');

    if (message.contains("<S")) {
      final state = message.substring(2).substring(2, 3) == "1" ? true : false;
      final deviceIndex = int.parse(message.substring(2)[0]);
      navigatorKey.currentContext?.read<SwcuUnitBloc>().add(UpdateUnitDeviceState(topic, deviceIndex, state));
    }

    // Do something with the message
    // ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
    //   SnackBar(
    //     content: Text('Message from $topic : $message'),
    //   ),
    // );
  }

  void disconnect() => _client.disconnect();

  void dispose() {
    subscription?.cancel();
    _client.disconnect();
  }
}
