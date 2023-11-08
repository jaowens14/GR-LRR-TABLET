import 'dart:async';

import 'package:gr_lrr/src/video_stream/server_ws_ip.dart';
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
      video_channel!.sink.close(status.goingAway);
    }
  }
}