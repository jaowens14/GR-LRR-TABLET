import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:gr_lrr/src/video_stream/websocket.dart';
import 'package:gr_lrr/src/video_stream/server_ws_ip.dart';
import 'package:gr_lrr/src/video_stream/styles.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key}) : super(key: key);

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  final WebSocket _socket = WebSocket(ServerWebsocketAddress.videoWebsocketURL);
  bool _isConnected = false;

  void connect(BuildContext context) async {
    _socket.connect();
    setState(() {
      _isConnected = true;
    });
  }

  void disconnect() {
    print('disconnected');
    _socket.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  // Define the desired width and height for the resized image.
  static const double desiredWidth = 560.0;
  static const double desiredHeight = 420.0;

  // Function to resize the image.
  Widget _resizeImage(Uint8List imageData) {
    final image = Image.memory(
      imageData,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );

    // Resize the image using the `FittedBox` widget.
    return FittedBox(
      child: SizedBox(
        width: desiredWidth,
        height: desiredHeight,
        child: image,
      ),
      fit: BoxFit.cover, // You can choose the desired fit mode.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => connect(context),
                    style: Styles.buttonStyle,
                    child: const Text("Connect"),
                  ),
                  ElevatedButton(
                    onPressed: disconnect,
                    style: Styles.buttonStyle,
                    child: const Text("Disconnect"),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
              _isConnected
                  ? StreamBuilder(
                      stream: _socket.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Center(
                            child: Text("Connection Closed !"),
                          );
                        }
                        //? Working for single frames
                        return _resizeImage(
                          Uint8List.fromList(
                            base64Decode(
                              (snapshot.data.toString()),
                            ),
                          ),
                        );
                      },
                    )
                  : const Text("Initiate Connection")
            ],
          ),
        ),
      ),
    );
  }
}
