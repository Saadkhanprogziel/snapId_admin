import 'package:admin/controller/app_controller.dart';
import 'package:admin/controller/user_management_controller/user_info_detail_controller/user_info_detail_controller.dart';
import 'package:admin/models/users/users_model.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:admin/utils/custom_spaces.dart';
import 'package:admin/views/user_management/user_details/widgets/basic_info.dart';
import 'package:admin/views/user_management/user_details/widgets/moderation_info.dart';
import 'package:admin/views/user_management/user_details/widgets/orders_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoContent extends StatelessWidget {
  String _formatDateTime(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${date.year.toString().padLeft(4, '0')}-${twoDigits(date.month)}-${twoDigits(date.day)} ${twoDigits(date.hour)}:${twoDigits(date.minute)}";
  }
  final UsersModel? userModel;
  const UserInfoContent({super.key, this.userModel});

  
  @override
  Widget build(BuildContext context) {
    final UserInfoDetailController userInfoController =
        Get.put(UserInfoDetailController());
    final AppController drawerController = Get.find<AppController>();

    if (userModel != null) {
      userInfoController.setUserModel(userModel!);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 30, 
          vertical: isMobile ? 16 : 25
        ),
        child: Column(
          children: [
            SpaceH20(),
            // Header with back button and title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    drawerController.closeDrawer(),
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Color(0xFF23272F)
                              : const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: isDark ? Colors.white : Color(0xFF6B7280),
                        ),
                      ),
                      if (!isMobile) SpaceW20(),
                      if (!isMobile)
                        Text(
                          "User information",
                          style: CustomTextTheme.regular20.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                    ],
                  ),
                ),
                // Mobile title
                if (isMobile)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: Text(
                        "User Info",
                        style: CustomTextTheme.regular20.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                Obx(() {
                  final user = userInfoController.userModel.value;
                  final isBlocked = user?.isActive.toLowerCase() == "blocked";
                  final isDeleted = user?.isActive.toLowerCase() == "deleted";
                  if (isDeleted) {
                    return const SizedBox.shrink();
                  }
                  return InkWell(
                    onTap: () async {
                      if (isBlocked) {
                        userInfoController.unblockUser(context);
                      } else {
                        final dialogContext = context;
                        final result = await showDialog<bool>(
                          context: dialogContext,
                          barrierDismissible: false,
                          builder: (context) {
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;
                            return AlertDialog(
                              backgroundColor: isDark
                                  ? const Color(0xFF23272F)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              title: Text(
                                'Block User',
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: SizedBox(
                                width: isMobile ? double.maxFinite : 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Please provide a reason for blocking this user:',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller:
                                          userInfoController.reasonBlocking,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Reason',
                                        labelStyle: TextStyle(
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey[700],
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? const Color(0xFF2C2F36)
                                            : Colors.grey[100],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.white24
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.blueAccent
                                                : Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      autofocus: true,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    userInfoController.reasonBlocking.clear();
                                    Navigator.of(context).pop(false);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (userInfoController.reasonBlocking.text
                                        .trim()
                                        .isNotEmpty) {
                                      Navigator.of(context).pop(true);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please provide a reason for blocking'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isDark ? Colors.redAccent : Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  child: const Text('Block',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            );
                          },
                        );
                        if (result == true && dialogContext.mounted) {
                          userInfoController.blockUser(dialogContext);
                        } else if (result != true) {
                          userInfoController.reasonBlocking.clear();
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 16, 
                          vertical: 8
                      ),
                      decoration: BoxDecoration(
                        color: isBlocked
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isBlocked
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isBlocked ? "Unblock" : "Block",
                            style: TextStyle(
                              color: isBlocked ? Colors.green : Colors.red,
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: isMobile ? 2 : 4),
                          Icon(
                            isBlocked ? Icons.lock_open : Icons.block,
                            size: isMobile ? 14 : 16,
                            color: isBlocked ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
            SizedBox(height: isMobile ? 20 : 40),
            
            // Mobile Navigation (horizontal tabs at top)
            if (isMobile) ...[
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Obx(() => _buildMobileNavItem(
                            title: 'Basic Info',
                            icon: Icons.person_outline,
                            isActive: userInfoController.selectedScreen.value == 'Basic Info',
                            isDark: isDark,
                            onTap: () => userInfoController.changeScreen('Basic Info'),
                          )),
                      const SizedBox(width: 8),
                      Obx(() => _buildMobileNavItem(
                            title: 'Orders',
                            icon: Icons.receipt_long_outlined,
                            isActive: userInfoController.selectedScreen.value == 'Orders',
                            isDark: isDark,
                            onTap: () => userInfoController.changeScreen('Orders'),
                          )),
                      const SizedBox(width: 8),
                      Obx(() => _buildMobileNavItem(
                            title: 'Moderation',
                            icon: Icons.security_outlined,
                            isActive: userInfoController.selectedScreen.value == 'Moderation History',
                            isDark: isDark,
                            onTap: () => userInfoController.changeScreen('Moderation History'),
                          )),
                    ],
                  ),
                ),
              ),
            ],
            
            // Main content area
            Expanded(
              child: isMobile 
                ? _buildMobileContent(userInfoController, isDark)
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Desktop/Tablet Sidebar
                      Container(
                        width: isTablet ? 280 : 300,
                        child: Column(
                          children: [
                            Obx(() => _buildSidebarItem(
                                  title: 'Basic Info',
                                  icon: Icons.person_outline,
                                  isActive: userInfoController.selectedScreen.value == 'Basic Info',
                                  isDark: isDark,
                                  onTap: () => userInfoController.changeScreen('Basic Info'),
                                )),
                            const SizedBox(height: 8),
                            Obx(() => _buildSidebarItem(
                                  title: 'Orders',
                                  icon: Icons.receipt_long_outlined,
                                  isActive: userInfoController.selectedScreen.value == 'Orders',
                                  isDark: isDark,
                                  onTap: () => userInfoController.changeScreen('Orders'),
                                )),
                            const SizedBox(height: 8),
                            Obx(() => _buildSidebarItem(
                                  title: 'Moderation History',
                                  icon: Icons.security_outlined,
                                  isActive: userInfoController.selectedScreen.value == 'Moderation History',
                                  isDark: isDark,
                                  onTap: () => userInfoController.changeScreen('Moderation History'),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 20),
                      // Desktop/Tablet Content
                      Expanded(
                        child: _buildDesktopContent(userInfoController, isDark, isTablet),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile navigation item
  Widget _buildMobileNavItem({
    required String title,
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: !isActive
              ? Border.all(width: 0.5, color: Colors.grey.shade500)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive || isDark ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isActive || isDark ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile content layout
  Widget _buildMobileContent(UserInfoDetailController userInfoController, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.5, color: Colors.grey.shade500),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                userInfoController.selectedScreen.value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Color(0xFF1F2937),
                ),
              )),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (userInfoController.selectedScreen.value == 'Basic Info') {
                return BasicInfoScreen(userModel: userModel);
              } else if (userInfoController.selectedScreen.value == 'Orders') {
                return OrdersScreen(
                    userInfoController: userInfoController, isDark: isDark);
              } else if (userInfoController.selectedScreen.value == 'Moderation History') {
                return ModerationHistoryScreen(
                    userInfoController: userInfoController, 
                    isDark: isDark, 
                    formatDateTime: _formatDateTime);
              }
              return const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  // Desktop/Tablet content layout
  Widget _buildDesktopContent(UserInfoDetailController userInfoController, bool isDark, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF23272F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.5, color: Colors.grey.shade500),
      ),
      padding: EdgeInsets.all(isTablet ? 30 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                userInfoController.selectedScreen.value,
                style: TextStyle(
                  fontSize: isTablet ? 24 : 28,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Color(0xFF1F2937),
                ),
              )),
          const SizedBox(height: 30),
          Expanded(
            child: Obx(() {
              if (userInfoController.selectedScreen.value == 'Basic Info') {
                return BasicInfoScreen(userModel: userModel);
              } else if (userInfoController.selectedScreen.value == 'Orders') {
                return OrdersScreen(
                    userInfoController: userInfoController, isDark: isDark);
              } else if (userInfoController.selectedScreen.value == 'Moderation History') {
                return ModerationHistoryScreen(
                    userInfoController: userInfoController, 
                    isDark: isDark, 
                    formatDateTime: _formatDateTime);
              }
              return const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
    bool isDark = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: !isActive
            ? Border.all(width: 0.5, color: Colors.grey.shade500)
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 20,
          color: isActive || isDark ? Colors.white : Colors.grey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive || isDark ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}