import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/tab_toggle.dart';
import 'package:pulsebreak_plus/shared/widgets/hydration_grid.dart';
import 'package:pulsebreak_plus/shared/widgets/hydration_entry_tile.dart';
import 'package:pulsebreak_plus/shared/widgets/add_hydration_modal.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Daily', 'Weekly', 'Monthly'];
  
  // Sample hydration data
  final List<Map<String, dynamic>> _hydrationLogs = [
    {'amount': 750, 'time': '2:40 PM', 'hour': 14},
    {'amount': 500, 'time': '11:00 AM', 'hour': 11},
    {'amount': 250, 'time': '8:30 AM', 'hour': 8},
    {'amount': 200, 'time': '6:15 AM', 'hour': 6},
  ];

  int get _totalHydration => _hydrationLogs.fold(0, (sum, log) => sum + (log['amount'] as int));

  void _showAddHydrationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHydrationModal(
        onHydrationAdded: (amount) {
          setState(() {
            final now = DateTime.now();
            _hydrationLogs.insert(0, {
              'amount': amount,
              'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
              'hour': now.hour,
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Water Balance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Toggle
                    TabToggle(
                      tabs: _tabs,
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Info Section
                    _buildInfoSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Hydration Grid
                    HydrationGrid(hydrationLogs: _hydrationLogs),
                    
                    const SizedBox(height: 32),
                    
                    // Recent Logs Section
                    _buildRecentLogsSection(),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom CTA Button
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You\'ve logged ${_totalHydration}ml today',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: Text(
                  'Goal: 2000ml daily to stay properly hydrated',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ),
              Icon(
                Icons.info_outline,
                size: 16,
                color: const Color(0xFF6B7280),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_totalHydration / 2000).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${((_totalHydration / 2000) * 100).round()}% of daily goal',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0EA5E9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Water Consumption',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
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
            children: _hydrationLogs.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> log = entry.value;
              
              return HydrationEntryTile(
                amount: log['amount'],
                time: log['time'],
                isLast: index == _hydrationLogs.length - 1,
                onDelete: () {
                  setState(() {
                    _hydrationLogs.removeAt(index);
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _showAddHydrationModal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Add New Hydration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}