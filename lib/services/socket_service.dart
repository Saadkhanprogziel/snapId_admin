import 'dart:developer';

import 'package:admin/constants/constants.dart';
import 'package:admin/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  

  SocketService() {
    initializeSocketService();
  }

  void initializeSocketService() {
    _socket = IO.io(
      baseSokcetUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': localStorage.getString("token")})
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      log("✅ Socket Connected");
    });

    _socket.onDisconnect((_) {
      log("⚠️ Disconnected from socket");
    });

    _socket.onError((error) {
      log("❌ Socket transport error: $error");
    });

    // Listen for custom error event from backend
    _socket.on("chat_error", (data) {
      // showCustomSnackbar(
      //   context: c,
      //   message: data["error"],
      //   type: SnackbarType.error,
      // );
      log("🚨 Chat error event: ${data["error"]}");
    });
    _socket.on("ticket_error", (data) {

      
      // showCustomSnackbar(
      //   // context: context,
      //   message: data["error"],
      //   type: SnackbarType.error,
      // );

      log("Ticket event: ${data["error"]}");

    });
  }

  /// Listen for incoming messages (switch to `new_message` if your backend uses that)
  void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
    _socket.off("new_message"); // prevent duplicate listeners
    _socket.on("new_message", (data) {
      log("📩 Received message data: $data");
      if (data != null) {
        dataCallBack.call(data);
      }
    });

    log("🔍 Listener initialized: ${_socket.hasListeners("new_message")}");
  }

  /// Generic event listener
  void listenToEvent(String event, dynamic Function(dynamic) callBackData) {
    _socket.on(event, callBackData);
  }

  /// Emit an event with data
  void fireEvent(String event, dynamic data) {
    _socket.emit(event, data);
  }

  /// Disconnect socket
  void disconnect() {
    _socket.disconnect();
    log("🔌 Socket manually disconnected");
  }
}





// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snapid/keys_urls/urls.dart';
// import 'package:snapid/main.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   late IO.Socket _socket;

//   SocketService() {
//     _initializeSocketService();
//   }

//   void _initializeSocketService() {
//     _socket = IO.io(
//       baseUrl,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           // Change to setQuery if your server expects query params instead of auth
//           .setAuth({'token': appStorage.read("token")})
//           .build(),
//     );

//     _socket.connect();

//     _socket.onConnect((_) {
//       log("✅ Socket Connected");
//     });

//     _socket.onDisconnect((_) {
//       log("⚠️ Disconnected from socket");
//     });

//     _socket.onError((error) {
//       log("❌ Socket transport error: $error");
//     });

//     // Listen for custom error event from backend
//     _socket.on("chat_error", (data) {
//       Get.snackbar("Error", data["error"], colorText: Colors.redAccent);
//       log("🚨 Chat error event: ${data["error"]}");
//     });
//   }

//   /// Listen for incoming messages (switch to `new_message` if your backend uses that)
//   void listenToRecieveMessageEvent(void Function(dynamic data) dataCallBack) {
//     _socket.off("new_message"); // prevent duplicate listeners
//     _socket.on("new_message", (data) {
//       log("📩 Received message data: $data");
//       if (data != null) {
//         dataCallBack.call(data);
//       }
//     });

//     log("🔍 Listener initialized: ${_socket.hasListeners("new_message")}");
//   }

//   /// Generic event listener
//   void listenToEvent(String event, dynamic Function(dynamic) callBackData) {
//     _socket.on(event, callBackData);
//   }

//   /// Emit an event with data
//   void fireEvent(String event, dynamic data) {
//     _socket.emit(event, data);
//   }

//   /// Disconnect socket
//   void disconnect() {
//     _socket.disconnect();
//     log("🔌 Socket manually disconnected");
//   }
// }

