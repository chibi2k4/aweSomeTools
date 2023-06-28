import 'dart:io';

import 'package:aweSomeTools/enums/ip.dart';

class SocketService {
  Map<int, ServerSocket> serverSocketMap = {};

  Future<bool> startBlockingPort(int port, IpType ipType) async {
    try {
      final serverSocket = await ServerSocket.bind(ipType.getLocalhost(), port);

      serverSocket.listen((event) {});

      serverSocketMap[port] = serverSocket;
    } catch (error) {
      print('Welp');
      return false;
    }
    return true;
  }

  void stopBlockingPort(int port) {
    serverSocketMap[port]?.close();
    serverSocketMap.remove(port);
  }

  Future<bool> testBlockingPort(int port, IpType ipType) async {
    try {
      await ServerSocket.bind(ipType.getLocalhost(), port);
    } catch (error) {
      return true;
    }
    return false;
  }
}
