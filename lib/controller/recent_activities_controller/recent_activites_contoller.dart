import 'package:admin/models/chartsTablesModel.dart';
import 'package:get/get.dart';

class RecentActivitesContoller extends GetxController {
  
List<UserActivityModel> dummyActivities = [
    UserActivityModel(
      time: "2023-05-15 10:30 AM",
      name: "John Doe",
      email: "john.doe@example.com",
      activity: "Uploaded Photo",
      plateform: "Android", 
    ),
    UserActivityModel(
      time: "2023-05-15 11:15 AM",
      name: "Alice Smith",
      email: "alice.smith@example.com",
      activity: "Signed Up (Google)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-15 12:45 PM",
      name: "Bob Johnson",
      email: "bob.johnson@example.com",
      activity: "Made a payment (\$29.99)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-16 09:20 AM",
      name: "Emma Wilson",
      email: "emma.wilson@example.com",
      activity: "Uploaded Photo",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-16 02:10 PM",
      name: "Michael Brown",
      email: "michael.brown@example.com",
      activity: "Signed Up (Email)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-17 03:45 PM",
      name: "Sarah Davis",
      email: "sarah.davis@example.com",
      activity: "Made a payment (\$9.99)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-18 08:30 AM",
      name: "David Miller",
      email: "david.miller@example.com",
      activity: "Uploaded Photo",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-18 01:15 PM",
      name: "Olivia Taylor",
      email: "olivia.taylor@example.com",
      activity: "Signed Up (Apple)",
      plateform: "iOS",
    ),
    UserActivityModel(
      time: "2023-05-19 04:50 PM",
      name: "James Wilson",
      email: "james.wilson@example.com",
      activity: "Made a payment (\$49.99)",
      plateform: "Android",
    ),
    UserActivityModel(
      time: "2023-05-20 10:05 AM",
      name: "Sophia Martinez",
      email: "sophia.martinez@example.com",
      activity: "Uploaded Photo",
      plateform: "iOS",
    ),
  ];
}