import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // For Linear Gauge
import 'package:syncfusion_flutter_sliders/sliders.dart'; // Still needed for sliders if used elsewhere


class ManufacturerSetupPage extends StatefulWidget {
  @override
  State<ManufacturerSetupPage> createState() => _ProgrammingSetupPageState();
}

class _ProgrammingSetupPageState extends State<ManufacturerSetupPage> {
  // Gauge values
  double brightness = 50;
  double solarVoltage = 24;
  double solarPower = 120;
  double batteryVoltage = 12;
  double loadLedPower = 30;

  // Text controllers for form fields
  final TextEditingController tagNameController = TextEditingController();
  final TextEditingController apnController = TextEditingController();
  final TextEditingController numberOfDevicesController =
      TextEditingController(text: '1');

  // Dropdown selection values
  String selectedDeviceVersion = 'v1.0';
  String selectedDeviceType = 'Type A';

  // Dropdown options
  List<String> deviceVersions = ['v1.0', 'v2.0', 'v3.0'];
  List<String> deviceTypes = ['Type A', 'Type B', 'Type C'];

  bool isRMSSelected = false;

  // Reset all form values
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

  // Simulate configuration generation
  void onGenerate() {
    print('Tag: ${tagNameController.text}');
    print('Device Count: ${numberOfDevicesController.text}');
    print('Version: $selectedDeviceVersion');
    print('Type: $selectedDeviceType');
    if (isRMSSelected) {
      print('RMS is enabled. APN: ${apnController.text}');
    }
    print('Configuration generated!');
  }

  // Gauge builder with only violet bar (interactive)
  Widget buildLinearGauge(String label, double value, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        // Linear gauge without blue bar
        SfLinearGauge(
          minimum: 0,
          maximum: max,
          showTicks: true,
          showLabels: true,
          showAxisTrack: false, // Hides the default blue background track
          barPointers: const [], // Remove blue fill bar
          markerPointers: [
            LinearShapePointer(
              value: value,
              color: Colors.black, // Pointer color
            )
          ],
        ),
        // Slider to control the gauge
        Slider(
          value: value,
          min: 0,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.purple,
          inactiveColor: Colors.purple.shade100,
        ),
        Text(value.toStringAsFixed(0)),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programming Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gauges with updated visuals
            buildLinearGauge("Brightness", brightness, 100, (val) {
              setState(() => brightness = val);
            }),
            buildLinearGauge("Solar Panel Voltage", solarVoltage, 48, (val) {
              setState(() => solarVoltage = val);
            }),
            buildLinearGauge("Solar Panel Power", solarPower, 500, (val) {
              setState(() => solarPower = val);
            }),
            buildLinearGauge("Battery Voltage", batteryVoltage, 24, (val) {
              setState(() => batteryVoltage = val);
            }),
            buildLinearGauge("Load LED Power", loadLedPower, 100, (val) {
              setState(() => loadLedPower = val);
            }),

            // Form fields
            TextField(
              controller: numberOfDevicesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Number of Devices"),
            ),
            TextField(
              controller: tagNameController,
              decoration: const InputDecoration(labelText: "Tag Name"),
            ),
            const SizedBox(height: 16),

            // Dropdowns
            DropdownButtonFormField<String>(
              value: selectedDeviceVersion,
              items: deviceVersions
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDeviceVersion = val!),
              decoration: const InputDecoration(labelText: "Device Version"),
            ),
            DropdownButtonFormField<String>(
              value: selectedDeviceType,
              items: deviceTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDeviceType = val!),
              decoration: const InputDecoration(labelText: "Device Type"),
            ),

            // RMS toggle
            Row(
              children: [
                Checkbox(
                  value: isRMSSelected,
                  onChanged: (val) => setState(() => isRMSSelected = val!),
                ),
                const Text("With RMS?")
              ],
            ),

            // APN input
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

            // Report placeholder
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
