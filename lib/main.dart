import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_bloc/features/swcu_unit/presentation/bloc/swcu_unit_bloc.dart';
import 'package:mqtt_bloc/features/swcu_unit/presentation/widgets/devices_view.dart';
import 'package:uuid/uuid.dart';

import 'core/globals/global_keys.dart';
import 'core/helpers/mqtt_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SwcuUnitBloc()..add(LoadSwcuUnitsEvent()),
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Mqtt',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Mqtt Client Example'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initMqtt();
    super.initState();
  }

  void initMqtt() async {
    await MqttHelper.instance.initialize(
      clientId: const Uuid().v4(),
      broker: 'sheormveer.impulses-corp.com',
      username: 'impulses',
      password: 'vwj367At3G84jERxsNJS',
    );
    await MqttHelper.instance.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const DevicesView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<SwcuUnitBloc>().add(
                const PublishMessageToTopic("HI-58a5fd94-2cec-42ff-9bf2-8d8564d843c0p/CMD", "<S191"),
              ),
          tooltip: 'Publish',
          child: const Icon(Icons.publish),
        ));
  }
}
