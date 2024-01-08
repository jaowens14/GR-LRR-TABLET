import 'package:flutter/material.dart';
import 'package:gr_lrr/src/app_navigation/app_bar.dart';
import 'package:gr_lrr/src/app_navigation/app_drawer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    futureAddresses = fetchAddresses();
  }

  Future<void> _refresh() async {
    setState(() {
      futureAddresses = fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: FutureBuilder<Addresses>(
          future: futureAddresses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text("TEMP"),
                  Text(snapshot.data!.addrs.toString()),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
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
