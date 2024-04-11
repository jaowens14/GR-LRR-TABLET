import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_navigation/app_bar.dart';
import 'package:gr_lrr/src/app_navigation/app_drawer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:gr_lrr/src/device_communications/DeviceWebsocketIp.dart';

class Addresses {
  final List addrs;

  const Addresses({
    required this.addrs,
  });

  factory Addresses.fromJson(Map<String, dynamic> json) {
    return Addresses(
      addrs: json['ip-addresses'],
    );
  }
}

class MyAPI extends StatefulWidget {
  static const routeName = '/device';
  const MyAPI({Key? key}) : super(key: key);

  @override
  State<MyAPI> createState() => _MyAPIState();
}

class _MyAPIState extends State<MyAPI> {
  late Future<Addresses> futureAddresses;

  TextEditingController _ipFieldController = TextEditingController();

  @override
  void initState() {
    futureAddresses = fetchAddresses();
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      futureAddresses = fetchAddresses();
    });
  }

  Future<void> _setIP() async {
    setState(() {
      DeviceWebsocketAddress.commandsURL = DeviceWebsocketAddress.start +
          _ipFieldController.text +
          DeviceWebsocketAddress.end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              FloatingActionButton(
                  onPressed: _setIP,
                  tooltip: 'set-ip',
                  child: Icon(Icons.settings)),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _ipFieldController,
                    decoration: InputDecoration(labelText: 'New IP Address'),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: _refresh,
                tooltip: 'Refresh',
                child: Icon(Icons.refresh),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<Addresses>(
                    future: futureAddresses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // or any loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data?.addrs == null) {
                        return Text('No addresses available');
                      } else {
                        // Display the addresses
                        final addresses = snapshot.data!.addrs;
                        return Text('Addresses: $addresses');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DeviceWebsocketAddress.commandsURL),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Addresses> fetchAddresses() async {
  final response = await http.get(Uri.parse('http://10.42.0.1:8000/get-ips'));

  if (response.statusCode == 200) {
    return Addresses.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Addresses!!');
  }
}
