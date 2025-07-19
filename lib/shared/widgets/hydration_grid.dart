import 'package:flutter/material.dart';

class HydrationGrid extends StatelessWidget {
  final List<Map<String, dynamic>> hydrationLogs;

  const HydrationGrid({
    super.key,
    required this.hydrationLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Grid header
          const Text(
            'Hydration Timeline',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Grid
          _buildGrid(),
          
          const SizedBox(height: 16),
          
          // Time labels
          _buildTimeLabels(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    // Create a set of hours that have hydration logged
    Set<int> loggedHours = hydrationLogs.map((log) => log['hour'] as int).toSet();
    
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          // Y-axis labels (100%, 75%, 50%, 25%, 0%)
          Expanded(
            child: Row(
              children: [
                // Y-axis labels
                SizedBox(
                  width: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildYLabel('100%'),
                      _buildYLabel('75%'),
                      _buildYLabel('50%'),
                      _buildYLabel('25%'),
                      _buildYLabel('0%'),
                    ],
                  ),
                ),
                
                // Grid area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        // Grid rows (5 rows for percentage levels)
                        for (int row = 0; row < 5; row++)
                          Expanded(
                            child: Row(
                              children: [
                                // Grid columns (hours 6-22, 17 total hours)
                                for (int hour = 6; hour <= 22; hour++)
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: _getBlockColor(hour, row, loggedHours),
                                        borderRadius: BorderRadius.circular(2),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTimeLabels() {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeLabel('6AM'),
          _buildTimeLabel('10AM'),
          _buildTimeLabel('2PM'),
          _buildTimeLabel('6PM'),
          _buildTimeLabel('10PM'),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getBlockColor(int hour, int row, Set<int> loggedHours) {
    if (loggedHours.contains(hour)) {
      // If this hour has hydration logged, fill more blocks from bottom up
      int filledRows = _getFilledRows(hour);
      if (row >= (5 - filledRows)) {
        return const Color(0xFF2E3A59); // Dark fill for logged hours
      }
    }
    return const Color(0xFFE5E7EB); // Light gray for empty blocks
  }

  int _getFilledRows(int hour) {
    // Get the total amount for this hour
    int totalForHour = hydrationLogs
        .where((log) => log['hour'] == hour)
        .fold(0, (sum, log) => sum + (log['amount'] as int));
    
    // Convert to number of filled rows (1-5 based on amount)
    if (totalForHour >= 750) return 5;
    if (totalForHour >= 500) return 4;
    if (totalForHour >= 300) return 3;
    if (totalForHour >= 200) return 2;
    if (totalForHour > 0) return 1;
    return 0;
  }
}