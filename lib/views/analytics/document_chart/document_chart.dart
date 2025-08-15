import 'package:admin/constants/colors.dart';
import 'package:admin/theme/text_theme.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class DocumentTypeChart extends StatelessWidget {
  final List<Map<String, dynamic>> chartData;
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
    if (chartData.isEmpty) {
      return const Center(child: Text("No data available."));
    }

    final maxValue = chartData
        .map((e) => e['count'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final step = (maxValue / 4).round();

    return Column(
     
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Row
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
                  "57,977",
                  style:CustomTextTheme.regular24,
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
              style:  TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.grey[800] ), // smaller text
                  menuMaxHeight: 250,
                  items: const [
                    DropdownMenuItem(
                      value: 'Daily',
                      child: Text('Daily', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'Weekly',
                      child: Text('Weekly', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'Monthly',
                      child: Text('Monthly', style: TextStyle(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'Yearly',
                      child: Text('Yearly', style: TextStyle(fontSize: 14)),
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

        // Chart
        Column(
          children: [
            ...chartData.asMap().entries.map((entry) {
              final item = entry.value;
              final percentage = item['count'] / maxValue;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        item['label'],
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
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
                                color: item['color'],
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
                        _formatNumber(item['count']),
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

            // Bottom axis
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
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 76),
              ],
            ),
          ],
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



class RequestPieChartWidget extends StatelessWidget {
  final int totalRequests;
  final int successfulRequests;

  const RequestPieChartWidget({
    super.key,
    required this.totalRequests,
    required this.successfulRequests,
  });

  @override
  Widget build(BuildContext context) {
    final int failedRequests = totalRequests - successfulRequests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Processing Request',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            DropdownButton<String>(
              value: '6 Months',
              items: ['6 Months', '3 Months', '1 Month']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '$totalRequests',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: Colors.redAccent, text: 'Failed'),
            SizedBox(width: 20),
            LegendItem(color: Colors.lightGreen, text: 'Successful'),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: 50,
          height: 50,
          child: Center(
            child: 
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                    sections: [
                      PieChartSectionData(
                        color: Colors.lightGreen,
                        value: successfulRequests.toDouble(),
                        title: '',
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.redAccent,
                        value: failedRequests.toDouble(),
                        title: '',
                        radius: 50,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //   decoration: BoxDecoration(
                //     color: Colors.black,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     '$successfulRequests',
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
           
          ),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
