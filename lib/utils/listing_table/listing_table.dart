import 'package:admin/constants/colors.dart';
import 'package:admin/utils/listing_table/listing_column.dart';
import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'listing_row.dart';

class ListingTable extends StatelessWidget {
  const ListingTable({
    super.key,
    required this.rows,
    required this.columns,
    this.scrollController,
    this.rowHeight,
    this.isLoading = false,
  });
  final double? rowHeight;
  final List<ListingRow> rows;
  final List<ListingColumn> columns;
  final bool isLoading;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable2(
        scrollController: scrollController,
        dataRowHeight: rowHeight ?? 50,
        showBottomBorder: true,
        minWidth: context.width < 600 ? 1000 : null,
        showCheckboxColumn: false,
        border: TableBorder.all(width: 0, color: Colors.transparent),
        headingRowHeight: 50,
        headingRowColor: WidgetStateProperty.all(Colors.transparent),
        columnSpacing: 23,
        headingTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        empty: const Center(child: Text('No Items to Display')),
        columns: columns
            .map(
              (column) => DataColumn2(
                fixedWidth: column.fixedWidth,
                size: column.size,
                label: Center(
                  child: column.title,
                ),
              ),
            )
            .toList(),
        rows: isLoading
            ? List.generate(5, (index) {
                return DataRow2(
                    specificRowHeight: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        border: Border.all(color: AppColors.whiteColor)),
                    cells: List.generate(columns.length, (index) {
                      return DataCell(Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ));
                    }));
              })
            : rows
                .mapIndexed(
                  (index, row) => DataRow2(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.05))),
                    onSelectChanged: (selected) {},
                    onTap: row.onTap,
                    onSecondaryTap: () {},
                    cells: row.cells
                        .map(
                          (cell) => DataCell(
                            Align(
                              alignment: cell.alignment,
                              child: cell.child,
                            ),
                            showEditIcon: cell.showEditIcon,
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
      ),
    );
  }
}
