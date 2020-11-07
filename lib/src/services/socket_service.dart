import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  Online,
  Offline,
  Coneccting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Coneccting;
  io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get  socket => _socket;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    _socket = io.io('http://192.168.1.53:3030', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
