import 'package:flutter/material.dart';
import 'package:gaugge_mqtt_app/mqtt_service.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gauge MQTT App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GaugeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GaugeScreen extends StatefulWidget {
  const GaugeScreen({super.key});

  @override
  State<GaugeScreen> createState() => _GaugeScreenState();
}

class _GaugeScreenState extends State<GaugeScreen> {
  late MqttService _mqttService;
  double _temperature = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Gauge'),
      ),
      body: Center(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: -20,
              maximum: 50,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: -20,
                  endValue: 0,
                  color: Colors.blue,
                ),
                GaugeRange(
                  startValue: 0,
                  endValue: 25,
                  color: Colors.green,
                ),
                GaugeRange(
                  startValue: 25,
                  endValue: 50,
                  color: Colors.red,
                )
              ],
              pointers: <GaugePointer>[NeedlePointer(value: _temperature)],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text(
                    '$_temperature°C',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  angle: 90,
                  positionFactor: 0.5,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _mqttService = MqttService('broker.emqx.io', '');
    _mqttService.getTemperatureStream().listen((temperature) {
      setState(() {
        _temperature = temperature;
      });
    });
  }
}