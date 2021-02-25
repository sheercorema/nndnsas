import 'dart:async';
import 'dart:convert';
// import 'package:adhara_socket_io/adhara_socket_io.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'Globals.dart' as G;

class SocketUtil {
  final _usageData = StreamController<Map<String, dynamic>>();
  // StreamController<Map<String, dynamic>> _usageData;
  dynamic userId;
  IO.Socket socket;
  static const URI = 'http://192.168.195.184:3002/';
  SocketUtil(dynamic id) {
    this.userId = id;
  }

  Stream<Map> get getStream => _usageData.stream;

  initSocket() async {
    this.socket =
        IO.io(URI, IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connected');
      print(this.userId);
      socket.emit("token", [this.userId]);
    });
    // socket.on('message', (data) => print(data));
    socket.onReconnectAttempt((_) => print("reconnect attempt"));
    socket.onDisconnect((_) {
      print('disconnect');
      _usageData.close();
    });
    socket.onError((err) {
      print("sdasad");
      print(err);
    });
    socket.on("sensor-data-snapshot", (incomingData) {
      // print(incomingData['Usage_kW']);
      // var data = json.decode(incomingData);
      // print(data);
      _usageData.sink.add(incomingData);
    });
    // socket.on('fromServer', (_) => print(_));
    // socket.connect();
  }

  sendMessage(String messageType, String message) {
    if (socket != null) {
      // pprint("sending message from '$'...");
      this.socket.emit(messageType, [message]);
      // pprint("Message emitted from '$identifier'...");
    }
  }

  pprint(data) {
    if (data is Map) {
      data = json.encode(data);
    }
    print(data);
  }
}

// socket = IO.io(
//         'http://10.0.2.2:4005',
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .disableAutoConnect()
//             .build());
//     socket.onConnect((_) {
//       print('connect');
//     });
//     socket.onDisconnect((_) => print('disconnect'));
//     socket.on('greet', (data) {
//       print("server says" + data);
//       socket.emit('msg', "HELLO");
//     });
//     socket.connect();
//   }
