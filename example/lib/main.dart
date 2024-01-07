import 'package:flutter/material.dart';
import 'package:trajectory_data/trajectory_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final TrajectoryData trajectory = TrajectoryData(
      latitude: '-22.9045582',
      longitude: '-43.133525',
      notificationTitle: 'Trajectory Data Library',
      notificationText: 'A plugin to capture trajectory data as a foreground service'
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      //home: MyHomePage(geofence: geofence),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  final String title = 'Trajectory Data Example';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

