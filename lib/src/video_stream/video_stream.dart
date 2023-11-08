import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:gr_lrr/src/video_stream/video_websocket.dart';
import 'package:gr_lrr/src/video_stream/server_ws_ip.dart';
import 'package:gr_lrr/src/video_stream/styles.dart';

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key}) : super(key: key);

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  final WebSocket video_socket =
      WebSocket(ServerWebsocketAddress.videoWebsocketURL);
  bool video_isConnected = false;

  void connect(BuildContext context) async {
    video_socket.connect();
    setState(() {
      video_isConnected = true;
    });
  }

  void disconnect() {
    print('disconnected');
    video_socket.disconnect();
    setState(() {
      video_isConnected = false;
    });
  }

  // Define the desired width and height for the resized image.
  static const double desiredWidth = 400.0;
  static const double desiredHeight = 300.0;

  // Function to resize the image.
  Widget _resizeImage(Uint8List imageData) {
    final image = Image.memory(
      imageData,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );

    // Resize the image using the `FittedBox` widget.
    return FittedBox(
      fit: BoxFit.cover, // You can choose the desired fit mode.
      child: SizedBox(
        width: desiredWidth,
        height: desiredHeight,
        child: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: desiredWidth,
                height: desiredHeight,
                child: video_isConnected
                    ? StreamBuilder(
                        stream: video_socket.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                height: 40.0,
                                width: 40.0,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                    : const Image(
                        image: AssetImage("assets/images/flutter_logo.png")),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
