
import 'package:flutter/material.dart';

class Exercise01 extends StatelessWidget {
  const Exercise01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1: Core Widgets'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TEXT WIDGET
            // Hiển thị văn bản với các style khác nhau
            const Text(
              'Welcome to Flutter!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a demonstration of core Flutter widgets including Text, Image, Icon, Card, and ListTile.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // 2. ICON WIDGET
            // Hiển thị các icon từ Material Icons
            const Text(
              'Icon Widget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Icon với màu và kích thước tùy chỉnh
                Icon(Icons.home, size: 40, color: Colors.blue),
                Icon(Icons.favorite, size: 40, color: Colors.red),
                Icon(Icons.star, size: 40, color: Colors.amber),
                Icon(Icons.person, size: 40, color: Colors.green),
                Icon(Icons.settings, size: 40, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 24),

            // 3. IMAGE WIDGET
            // Hiển thị hình ảnh từ internet
            const Text(
              'Image Widget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/400/200', // Random image from Lorem Picsum
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Hiển thị loading indicator khi đang tải
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                // Hiển thị icon lỗi nếu không tải được
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 4. CARD WIDGET
            // Card chứa nội dung với shadow và border radius
            const Text(
              'Card Widget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4, // Độ đổ bóng
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Card',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cards contain content and actions about a single subject. They can be used for displaying information in a clean, organized way.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. LISTTILE WIDGET
            // ListTile để hiển thị danh sách items
            const Text(
              'ListTile Widget:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ListTile trong Card
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: const Text('Nguyen Van A'),
                    subtitle: const Text('Flutter Developer'),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {},
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: const Text('Tran Thi B'),
                    subtitle: const Text('UI/UX Designer'),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {},
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: const Text('Le Van C'),
                    subtitle: const Text('Project Manager'),
                    trailing: IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📝 Summary:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('• Text: Display styled text'),
                  Text('• Icon: Material icons with customizable size/color'),
                  Text('• Image: Load images from network/assets'),
                  Text('• Card: Container with elevation and rounded corners'),
                  Text('• ListTile: Structured row for list items'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}