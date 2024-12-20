import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../src/video_stream/video_websocket.dart';
import '../../../src/video_stream/server_ws_ip.dart';
import '../../../src/video_stream/styles.dart';

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
  static const double desiredHeight = 0.75 * desiredWidth;

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
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0)),
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
                          image: AssetImage("assets/images/vestas.png")),
                ),
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


import 'dart:async';

import '../../../src/video_stream/server_ws_ip.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocket {
  // ------------------------- Members ------------------------- //
  late String url;
  WebSocketChannel? video_channel;
  StreamController<bool> streamController = StreamController<bool>.broadcast();

  // ---------------------- Getter Setters --------------------- //
  String get getUrl {
    return url;
  }

  set setUrl(String url) {
    this.url = url;
  }

  Stream<dynamic> get stream {
    if (video_channel != null) {
      return video_channel!.stream;
    } else {
      throw WebSocketChannelException("The connection was not established !");
    }
  }

  // --------------------- Constructor ---------------------- //
  WebSocket(this.url);

  // ---------------------- Functions ----------------------- //

  /// Connects the current application to a websocket
  void connect() async {
    video_channel = WebSocketChannel.connect(
        Uri.parse(ServerWebsocketAddress.videoWebsocketURL));
  }

  /// Disconnects the current application from a websocket
  void disconnect() {
    if (video_channel != null) {
      video_channel!.sink.close(status.normalClosure);
    }
  }
}
