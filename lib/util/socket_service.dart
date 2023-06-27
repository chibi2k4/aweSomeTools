import 'dart:io';

class SocketService {
  Map<int, ServerSocket> serverSocketMap = {};

  void startBlockingPort(int port) async {
    try {
      final serverSocket = await ServerSocket.bind('127.0.0.1', port);

      serverSocket.listen((event) {});

      serverSocketMap[port] = serverSocket;
    } catch (error) {
      print('Welp');
    }
  }

  void stopBlockingPort(int port) {
    serverSocketMap[port]?.close();
    serverSocketMap.remove(port);
  }
}
