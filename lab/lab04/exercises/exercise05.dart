
import 'package:flutter/material.dart';

class Exercise05 extends StatefulWidget {
  const Exercise05({super.key});

  @override
  State<Exercise05> createState() => _Exercise05();
}

class _Exercise05 extends State<Exercise05> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 5: Debug & Fix'),
          backgroundColor: Colors.red.shade100,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
            tabs: const [
              Tab(text: 'Fix 1: ListView'),
              Tab(text: 'Fix 2: Overflow'),
              Tab(text: 'Fix 3: setState'),
              Tab(text: 'Fix 4: Context'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFix1ListView(),
            _buildFix2Overflow(),
            _buildFix3SetState(),
            _buildFix4Context(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FIX 1: ListView inside Column - Use Expanded
  // ============================================================
  Widget _buildFix1ListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorCard(
            title: 'Problem: ListView inside Column',
            error: 'Vertical viewport was given unbounded height',
            reason: 'ListView has infinite height but Column also tries to be as tall as possible.',
          ),
          const SizedBox(height: 16),

          // WRONG CODE (commented out)
          _buildCodeBlock(
            title: '❌ WRONG CODE:',
            code: '''
Column(
  children: [
    Text('Header'),
    ListView.builder(  // ERROR!
      itemCount: 10,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item \$i')),
    ),
  ],
)''',
            isError: true,
          ),
          const SizedBox(height: 16),

          // CORRECT CODE
          _buildCodeBlock(
            title: '✅ FIXED CODE:',
            code: '''
Column(
  children: [
    Text('Header'),
    Expanded(  // Wrap ListView with Expanded
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => ListTile(title: Text('Item \$i')),
      ),
    ),
  ],
)''',
            isError: false,
          ),
          const SizedBox(height: 16),

          // Live Demo
          const Text('📱 Live Demo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.green.shade100,
                  width: double.infinity,
                  child: const Text('Header (Fixed)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                // ✅ FIXED: Wrap ListView with Expanded
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Item ${index + 1}'),
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

  // ============================================================
  // FIX 2: Overflow - Use SingleChildScrollView
  // ============================================================
  Widget _buildFix2Overflow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorCard(
            title: 'Problem: Overflow on small screens',
            error: 'A RenderFlex overflowed by X pixels on the bottom',
            reason: 'Content is taller than available screen space.',
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '❌ WRONG CODE:',
            code: '''
Scaffold(
  body: Column(  // ERROR on small screens!
    children: [
      Container(height: 200, ...),
      Container(height: 200, ...),
      Container(height: 200, ...),
      Container(height: 200, ...),
    ],
  ),
)''',
            isError: true,
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '✅ FIXED CODE:',
            code: '''
Scaffold(
  body: SingleChildScrollView(  // Wrap with scroll
    child: Column(
      children: [
        Container(height: 200, ...),
        Container(height: 200, ...),
        Container(height: 200, ...),
        Container(height: 200, ...),
      ],
    ),
  ),
)''',
            isError: false,
          ),
          const SizedBox(height: 16),

          const Text('📱 Live Demo (Scroll to see all):', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Multiple containers that would overflow without scroll
          _buildDemoBox(Colors.red, 'Box 1'),
          _buildDemoBox(Colors.orange, 'Box 2'),
          _buildDemoBox(Colors.yellow, 'Box 3'),
          _buildDemoBox(Colors.green, 'Box 4'),
          _buildDemoBox(Colors.blue, 'Box 5'),
        ],
      ),
    );
  }

  // ============================================================
  // FIX 3: setState() - State not updating
  // ============================================================
  Widget _buildFix3SetState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorCard(
            title: 'Problem: UI not updating',
            error: 'Changed variable but UI does not reflect changes',
            reason: 'Forgot to call setState() to trigger rebuild.',
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '❌ WRONG CODE:',
            code: '''
int counter = 0;

void increment() {
  counter++;  // UI won't update!
}''',
            isError: true,
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '✅ FIXED CODE:',
            code: '''
int counter = 0;

void increment() {
  setState(() {  // Wrap with setState
    counter++;
  });
}''',
            isError: false,
          ),
          const SizedBox(height: 16),

          const Text('📱 Live Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Live demo with working setState
          _SetStateDemo(),
        ],
      ),
    );
  }

  // ============================================================
  // FIX 4: BuildContext errors with DatePicker
  // ============================================================
  Widget _buildFix4Context() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildErrorCard(
            title: 'Problem: Context errors with dialogs',
            error: 'No Scaffold ancestor / Looking up deactivated widget',
            reason: 'Using wrong context or calling from invalid location.',
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '❌ WRONG CODE:',
            code: '''
// Calling showDatePicker in initState
@override
void initState() {
  super.initState();
  showDatePicker(context: context, ...);  // ERROR!
}''',
            isError: true,
          ),
          const SizedBox(height: 16),

          _buildCodeBlock(
            title: '✅ FIXED CODE:',
            code: '''
// Call from button onPressed or after frame
ElevatedButton(
  onPressed: () async {
    final date = await showDatePicker(
      context: context,  // Valid context from build
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  },
  child: Text('Pick Date'),
)''',
            isError: false,
          ),
          const SizedBox(height: 16),

          const Text('📱 Live Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // Live demo with working DatePicker
          _DatePickerDemo(),
        ],
      ),
    );
  }

  // ============================================================
  // HELPER WIDGETS
  // ============================================================
  Widget _buildErrorCard({required String title, required String error, required String reason}) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(error, style: const TextStyle(fontFamily: 'monospace', color: Colors.red)),
            ),
            const SizedBox(height: 8),
            Text('Reason: $reason', style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeBlock({required String title, required String code, required bool isError}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isError ? Colors.red : Colors.green)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isError ? Colors.red.shade50 : Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isError ? Colors.red.shade200 : Colors.green.shade200),
          ),
          child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildDemoBox(Color color, String label) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

// Separate StatefulWidget for setState demo
class _SetStateDemo extends StatefulWidget {
  @override
  State<_SetStateDemo> createState() => _SetStateDemoState();
}

class _SetStateDemoState extends State<_SetStateDemo> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Counter: $_counter', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: const Text('+ Increment', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      _counter = 0;
                    });
                  },
                  child: const Text('Reset', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for DatePicker demo
class _DatePickerDemo extends StatefulWidget {
  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                // ✅ Correct way to show DatePicker
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick Date (Fixed!)'),
            ),
          ],
        ),
      ),
    );
  }
}