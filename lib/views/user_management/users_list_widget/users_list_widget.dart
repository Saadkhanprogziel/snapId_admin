
import 'package:admin/controller/user_management_controller/user_management_controller.dart';
import 'package:admin/models/country_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListWidget extends StatelessWidget {
  final UserManagementController controller;
  final bool isMobile;
  final bool isTablet;
  
  const UsersListWidget({
    Key? key, 
    required this.controller,
    this.isMobile = false,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : isTablet ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs and Actions Row
          _buildHeaderSection(),
          
          SizedBox(height: isMobile ? 20 : isTablet ? 24 : 32),
          _buildTableHeader(),


          // Table Content
          Expanded(
            child: Obx(() {
              

              return ListView.builder(
                itemCount: controller.orderList.length,
                itemBuilder: (context, index) =>
                    _buildTableRow(controller.orderList[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(child: _buildActionButton(Icons.download, "Export")),
              const SizedBox(width: 8),
              Expanded(child: _buildActionButton(Icons.filter_list, "Filter")),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          
          _buildActionButton(Icons.download, "Export"),
          const SizedBox(width: 8),
          _buildActionButton(Icons.filter_list, "Filter"),
        ],
      );
    }
  }

  Widget _buildTableHeader() {
    if (isMobile) {
      // Mobile: Show simplified header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: 
               const [
                  Expanded(flex: 2, child: Text('User ID', style: _headerStyle)),
                  Expanded(flex: 3, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
                  SizedBox(width: 60, child: Text('Actions', style: _headerStyle)),
                ],
        ),
      );
    } else if (isTablet) {
      // Tablet: Show medium complexity header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: const [
                  Expanded(flex: 1, child: Text('User ID', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Email', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Subscription', style: _headerStyle)),
                  SizedBox(width: 70, child: Text('Actions', style: _headerStyle)),
                ]
           
        ),
      );
    } else {
      // Desktop: Show full header
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: const [
                  Expanded(flex: 1, child: Text('User ID', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Email', style: _headerStyle)),
                  Expanded(flex: 3, child: Text('Signup Date', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Subscription', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Signup Method', style: _headerStyle)),
                  Expanded(flex: 2, child: Text('Plateform', style: _headerStyle)),
                  SizedBox(width: 80, child: Text('Actions', style: _headerStyle)),
                ]
              
        ),
      );
    }
  }

  Widget _buildTableRow(UserTableModel data,) {
    final padding = isMobile ? 8.0 : isTablet ? 12.0 : 16.0;
    
    if (isMobile) {
      // Mobile: Simplified row
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: 
              [
                  Expanded(flex: 2, child: Text(data.userId ?? "", style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 3, child: Text("${data.name}", style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(data.status ?? "", style: _rowStyle)),
                  SizedBox(width: 60, child: _buildActionButton(Icons.visibility, "")),
                ],
        ),
      );
    } else if (isTablet) {
      // Tablet: Medium complexity row
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 14),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children: [
                  Expanded(flex: 1, child: Text('${data.userId}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.name ?? "", style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(data.email.toString(), style: _rowStyle)),
                  Expanded(flex: 2, child: Text('${data.status}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.subscription ?? "", style: _rowStyle)),
                  SizedBox(width: 70, child: _buildActionButton(Icons.visibility, "View")),
                ]
             
        ),
      );
    } else {
      // Desktop: Full row
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          children:[
                  Expanded(flex: 1, child: Text('${data.userId}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.name ??"", style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.email ?? "", style: _rowStyle,overflow: TextOverflow.ellipsis,)),
                  Expanded(flex: 3, child: Text(data.signupDate.toString(), style: _rowStyle, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text('${data.subscription}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text('${data.signupMethod}', style: _rowStyle)),
                  Expanded(flex: 2, child: Text(data.platform ?? "", style: _rowStyle,overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 80, child: _buildActionButton(Icons.visibility, "View")),
                ]
            
        ),
      );
    }
  }

  Widget _buildTab(String title, int index, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? Icons.flag_outlined : Icons.person_outline,
            color: isSelected ? Colors.white : Colors.grey,
            size: isMobile ? 14 : 16,
          ),
          if (!isMobile || title.length < 12) ...[
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        print('$label clicked');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label.isNotEmpty && !isMobile) ...[
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: isTablet ? 12 : 14,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              icon, 
              color: Colors.grey.shade600, 
              size: isMobile ? 14 : 16,
            ),
          ],
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const _rowStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}