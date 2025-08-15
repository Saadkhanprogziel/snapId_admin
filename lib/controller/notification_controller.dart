import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final String dateTime;

  NotificationItem({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.dateTime,
  });
}

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = [
      NotificationItem(
        icon: Icons.calendar_today,
        iconBgColor: Colors.green,
        title: "New Order Received",
        description: "Order ID: #ORD10352",
        dateTime: "May 30, 2025 – 11:45 AM",
      ),
      NotificationItem(
        icon: Icons.music_note,
        iconBgColor: Colors.red,
        title: "New Support Ticket",
        description: "Issue with download",
        dateTime: "June 3, 2025 – 9:08 AM",
      ),
      NotificationItem(
        icon: Icons.attach_money,
        iconBgColor: Colors.green,
        title: "Pricing Updated",
        description: "USA – Passport changed from \$6.99 to \$7.99",
        dateTime: "June 1, 2025 – 4:00 PM",
      ),
      NotificationItem(
        icon: Icons.music_note,
        iconBgColor: Colors.red,
        title: "New Support Ticket",
        description: "Issue with download",
        dateTime: "June 3, 2025 – 9:08 AM",
      ),
    ];
  }
}
