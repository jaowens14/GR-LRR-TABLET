import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ServerWebsocketAddress {
  static const String videoWebsocketURL = "ws://10.42.0.1:5000";
}

class VideoStream extends StatefulWidget {
  const VideoStream({Key? key}) : super(key: key);

  @override
  State<VideoStream> createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  late final WebSocket videoSocket;
  bool videoIsConnected = false;

  _VideoStreamState()
      : videoSocket = WebSocket(ServerWebsocketAddress.videoWebsocketURL);

  void _connect(BuildContext context) {
    videoSocket.connect();
    setState(() => videoIsConnected = true);
  }

  void _disconnect() {
    print('disconnected');
    videoSocket.disconnect();
    setState(() => videoIsConnected = false);
  }

  Widget _resizeImage(Uint8List imageData) {
    final image = Image.memory(
      imageData,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 400.0,
        height: 300.0,
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
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 400.0,
                  height: 300.0,
                  child: videoIsConnected
                      ? StreamBuilder(
                          stream: videoSocket.stream,
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

                            return _resizeImage(
                              Uint8List.fromList(
                                base64Decode(
                                  snapshot.data.toString(),
                                ),
                              ),
                            );
                          },
                        )
                      : const Image(
                          image: AssetImage("assets/images/vestas.png"),
                        ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _connect(context),
                child: const Text("Connect"),
              ),
              ElevatedButton(
                onPressed: _disconnect,
                child: const Text("Disconnect"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WebSocket {
  late final String url;
  WebSocketChannel? videoChannel;

  WebSocket(this.url);

  String get getUrl => url;

  set setUrl(String url) {
    this.url = url;
  }

  Stream<dynamic> get stream {
    if (videoChannel != null) {
      return videoChannel!.stream;
    } else {
      throw WebSocketChannelException("The connection was not established !");
    }
  }

  void connect() async {
    videoChannel = WebSocketChannel.connect(
        Uri.parse(ServerWebsocketAddress.videoWebsocketURL));
  }

  void disconnect() {
    videoChannel?.sink.close(status.normalClosure);
  }
}
