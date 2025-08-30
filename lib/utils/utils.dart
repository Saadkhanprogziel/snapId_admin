import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';




List<T> parseList<T>(
  data,
  T Function(Map<String, dynamic>) fromJson,
) {
  final parsedData = (data as List?)?.cast<Map<String, dynamic>>();
  return parsedData?.map(fromJson).toList().cast<T>() ?? [];
}

FocusNode getFieldFocusNode(void Function() callBack) {
  return FocusNode(
    onKeyEvent: (node, evt) {
      if (!HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
        if (evt is KeyDownEvent) {
          callBack.call();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
}

enum SnackbarType { success, info, warning, error }

OverlayEntry? _currentSnackbar;

Future<void> showCustomSnackbar({
  required BuildContext context,
  required String message,
  SnackbarType type = SnackbarType.info,
  Duration duration = const Duration(seconds: 2),
  String? actionLabel,
  VoidCallback? onActionPressed,
}) async {
  // Dismiss any existing snackbar
  if (_currentSnackbar != null) {
    _currentSnackbar!.remove();
    _currentSnackbar = null;
  }

  final Color bgColor;
  final IconData icon;

  switch (type) {
    case SnackbarType.success:
      bgColor = Colors.green;
      icon = Icons.check_circle;
    case SnackbarType.info:
      bgColor = Colors.blue;
      icon = Icons.info;
    case SnackbarType.warning:
      bgColor = Colors.amber;
      icon = Icons.warning;
    case SnackbarType.error:
      bgColor = Colors.red;
      icon = Icons.error;
  }

  final progressController = StreamController<double>();
  Timer? timer;

  final interval = duration.inMilliseconds ~/ 60;
  const step = 1 / 60;
  var progress = 0.0;

  final completer = Completer<void>();

  _currentSnackbar = OverlayEntry(
    builder: (context) {
      return SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(icon,
                            color: Colors.white.withOpacity(0.8), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (actionLabel != null)
                          TextButton(
                            onPressed: () {
                              onActionPressed?.call();
                              _closeSnackbar(timer, progressController);
                            },
                            child: Text(
                              actionLabel,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            _closeSnackbar(timer, progressController);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<double>(
                      stream: progressController.stream,
                      builder: (context, snapshot) {
                        return LinearProgressIndicator(
                          value: snapshot.data ?? 0.0,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.8),
                          ),
                          minHeight: 2,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(_currentSnackbar!);

  timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
    progress += step;
    if (progress >= 1.0) {
      _closeSnackbar(timer, progressController);
      completer.complete();
    } else {
      progressController.add(progress);
    }
  });

  return completer.future;
}

void _closeSnackbar(Timer? timer, StreamController<double> controller) {
  timer?.cancel();
  controller.close();
  if (_currentSnackbar != null) {
    _currentSnackbar!.remove();
    _currentSnackbar = null;
  }
}

String getNumberWithCommas(num number) {
  final formatter = NumberFormat('#,##0', "en");
  return formatter.format(number);
}

// double calculateInterval(List<RevenueAxis> revenueList) {
//   if (revenueList.isEmpty) return 10;
//   final maxY = revenueList.map((e) => e.y).reduce((a, b) => a > b ? a : b);
//   if (maxY <= 100) return 10;
//   if (maxY <= 500) return 50;
//   return 100;
// }

String formatBigDouble(num value) {
  final str = value.toStringAsFixed(2);
  if (str.contains('e') || str.contains('E')) {
    final big = BigInt.parse(
        value.toStringAsExponential(0).replaceAll(RegExp(r'\.|\+|e'), ''));
    return "$big.00";
  }

  return str;
}
