import 'package:admin/controller/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/models/price_item.dart';
import 'package:admin/controller/price_setting/price_setting.dart';

class EditPriceScreen extends StatelessWidget {
  final PriceItem data;
  EditPriceScreen({super.key, required this.data}) {
    final c = Get.find<PriceSettingController>();

    // Initialize reactive variables
    c.photoController.text = data.package.replaceAll(RegExp(r'[^0-9]'), '');
    c.priceController.text = data.price.toStringAsFixed(2);
    c.labelController.text = data.buttonLabel;
    c.isBestValue.value = data.tag == 'Best Value';
    c.isEditing.value = false;
  }

  final PriceSettingController controller = Get.put(PriceSettingController());

  InputDecoration _inputDecoration(bool enabled) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 0.5,
        ),
      ),
    );
  }

  TextStyle _textStyle(bool enabled) {
    return TextStyle(
      color: enabled ? Colors.black : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF181A20) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final appController = Get.find<AppController>();
                    appController.closeDrawer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xFF23272F) : Colors.white,
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
                ),
                const SizedBox(width: 16),
                Text(
                  'Edit Price',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Color(0xFF111827),
                  ),
                ),
               
              ],
            ),
            const SizedBox(height: 102),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Colors.white,
                border: Border.all(
                  color: isDark ? Colors.grey.shade600 : const Color.fromARGB(255, 201, 199, 199),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Number of Photos'),
                              const SizedBox(height: 8),
                              TextField(
                                enabled: controller.isEditing.value,
                                controller: controller.photoController,
                                style: _textStyle(controller.isEditing.value),
                                decoration: _inputDecoration(
                                    controller.isEditing.value),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Price'),
                              const SizedBox(height: 8),
                              TextField(
                                enabled: controller.isEditing.value,
                                controller: controller.priceController,
                                style: _textStyle(controller.isEditing.value),
                                decoration: _inputDecoration(
                                    controller.isEditing.value),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Button Label'),
                        const SizedBox(height: 8),
                        TextField(
                          enabled: controller.isEditing.value,
                          controller: controller.labelController,
                          style: _textStyle(controller.isEditing.value),
                          decoration:
                              _inputDecoration(controller.isEditing.value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.isBestValue.value,
                          onChanged: controller.isEditing.value
                              ? (val) {
                                  if (val != null) {
                                    controller.isBestValue.value = val;
                                  }
                                }
                              : null,
                          activeColor: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Mark as Best Value',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: controller.isEditing.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      controller.cancelEdit();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final index =
                                          controller.priceList.indexOf(data);
                                      controller.saveEdit(index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                minimumSize: const Size(120, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                controller.isEditing.value = true;
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text('Edit',
                                  style: TextStyle(color: Colors.white)),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
