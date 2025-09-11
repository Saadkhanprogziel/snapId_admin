import 'package:admin/constants/colors.dart';
import 'package:admin/models/analytics/top_documents_type.dart';
import 'package:admin/theme/text_theme.dart';
import 'package:flutter/material.dart';

class DocumentTypeChart extends StatelessWidget {
  final List<TopDocumentType> chartData;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const DocumentTypeChart({
    Key? key,
    required this.chartData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final maxValue = chartData.isNotEmpty
        ? chartData
            .map((e) => e.count)
            .reduce((a, b) => a > b ? a : b)
            .toDouble()
        : 1.0;

    final step = (maxValue / 4).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with dropdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Document Types",
                  style: CustomTextTheme.regular16.copyWith(
                      color: AppColors.grey, fontWeight: FontWeight.w400),
                ),
                Text(
                  _formatNumber(
                    chartData.fold<int>(0, (sum, e) => sum + e.count),
                  ),
                  style: CustomTextTheme.regular24,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.transparent : Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  isDense: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.grey[800],
                  ),
                  menuMaxHeight: 250,
                  items: const [
                    DropdownMenuItem(
                      value: 'all_time',
                      child: Text('All Time', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'today',
                      child: Text('Today', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'this_week',
                      child: Text('This Week', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'this_month',
                      child: Text('This Month', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'last_month',
                      child: Text('Last Month', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'year',
                      child: Text('This Year', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onPeriodChanged(value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Chart / Empty state
        chartData.isEmpty
            ? const Center(child: Text("No data in this Period."))
            : Padding(
                padding:
                    const EdgeInsets.only(bottom: 24), // extra breathing space
                child: Column(
                  children: [
                    ...chartData.map((item) {
                      final percentage = item.count / maxValue;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                "${item.country} - ${item.documentType}",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontSize: 13),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: percentage,
                                    child: Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 60,
                              child: Text(
                                _formatNumber(item.count),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 136),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (i) {
                              final labelValue = step * i;
                              return Text(
                                _formatNumber(labelValue),
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 76),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1).replaceAll('.0', '')}k';
    }
    return number.toString();
  }
}
