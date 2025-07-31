import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'main.dart';

class sellersetuppage extends StatefulWidget {
  const sellersetuppage({super.key});

  @override
  State<sellersetuppage> createState() => _DeviceReportPageState();
}

class _DeviceReportPageState extends State<sellersetuppage> {
  double dimmingValue = 0.5; // Ranges from 0 (dark) to 1 (bright)
  String deviceVersion = 'Loading...';
  String username = 'test_user'; // Placeholder username
  int numberOfDevices = 3; // Placeholder device count

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  // Fetch platform-specific device info
  Future<void> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    String version;

    if (Platform.isAndroid) {
      AndroidDeviceInfo android = await deviceInfo.androidInfo;
      version = 'Android ${android.version.release}';
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await deviceInfo.iosInfo;
      version = 'iOS ${ios.systemVersion}';
    } else {
      version = 'Unknown Platform';
    }

    setState(() {
      deviceVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Report'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> EmailPasswordLogin()), (Route<dynamic> route) => false);
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Section 1: Adjust Dimming
            const Text(
              'Adjust Dimming',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Slider(
              value: dimmingValue,
              onChanged: (value) {
                setState(() {
                  dimmingValue = value;
                });
              },
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(dimmingValue * 100).toInt()}%',
            ),
            Center(
              child: Text(
                'Brightness: ${(dimmingValue * 100).toInt()}%',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(height: 40),

            // Section 2: Report
            const Text(
              'Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReportItem('Date', currentDate),
            _buildReportItem('Username', username),
            _buildReportItem('Number of Devices', numberOfDevices.toString()),
            _buildReportItem('Device Version', deviceVersion),
          ],
        ),
      ),
    );
  }

  // Reusable row builder for report items
  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
