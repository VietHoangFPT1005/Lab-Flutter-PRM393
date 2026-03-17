
import 'package:flutter/material.dart';

class Exercise04 extends StatefulWidget {
  const Exercise04({super.key});

  @override
  State<Exercise04> createState() => _Exercise04();
}

class _Exercise04 extends State<Exercise04> {
  // State để quản lý Dark Mode
  bool _isDarkMode = false;
  int _counter = 0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Tạo ThemeData dựa trên dark mode state
    final ThemeData theme = _isDarkMode
        ? ThemeData.dark().copyWith(
      // Customize dark theme
      colorScheme: ColorScheme.dark(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        surface: Colors.grey.shade900,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    )
        : ThemeData.light().copyWith(
      // Customize light theme
      colorScheme: ColorScheme.light(
        primary: Colors.purple,
        secondary: Colors.purpleAccent,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );

    // Wrap với Theme widget để áp dụng theme
    return Theme(
      data: theme,
      child: Scaffold(
        // 1. APP BAR
        appBar: AppBar(
          title: const Text('Exercise 4: Scaffold & Theme'),
          // Actions buttons ở bên phải AppBar
          actions: [
            // Dark mode toggle button
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
            // Menu button
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showMenu(context);
              },
            ),
          ],
        ),

        // 2. DRAWER - Menu bên trái
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.purple),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Flutter Student',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      'student@example.com',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Drawer Items
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // 3. BODY - Nội dung chính
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Current theme: ${_isDarkMode ? "Dark" : "Light"}',
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      ),
                      const SizedBox(height: 8),
                      // Toggle switch
                      SwitchListTile(
                        title: const Text('Toggle Dark Mode'),
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Counter card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'FAB Counter Demo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$_counter',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Text('Press FAB to increment'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Theme colors preview
              const Text(
                'Theme Colors:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildColorBox('Primary', theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  _buildColorBox('Secondary', theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  _buildColorBox('Surface', theme.colorScheme.surface),
                ],
              ),
              const SizedBox(height: 16),

              // Scaffold structure info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📝 Scaffold Structure:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.web_asset, 'AppBar', 'Top navigation bar'),
                      _buildInfoRow(Icons.menu, 'Drawer', 'Side navigation menu'),
                      _buildInfoRow(Icons.article, 'Body', 'Main content area'),
                      _buildInfoRow(Icons.add_circle, 'FAB', 'Floating Action Button'),
                      _buildInfoRow(Icons.navigation, 'BottomNavBar', 'Bottom navigation'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4. FLOATING ACTION BUTTON
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
            // Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Counter: $_counter'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // 5. BOTTOM NAVIGATION BAR
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: theme.colorScheme.primary,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Helper: Color box
  Widget _buildColorBox(String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper: Info row
  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.purple),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(subtitle)),
        ],
      ),
    );
  }

  // Show popup menu
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}