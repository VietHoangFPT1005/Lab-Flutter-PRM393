// lib/exercises/exercise2_input_widgets.dart
// Exercise 2: Input Widgets - Slider, Switch, RadioListTile, DatePicker

import 'package:flutter/material.dart';

class Exercise02 extends StatefulWidget {
  const Exercise02({super.key});

  @override
  State<Exercise02> createState() => _Exercise02();
}

class _Exercise02 extends State<Exercise02> {
  // State variables để lưu trữ giá trị các input
  double _sliderValue = 50;
  bool _switchValue = false;
  String _selectedGender = 'male';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2: Input Widgets'),
        backgroundColor: Colors.green.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SLIDER WIDGET
            _buildSectionTitle('1. Slider Widget'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volume: ${_sliderValue.toInt()}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    // Slider cho phép chọn giá trị trong khoảng
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 20, // Chia thành 20 bước
                      label: '${_sliderValue.toInt()}%',
                      activeColor: Colors.green,
                      onChanged: (value) {
                        // Cập nhật state khi giá trị thay đổi
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                    // Hiển thị icon volume tương ứng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _sliderValue == 0
                              ? Icons.volume_off
                              : _sliderValue < 50
                              ? Icons.volume_down
                              : Icons.volume_up,
                          size: 40,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. SWITCH WIDGET
            _buildSectionTitle('2. Switch Widget'),
            Card(
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: Text(_switchValue ? 'Notifications ON' : 'Notifications OFF'),
                value: _switchValue,
                activeColor: Colors.green,
                // Icon thay đổi theo trạng thái
                secondary: Icon(
                  _switchValue ? Icons.notifications_active : Icons.notifications_off,
                  color: _switchValue ? Colors.green : Colors.grey,
                ),
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // 3. RADIO LIST TILE
            _buildSectionTitle('3. RadioListTile Widget'),
            Card(
              child: Column(
                children: [
                  // Radio option 1: Male
                  RadioListTile<String>(
                    title: const Text('Male'),
                    subtitle: const Text('Select if you are male'),
                    value: 'male',
                    groupValue: _selectedGender, // Giá trị hiện tại của group
                    activeColor: Colors.blue,
                    secondary: const Icon(Icons.male, color: Colors.blue),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  // Radio option 2: Female
                  RadioListTile<String>(
                    title: const Text('Female'),
                    subtitle: const Text('Select if you are female'),
                    value: 'female',
                    groupValue: _selectedGender,
                    activeColor: Colors.pink,
                    secondary: const Icon(Icons.female, color: Colors.pink),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  // Radio option 3: Other
                  RadioListTile<String>(
                    title: const Text('Other'),
                    subtitle: const Text('Prefer not to say'),
                    value: 'other',
                    groupValue: _selectedGender,
                    activeColor: Colors.purple,
                    secondary: const Icon(Icons.person, color: Colors.purple),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${_selectedGender.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 4. DATE PICKER
            _buildSectionTitle('4. DatePicker Widget'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.orange),
                title: const Text('Select Date'),
                subtitle: Text(
                  // Format ngày tháng năm
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pick Date'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. TIME PICKER (Bonus)
            _buildSectionTitle('5. TimePicker Widget (Bonus)'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.purple),
                title: const Text('Select Time'),
                trailing: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Pick Time'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary Card hiển thị tất cả giá trị
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade100, Colors.blue.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Current Values:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text('• Slider: ${_sliderValue.toInt()}%'),
                  Text('• Switch: ${_switchValue ? "ON" : "OFF"}'),
                  Text('• Gender: $_selectedGender'),
                  Text('• Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method để tạo tiêu đề section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Hiển thị DatePicker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select your birth date',
      cancelText: 'Cancel',
      confirmText: 'OK',
    );

    // Nếu user chọn ngày, cập nhật state
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hiển thị TimePicker dialog
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select time',
    );

    if (picked != null) {
      // Hiển thị thông báo với thời gian đã chọn
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected time: ${picked.format(context)}'),
            backgroundColor: Colors.purple,
          ),
        );
      }
    }
  }
}