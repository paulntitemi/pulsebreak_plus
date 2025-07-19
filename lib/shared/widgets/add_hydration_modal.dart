import 'package:flutter/material.dart';

class AddHydrationModal extends StatefulWidget {
  final Function(int) onHydrationAdded;

  const AddHydrationModal({
    super.key,
    required this.onHydrationAdded,
  });

  @override
  State<AddHydrationModal> createState() => _AddHydrationModalState();
}

class _AddHydrationModalState extends State<AddHydrationModal> {
  int _selectedAmount = 250;
  final TextEditingController _customAmountController = TextEditingController();
  bool _isCustomAmount = false;

  final List<int> _quickAmounts = [250, 500, 750];

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _addHydration() {
    int amount = _isCustomAmount 
        ? int.tryParse(_customAmountController.text) ?? 0
        : _selectedAmount;
    
    if (amount > 0) {
      widget.onHydrationAdded(amount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            const Text(
              'Add Hydration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3A59),
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'Log your water intake to track daily hydration',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Quick select buttons
            const Text(
              'Quick Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3A59),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: _quickAmounts.map((amount) {
                bool isSelected = !_isCustomAmount && _selectedAmount == amount;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAmount = amount;
                        _isCustomAmount = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF0EA5E9)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF0EA5E9), width: 2)
                            : null,
                      ),
                      child: Text(
                        '${amount}ml',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            
            // Custom amount
            const Text(
              'Custom Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E3A59),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _isCustomAmount = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter amount in ml',
                hintStyle: const TextStyle(
                  color: Color(0xFFB0B8C1),
                  fontSize: 16,
                ),
                suffixText: 'ml',
                suffixStyle: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF0EA5E9),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _addHydration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0EA5E9),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add Hydration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}