import 'dart:math';

import 'package:admin/utils/utils.dart';


class Paginate<T> {
  int totalPages;
  int currentPage;
  int totalCount;
  int pageSize;
  Map<int, List<T>> data;

  Paginate({
    this.totalPages = 0,
    this.currentPage = 1,
    this.totalCount = 0,
    this.pageSize = 10,
    Map<int, List<T>>? data,
  }) : data = data ?? {};

  factory Paginate.empty() => Paginate();

  Paginate<T> copyWith({
    int? totalPages,
    int? currentPage,
    int? totalCount,
    int? pageSize,
    Map<int, List<T>>? data,
  }) {
    return Paginate<T>(
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      pageSize: pageSize ?? this.pageSize,
      data: data ?? this.data,
    );
  }

  factory Paginate.fromJson(
    String? dataKey,
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) dataFromJson,
  ) {
    int currentPage = 1;
    int totalCount = 0;
    int totalPages = 0;
    final data = json['data'];
    final rawData = dataKey != null &&
            data is Map<String, dynamic> &&
            data.containsKey(dataKey)
        ? data[dataKey]
        : data;
    if (hasMyData(data, "currentPage")) currentPage = data["currentPage"];
    if (hasMyData(data, "totalPages")) totalPages = data["totalPages"];
    if (hasMyData(data, "totalCount")) totalCount = data["totalCount"];

    final List<T> pageItems =
        rawData is List ? parseList(rawData, dataFromJson).cast<T>() : const [];

    return Paginate<T>(
      data: {currentPage: pageItems},
      totalCount: totalCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }

  factory Paginate.mergePagination({
    required Paginate<T> previousData,
    required Map<String, dynamic> newData,
    required T Function(Map<String, dynamic>) dataFromJson,
    String? dataKey,
  }) {
    final newPagination = Paginate<T>.fromJson(dataKey, newData, dataFromJson);
    List<T> allItems = [];
    for (var entry in previousData.data.entries) {
      allItems.addAll(entry.value);
    }
    allItems.addAll(newPagination.data[newPagination.currentPage] ?? []);
    Map<int, List<T>> mergedPageData = {};
    for (int pageNum = 1; pageNum <= newPagination.totalPages; pageNum++) {
      int startIndex = (pageNum - 1) * previousData.pageSize;
      int endIndex = pageNum * previousData.pageSize;
      if (startIndex < allItems.length) {
        mergedPageData[pageNum] = allItems.sublist(
          startIndex,
          min(endIndex, allItems.length),
        );
      } else {
        mergedPageData[pageNum] = [];
      }
    }

    return Paginate<T>(
      totalPages: newPagination.totalPages,
      currentPage: newPagination.currentPage,
      totalCount: newPagination.totalCount,
      pageSize: newPagination.pageSize,
      data: mergedPageData,
    );
  }

  factory Paginate.appendItem({
    required Paginate<T> data,
    required T item,
    int appendToPage = 1,
  }) {
    final currentPage = appendToPage;
    final existingPageData = (data.data[currentPage] ?? []).cast<T>();

    final List<T> updatedPageData = [item];
    updatedPageData.addAll(existingPageData);

    final updatedData = <int, List<T>>{};
    data.data.forEach((key, value) {
      updatedData[key] = value.cast<T>();
    });

    updatedData[currentPage] = updatedPageData;

    return data.copyWith(
      data: updatedData,
      totalCount: data.totalCount + 1,
    );
  }

  factory Paginate.removeItem({
    required Paginate<T> data,
    required T item,
  }) {
    data.data.forEach((page, items) {
      if (items.contains(item)) {
        items.remove(item);
      }
    });
    return data.copyWith(
      data: data.data,
      totalCount: data.totalCount - 1,
    );
  }

  List<T> getPageData(int pageNumber) {
    return data[pageNumber] ?? [];
  }

  bool hasPageCached(int pageNumber) {
    final data = getPageData(pageNumber);
    return data.isNotEmpty;
  }

  List<T> getCachedData() {
    return data.values.expand((pageData) => pageData).toList();
  }

  @override
  String toString() {
    return 'Paginate(totalPages: $totalPages, currentPage: $currentPage, '
        'totalCount: $totalCount, cachedPages: ${data.keys.toList()})';
  }

  static bool hasMyData(dynamic data, String dataKey) =>
      data is Map<String, dynamic> && data.containsKey(dataKey);
}
