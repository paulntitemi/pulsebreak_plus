import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../services/user_preferences_service.dart';
import '../../shared/widgets/loading_widget.dart';

class SmartRemindersScreen extends StatefulWidget {
  const SmartRemindersScreen({super.key});

  @override
  State<SmartRemindersScreen> createState() => _SmartRemindersScreenState();
}

class _SmartRemindersScreenState extends State<SmartRemindersScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _reminders = [
    {
      'id': 1,
      'title': 'Morning Mood Check-in',
      'description': 'Start your day with a quick mood assessment',
      'time': '8:00 AM',
      'frequency': 'Daily',
      'category': 'Mood',
      'icon': Icons.sentiment_satisfied,
      'color': const Color(0xFF8B5CF6),
      'isEnabled': true,
      'isSmartTimed': true,
      'smartNote': 'Optimized for your morning routine',
    },
    {
      'id': 2,
      'title': 'Hydration Reminder',
      'description': 'Time to drink some water!',
      'time': 'Every 2 hours',
      'frequency': 'Multiple daily',
      'category': 'Hydration',
      'icon': Icons.water_drop,
      'color': const Color(0xFF0EA5E9),
      'isEnabled': true,
      'isSmartTimed': false,
      'smartNote': null,
    },
    {
      'id': 3,
      'title': 'Stress Check',
      'description': 'Quick stress level assessment',
      'time': '2:00 PM',
      'frequency': 'Weekdays',
      'category': 'Stress',
      'icon': Icons.psychology,
      'color': const Color(0xFF10B981),
      'isEnabled': false,
      'isSmartTimed': true,
      'smartNote': 'Timed for your typical stress peak',
    },
    {
      'id': 4,
      'title': 'Evening Wind-down',
      'description': 'Prepare for a good night\'s sleep',
      'time': '9:30 PM',
      'frequency': 'Daily',
      'category': 'Sleep',
      'icon': Icons.bedtime,
      'color': const Color(0xFF8B5CF6),
      'isEnabled': true,
      'isSmartTimed': true,
      'smartNote': 'Based on your optimal bedtime',
    },
    {
      'id': 5,
      'title': 'Mindful Moment',
      'description': 'Take a moment to breathe and reflect',
      'time': '12:00 PM',
      'frequency': 'Daily',
      'category': 'Mindfulness',
      'icon': Icons.spa,
      'color': const Color(0xFFEAB308),
      'isEnabled': true,
      'isSmartTimed': false,
      'smartNote': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedReminders();
  }

  Future<void> _loadSavedReminders() async {
    final savedReminders = UserPreferencesService.instance.getUserReminders();
    if (savedReminders.isNotEmpty) {
      setState(() {
        _reminders = [..._reminders, ...savedReminders];
      });
    }
  }

  Future<void> _saveReminders() async {
    // Save only custom reminders (those added by user, not default ones)
    final customReminders = _reminders.where((r) => (r['id'] as int) > 5).toList();
    await UserPreferencesService.instance.saveUserReminders(customReminders);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Smart Reminders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2E3A59)),
            onPressed: _showAddReminderDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smart reminders info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF3B82F6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.psychology,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Smart Reminders',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI-powered reminders that adapt to your habits and optimize for your wellness goals.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Active',
                      '${_reminders.where((r) => r['isEnabled'] as bool).length}',
                      'reminders',
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Smart Timed',
                      '${_reminders.where((r) => r['isSmartTimed'] as bool).length}',
                      'optimized',
                      const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Reminders list
              const Text(
                'Your Reminders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),

              const SizedBox(height: 16),

              ..._reminders.map(_buildReminderCard),

              const SizedBox(height: 24),

              // Add reminder button
              GestureDetector(
                onTap: _showAddReminderDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    ),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF8B5CF6),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Add Custom Reminder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Create a personalized reminder for your wellness goals',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const LoadingWidget(message: 'Creating reminder...'),
          ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3A59),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (reminder['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    reminder['icon'] as IconData,
                    color: reminder['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminder['title'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                          ),
                          if (reminder['isSmartTimed'] as bool) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.psychology,
                                    size: 10,
                                    color: Color(0xFF8B5CF6),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'SMART',
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder['category'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: reminder['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder['isEnabled'] as bool,
                  onChanged: (value) async {
                    setState(() => _isLoading = true);
                    
                    try {
                      if (value) {
                        // Schedule notification
                        await NotificationService.instance.scheduleReminderNotification(reminder);
                      } else {
                        // Cancel notification
                        await NotificationService.instance.cancelNotification(reminder['id'] as int);
                      }
                      
                      setState(() {
                        reminder['isEnabled'] = value;
                        _isLoading = false;
                      });
                    } catch (e) {
                      setState(() => _isLoading = false);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to ${value ? 'enable' : 'disable'} reminder'),
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                        );
                      }
                    }
                  },
                  activeColor: reminder['color'] as Color,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              reminder['description'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            // Time and frequency
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reminder['time'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.repeat,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reminder['frequency'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Smart note
            if (reminder['smartNote'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      size: 16,
                      color: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reminder['smartNote'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _editReminder(reminder);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: reminder['color'] as Color),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: reminder['color'] as Color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _testReminder(reminder);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: reminder['color'] as Color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Test',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _AddReminderDialog(
        onSave: (Map<String, dynamic> newReminder) async {
          setState(() => _isLoading = true);
          
          try {
            // Generate new ID
            final newId = _reminders.isNotEmpty 
                ? _reminders.map((r) => r['id'] as int).reduce((a, b) => a > b ? a : b) + 1
                : 1;
            
            newReminder['id'] = newId;
            newReminder['isEnabled'] = true;
            
            // Schedule notification if enabled
            if (newReminder['isEnabled'] == true) {
              await NotificationService.instance.scheduleReminderNotification(newReminder);
            }
            
            setState(() {
              _reminders.add(newReminder);
              _isLoading = false;
            });
            
            // Save reminders to preferences
            await _saveReminders();
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${newReminder['title']} created successfully!'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            }
          } catch (e) {
            setState(() => _isLoading = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to create reminder: ${e.toString()}'),
                  backgroundColor: const Color(0xFFEF4444),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _editReminder(Map<String, dynamic> reminder) {
    showDialog<void>(
      context: context,
      builder: (context) => _EditReminderDialog(
        reminder: reminder,
        onSave: (Map<String, dynamic> updatedReminder) async {
          setState(() {
            // Find and update the reminder in the list
            final index = _reminders.indexWhere((r) => r['id'] == updatedReminder['id']);
            if (index != -1) {
              _reminders[index] = updatedReminder;
            }
          });
          
          // Save updated reminders
          await _saveReminders();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updatedReminder['title']} updated successfully!'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  void _testReminder(Map<String, dynamic> reminder) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(reminder['icon'] as IconData, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reminder['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    reminder['description'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: reminder['color'] as Color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _EditReminderDialog extends StatefulWidget {
  final Map<String, dynamic> reminder;
  final void Function(Map<String, dynamic>) onSave;

  const _EditReminderDialog({
    required this.reminder,
    required this.onSave,
  });

  @override
  State<_EditReminderDialog> createState() => _EditReminderDialogState();
}

class _EditReminderDialogState extends State<_EditReminderDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
  
  String _selectedFrequency = '';
  String _selectedCategory = '';
  IconData _selectedIcon = Icons.notifications;
  Color _selectedColor = const Color(0xFF8B5CF6);
  bool _isSmartTimed = false;
  
  final List<String> _frequencies = [
    'Daily',
    'Weekdays',
    'Weekends',
    'Multiple daily',
    'Weekly',
    'Monthly',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Mood', 'icon': Icons.sentiment_satisfied, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Hydration', 'icon': Icons.water_drop, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Stress', 'icon': Icons.psychology, 'color': const Color(0xFF10B981)},
    {'name': 'Sleep', 'icon': Icons.bedtime, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Mindfulness', 'icon': Icons.spa, 'color': const Color(0xFFEAB308)},
    {'name': 'Exercise', 'icon': Icons.fitness_center, 'color': const Color(0xFFEF4444)},
    {'name': 'Nutrition', 'icon': Icons.restaurant, 'color': const Color(0xFF10B981)},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _titleController = TextEditingController(text: widget.reminder['title'] as String);
    _descriptionController = TextEditingController(text: widget.reminder['description'] as String);
    _timeController = TextEditingController(text: widget.reminder['time'] as String);
    
    _selectedFrequency = widget.reminder['frequency'] as String;
    _selectedCategory = widget.reminder['category'] as String;
    _selectedIcon = widget.reminder['icon'] as IconData;
    _selectedColor = widget.reminder['color'] as Color;
    _isSmartTimed = widget.reminder['isSmartTimed'] as bool;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _selectedColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _selectedIcon,
                      color: _selectedColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Edit Reminder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    _buildTextField(
                      'Reminder Title',
                      _titleController,
                      'Enter a descriptive title',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description Field
                    _buildTextField(
                      'Description',
                      _descriptionController,
                      'What should this reminder help you with?',
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Time Field
                    _buildTextField(
                      'Time',
                      _timeController,
                      '8:00 AM, Every 2 hours, etc.',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Frequency Dropdown
                    _buildDropdown(
                      'Frequency',
                      _selectedFrequency,
                      _frequencies,
                      (value) => setState(() => _selectedFrequency = value!),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Category Selection
                    _buildCategorySelection(),
                    
                    const SizedBox(height: 20),
                    
                    // Smart Timing Toggle
                    _buildSmartTimingToggle(),
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveReminder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _selectedColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _selectedColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          items: options.map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'] as String;
                  _selectedIcon = category['icon'] as IconData;
                  _selectedColor = category['color'] as Color;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (category['color'] as Color).withValues(alpha: 0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected 
                        ? category['color'] as Color
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 16,
                      color: isSelected 
                          ? category['color'] as Color
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? category['color'] as Color
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSmartTimingToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                size: 20,
                color: Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Smart Timing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ),
              Switch(
                value: _isSmartTimed,
                onChanged: (value) => setState(() => _isSmartTimed = value),
                activeColor: const Color(0xFF8B5CF6),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Let AI optimize the timing based on your habits and wellness patterns.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _saveReminder() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reminder title'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Create updated reminder
    final updatedReminder = Map<String, dynamic>.from(widget.reminder);
    updatedReminder['title'] = _titleController.text.trim();
    updatedReminder['description'] = _descriptionController.text.trim();
    updatedReminder['time'] = _timeController.text.trim();
    updatedReminder['frequency'] = _selectedFrequency;
    updatedReminder['category'] = _selectedCategory;
    updatedReminder['icon'] = _selectedIcon;
    updatedReminder['color'] = _selectedColor;
    updatedReminder['isSmartTimed'] = _isSmartTimed;
    updatedReminder['smartNote'] = _isSmartTimed 
        ? 'Optimized based on your wellness patterns'
        : null;

    // Save and close
    widget.onSave(updatedReminder);
    Navigator.pop(context);
  }
}

class _AddReminderDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;

  const _AddReminderDialog({
    required this.onSave,
  });

  @override
  State<_AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<_AddReminderDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
  
  String _selectedFrequency = 'Daily';
  String _selectedCategory = 'Mood';
  IconData _selectedIcon = Icons.sentiment_satisfied;
  Color _selectedColor = const Color(0xFF8B5CF6);
  bool _isSmartTimed = false;
  
  final List<String> _frequencies = [
    'Daily',
    'Weekdays',
    'Weekends',
    'Multiple daily',
    'Weekly',
    'Monthly',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Mood', 'icon': Icons.sentiment_satisfied, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Hydration', 'icon': Icons.water_drop, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Stress', 'icon': Icons.psychology, 'color': const Color(0xFF10B981)},
    {'name': 'Sleep', 'icon': Icons.bedtime, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Mindfulness', 'icon': Icons.spa, 'color': const Color(0xFFEAB308)},
    {'name': 'Exercise', 'icon': Icons.fitness_center, 'color': const Color(0xFFEF4444)},
    {'name': 'Nutrition', 'icon': Icons.restaurant, 'color': const Color(0xFF10B981)},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _timeController = TextEditingController(text: '8:00 AM');
    
    // Set initial values based on default category
    final defaultCategory = _categories.first;
    _selectedIcon = defaultCategory['icon'] as IconData;
    _selectedColor = defaultCategory['color'] as Color;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _selectedColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _selectedIcon,
                      color: _selectedColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Create Custom Reminder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    _buildTextField(
                      'Reminder Title',
                      _titleController,
                      'Enter a descriptive title',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description Field
                    _buildTextField(
                      'Description',
                      _descriptionController,
                      'What should this reminder help you with?',
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Time Field
                    _buildTextField(
                      'Time',
                      _timeController,
                      '8:00 AM, Every 2 hours, etc.',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Frequency Dropdown
                    _buildDropdown(
                      'Frequency',
                      _selectedFrequency,
                      _frequencies,
                      (value) => setState(() => _selectedFrequency = value!),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Category Selection
                    _buildCategorySelection(),
                    
                    const SizedBox(height: 20),
                    
                    // Smart Timing Toggle
                    _buildSmartTimingToggle(),
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveReminder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create Reminder'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _selectedColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _selectedColor, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          items: options.map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          )).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category['name'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['name'] as String;
                  _selectedIcon = category['icon'] as IconData;
                  _selectedColor = category['color'] as Color;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (category['color'] as Color).withValues(alpha: 0.1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected 
                        ? category['color'] as Color
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 16,
                      color: isSelected 
                          ? category['color'] as Color
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? category['color'] as Color
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSmartTimingToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology,
                size: 20,
                color: Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Smart Timing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ),
              Switch(
                value: _isSmartTimed,
                onChanged: (value) => setState(() => _isSmartTimed = value),
                activeColor: const Color(0xFF8B5CF6),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Let AI optimize the timing based on your habits and wellness patterns.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _saveReminder() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reminder title'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Create new reminder
    final newReminder = <String, dynamic>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty 
          ? 'Custom reminder for your wellness goals'
          : _descriptionController.text.trim(),
      'time': _timeController.text.trim(),
      'frequency': _selectedFrequency,
      'category': _selectedCategory,
      'icon': _selectedIcon,
      'color': _selectedColor,
      'isSmartTimed': _isSmartTimed,
      'smartNote': _isSmartTimed 
          ? 'Optimized based on your wellness patterns'
          : null,
    };

    // Save and close
    widget.onSave(newReminder);
    Navigator.pop(context);
  }
}