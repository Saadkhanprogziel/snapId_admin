import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool ticketNotifications = true;
  bool newOrderNotifications = false;
  String selectedScreen = 'Profile Info';

  final TextEditingController nameController =
      TextEditingController(text: 'Marco Kasper');
  final TextEditingController emailController =
      TextEditingController(text: 'admin@SnapID.app');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 789 937 5988');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        // Add SafeArea for top spacing
        child: Padding(
          padding: const EdgeInsets.only(top: 70), //
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildSidebarItem(
                        title: 'Profile Info',
                        isActive: selectedScreen == 'Profile Info',
                        onTap: () =>
                            setState(() => selectedScreen = 'Profile Info'),
                      ),
                      const SizedBox(height: 8),
                      _buildSidebarItem(
                        title: 'Security',
                        isActive: selectedScreen == 'Security',
                        onTap: () =>
                            setState(() => selectedScreen = 'Security'),
                      ),
                      const SizedBox(height: 8),
                      _buildSidebarItem(
                        title: 'Notifications',
                        isActive: selectedScreen == 'Notifications',
                        onTap: () =>
                            setState(() => selectedScreen = 'Notifications'),
                      ),
                      const SizedBox(height: 8),
                      _buildThemeSwitcher(),
                      const Spacer(),
                      // Decorative gears at bottom
                      Container(
                        height: 120,
                        decoration: BoxDecoration(),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF6366F1).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.settings,
                                  size: 40,
                                  color:
                                      const Color(0xFF6366F1).withOpacity(0.3),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 0,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF6366F1).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.settings,
                                  size: 30,
                                  color:
                                      const Color(0xFF6366F1).withOpacity(0.25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main content
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 0.4, color: Colors.grey)),
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        selectedScreen,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Content based on selected screen
                      if (selectedScreen == 'Profile Info')
                        ..._buildProfileInfoContent(context)
                      else if (selectedScreen == 'Security')
                        ..._buildSecurityContent()
                      else if (selectedScreen == 'Notifications')
                        ..._buildNotificationsContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProfileInfoContent(BuildContext context) {
    return [
      // Profile Picture and Label on the left
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE5E7EB),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFE5E7EB), width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Profile Picture',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 40),

      // Row 1: Name and Email
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 24),

      // Row 2: Phone Number and Empty
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(child: SizedBox()), // Empty for alignment
        ],
      ),

      const SizedBox(height: 40),

      // Action buttons
      Row(
        children: [
          OutlinedButton(
            onPressed: () {
              // Handle cancel
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Handle save
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.save_outlined, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSecurityContent() {
    return [
      const Text(
        'Security settings content goes here...',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF6B7280),
        ),
      ),
    ];
  }

  List<Widget> _buildNotificationsContent() {
  return [
    // Notification Card 1
    Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // ← Adjust width here
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ticket Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: ticketNotifications,
                  onChanged: (value) {
                    setState(() {
                      ticketNotifications = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(height: 16),

    // Notification Card 2
    Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // ← Same width
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.4, color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Order Notifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: newOrderNotifications,
                  onChanged: (value) {
                    setState(() {
                      newOrderNotifications = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(height: 40),

    // Action buttons
    Row(
      children: [
        OutlinedButton(
          onPressed: () {
            // Handle cancel
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Handle save
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.save_outlined, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ];
}


  Widget _buildSidebarItem(
      {required String title, required bool isActive, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: !isActive ? Border.all(width: 0.4, color: Colors.grey) : null,
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: CustomTextTheme.regular14.copyWith(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wb_sunny_outlined,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Switch Theme', style: CustomTextTheme.regular14),
                  Text(
                    'Light Mode',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: true,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
