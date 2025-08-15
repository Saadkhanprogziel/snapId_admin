import 'package:admin/models/chartsTablesModel.dart';
import 'package:admin/models/activityUserInfo/activity_user_info.dart';
import 'package:get/get.dart';

class UserInfoDetailController extends GetxController {
  var currentPage = 0.obs;
    final RxList<OrderData> orderList = <OrderData>[
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
    OrderData(
        orderId: 'ORD-1001',
        userEmail: 'john.doe@example.com',
        notes: 'Please deliver ASAP',
        date: '2025-08-01',
        subscription: 'Gold',
        amount: 150.00,
        status: 'Pending',
      ),
      OrderData(
        orderId: 'ORD-1002',
        userEmail: 'jane.smith@example.com',
        notes: 'Gift item, handle with care',
        date: '2025-08-02',
        subscription: 'Silver',
        amount: 89.99,
        status: 'Completed',
      ),
      OrderData(
        orderId: 'ORD-1003',
        userEmail: 'mark.brown@example.com',
        notes: 'Leave at doorstep',
        date: '2025-08-03',
        subscription: 'Platinum',
        amount: 299.49,
        status: 'Failed',
      ),
  ].obs;


   List<ActivityUserInfo> getActivities=  [
      ActivityUserInfo(dateTime: 'May 30, 2025 — 2:45 PM', activity: 'Made a payment', platform: 'iOS'),
      ActivityUserInfo(dateTime: 'June 15, 2025 — 4:15 AM', activity: 'Signed up (Google)', platform: 'Android'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'May 30, 2025 — 2:45 PM', activity: 'Made a payment', platform: 'iOS'),
      ActivityUserInfo(dateTime: 'June 15, 2025 — 4:15 AM', activity: 'Signed up (Google)', platform: 'Android'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
    ].obs;
  
   List<ActivityUserInfo> orders=  [
      ActivityUserInfo(dateTime: 'May 30, 2025 — 2:45 PM', activity: 'Made a payment', platform: 'iOS'),
      ActivityUserInfo(dateTime: 'June 15, 2025 — 4:15 AM', activity: 'Signed up (Google)', platform: 'Android'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'May 30, 2025 — 2:45 PM', activity: 'Made a payment', platform: 'iOS'),
      ActivityUserInfo(dateTime: 'June 15, 2025 — 4:15 AM', activity: 'Signed up (Google)', platform: 'Android'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
      ActivityUserInfo(dateTime: 'June 09, 2025 — 1:25 AM', activity: 'Uploaded a photo', platform: 'Web app'),
    ].obs;
  
  
    var selectedScreen = 'Basic Info'.obs;
  void changeScreen(String screen) => selectedScreen.value = screen;


  // 'May 30, 2025 — 2:45 PM', 'Made a payment', 'iOS

}