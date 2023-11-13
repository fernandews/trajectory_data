import 'package:flutter/material.dart';
import 'package:trajectory_data/trajectory_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

  //final geolocationService = GeolocationServiceTask();
  //geolocationService.startGeolocationService();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GeofenceController geofence = GeofenceController('-22.4024409', '-43.134778');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: MyHomePage(geofence: geofence),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.geofence});

  final GeofenceController geofence;
  final String title = 'TCC de Jana e Paula';

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
          children: <Widget>[
            GeofenceStatusWidget(geofenceController: widget.geofence),
            TrajectoryApiStatusWidget()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

