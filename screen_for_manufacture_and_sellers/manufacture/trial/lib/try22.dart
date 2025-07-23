import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart'; // Required for SfSlider

void main() {
  runApp(MaterialApp(
    home: ProgrammingSetupPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class ProgrammingSetupPage extends StatefulWidget {
  @override
  _ProgrammingSetupPageState createState() => _ProgrammingSetupPageState();
}

class _ProgrammingSetupPageState extends State<ProgrammingSetupPage> {
  // Gauge values
  double brightness = 50;
  double solarVoltage = 24;
  double solarPower = 120;
  double batteryVoltage = 12;
  double loadLedPower = 30;

  // Text field controllers
  final TextEditingController tagNameController = TextEditingController();
  final TextEditingController apnController = TextEditingController();
  final TextEditingController numberOfDevicesController =
      TextEditingController(text: '1');

  // Dropdown selections
  String selectedDeviceVersion = 'v1.0';
  String selectedDeviceType = 'Type A';

  // Dropdown options
  List<String> deviceVersions = ['v1.0', 'v2.0', 'v3.0'];
  List<String> deviceTypes = ['Type A', 'Type B', 'Type C'];

  // Checkbox flag
  bool isRMSSelected = false;

  // Resets all fields and values
  void onReset() {
    setState(() {
      brightness = 50;
      solarVoltage = 24;
      solarPower = 120;
      batteryVoltage = 12;
      loadLedPower = 30;
      numberOfDevicesController.text = '1';
      tagNameController.clear();
      apnController.clear();
      selectedDeviceVersion = 'v1.0';
      selectedDeviceType = 'Type A';
      isRMSSelected = false;
    });
  }

  // Handles Generate button logic
  void onGenerate() {
    final tag = tagNameController.text;
    final deviceCount = numberOfDevicesController.text;

    print('Tag: $tag');
    print('Device Count: $deviceCount');
    print('Version: $selectedDeviceVersion');
    print('Type: $selectedDeviceType');

    if (isRMSSelected) {
      print('RMS is enabled. APN: ${apnController.text}');
      // TODO: Integrate with ThingsBoard (TB) to create device and fetch access token
    }

    print('Configuration generated!');
  }

  // Builds an interactive gauge with a slider to adjust its value
  Widget buildInteractiveGauge({
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SfLinearGauge(
          minimum: 0,
          maximum: max,
          showTicks: true,
          showLabels: true,
          showAxisTrack: true,
          barPointers: [
            LinearBarPointer(value: value, color: Colors.blue),
          ],
          markerPointers: [
            LinearShapePointer(value: value),
          ],
        ),
        // Slider to control the gauge value
        SfSlider(
          value: value,
          min: 0.0,
          max: max,
          stepSize: 1,
          showLabels: true,
          enableTooltip: true,
          onChanged: (val) => onChanged(val as double), // Fix: cast to double
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // UI Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programming Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive gauges
            buildInteractiveGauge(
              label: "Brightness",
              value: brightness,
              max: 100,
              onChanged: (val) => setState(() => brightness = val),
            ),
            buildInteractiveGauge(
              label: "Solar Panel Voltage",
              value: solarVoltage,
              max: 48,
              onChanged: (val) => setState(() => solarVoltage = val),
            ),
            buildInteractiveGauge(
              label: "Solar Panel Power",
              value: solarPower,
              max: 500,
              onChanged: (val) => setState(() => solarPower = val),
            ),
            buildInteractiveGauge(
              label: "Battery Voltage",
              value: batteryVoltage,
              max: 24,
              onChanged: (val) => setState(() => batteryVoltage = val),
            ),
            buildInteractiveGauge(
              label: "Load LED Power",
              value: loadLedPower,
              max: 100,
              onChanged: (val) => setState(() => loadLedPower = val),
            ),

            // Number of devices input
            TextField(
              controller: numberOfDevicesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Number of Devices"),
            ),

            // Tag name input
            TextField(
              controller: tagNameController,
              decoration: const InputDecoration(labelText: "Tag Name"),
            ),

            const SizedBox(height: 16),

            // Device version dropdown
            DropdownButtonFormField<String>(
              value: selectedDeviceVersion,
              items: deviceVersions
                  .map((version) => DropdownMenuItem(
                        value: version,
                        child: Text(version),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDeviceVersion = val!;
                });
              },
              decoration: const InputDecoration(labelText: "Device Version"),
            ),

            // Device type dropdown
            DropdownButtonFormField<String>(
              value: selectedDeviceType,
              items: deviceTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDeviceType = val!;
                });
              },
              decoration: const InputDecoration(labelText: "Device Type"),
            ),

            // RMS Checkbox
            Row(
              children: [
                Checkbox(
                  value: isRMSSelected,
                  onChanged: (val) {
                    setState(() {
                      isRMSSelected = val ?? false;
                    });
                  },
                ),
                const Text("With RMS?")
              ],
            ),

            // APN input shown only if RMS selected
            if (isRMSSelected)
              TextField(
                controller: apnController,
                decoration: const InputDecoration(labelText: "APN Endpoint"),
              ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: onReset,
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onGenerate,
                  child: const Text("Generate"),
                ),
              ],
            ),

            const Divider(height: 40),

            // Reports Section (Static for now)
            Text("Reports", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),

            ListTile(
              title: const Text("FW Generation History Report"),
              subtitle: const Text("Date, Tag, FW Version, Username"),
            ),
            ListTile(
              title: const Text("Device Program/Test Report from RP"),
              subtitle: const Text("Data not yet available"),
            ),
          ],
        ),
      ),
    );
  }
}
