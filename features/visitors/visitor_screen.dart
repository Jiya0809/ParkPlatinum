import 'package:flutter/material.dart';
import '../../data/repositories/app_repository.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});

  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  final repo = AppRepository();
  final controller = TextEditingController();

  void createVisitor() async {
    await repo.createVisitor(controller.text, "FLAT_101");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Visitor Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Visitor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(
              onPressed: createVisitor,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
