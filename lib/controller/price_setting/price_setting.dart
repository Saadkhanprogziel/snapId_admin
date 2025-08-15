import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/price_item.dart';

class PriceSettingController extends GetxController {
  var priceList = <PriceItem>[].obs;
  var currentPage = 0.obs;

  // Editing state
  var isEditing = false.obs;
  var isBestValue = false.obs;
  final photoController = TextEditingController();
  final priceController = TextEditingController();
  final labelController = TextEditingController();

  // To remember the original values for cancel
  late String _initialPhotos;
  late String _initialPrice;
  late String _initialLabel;
  late bool _initialBestValue;

  @override
  void onInit() {
    super.onInit();
    priceList.addAll([
      PriceItem(
        package: 'Photo 1',
        price: 9.99,
        tag: '-',
        buttonLabel: 'Buy Now',
      ),
      PriceItem(
        package: 'Photo 3',
        price: 19.99,
        tag: 'Best Value',
        buttonLabel: 'Buy Now',
      ),
      PriceItem(
        package: 'Photo 5',
        price: 29.99,
        tag: '-',
        buttonLabel: 'Buy Now',
      ),
    ]);
  }

  void addPrice(PriceItem price) => priceList.add(price);

  void removePrice(int index) {
    if (index >= 0 && index < priceList.length) {
      priceList.removeAt(index);
    }
  }

  void updatePrice(int index, PriceItem newPrice) {
    if (index >= 0 && index < priceList.length) {
      priceList[index] = newPrice;
    }
  }

  void setCurrentPage(int page, int totalPages) {
    if (page < 0) {
      currentPage.value = 0;
    } else if (page >= totalPages) {
      currentPage.value = totalPages - 1;
    } else {
      currentPage.value = page;
    }
  }

  /// Initialize editing state with given PriceItem
  void startEdit(PriceItem item) {
    _initialPhotos = item.package.replaceAll(RegExp(r'[^0-9]'), '');
    _initialPrice = item.price.toStringAsFixed(2);
    _initialLabel = item.buttonLabel;
    _initialBestValue = item.tag == 'Best Value';

    photoController.text = _initialPhotos;
    priceController.text = _initialPrice;
    labelController.text = _initialLabel;
    isBestValue.value = _initialBestValue;

    isEditing.value = true;
  }

  /// Cancel editing and restore original values
  void cancelEdit() {
    photoController.text = _initialPhotos;
    priceController.text = _initialPrice;
    labelController.text = _initialLabel;
    isBestValue.value = _initialBestValue;
    isEditing.value = false;
  }

  /// Save changes to a specific PriceItem in the list
  void saveEdit(int index) {
    if (index >= 0 && index < priceList.length) {
      final updated = PriceItem(
        package: 'Photo ${photoController.text}',
        price: double.tryParse(priceController.text) ?? 0.0,
        tag: isBestValue.value ? 'Best Value' : '-',
        buttonLabel: labelController.text,
      );
      updatePrice(index, updated);

      _initialPhotos = photoController.text;
      _initialPrice = priceController.text;
      _initialLabel = labelController.text;
      _initialBestValue = isBestValue.value;
    }
    isEditing.value = false;
  }
}
