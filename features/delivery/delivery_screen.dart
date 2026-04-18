import 'package:flutter/material.dart';
import '../../data/repositories/app_repository.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final repo = AppRepository();
  final controller = TextEditingController();

  void addDelivery() async {
    await repo.addDelivery(controller.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Delivery Added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(
              onPressed: addDelivery,
              child: const Text("Add Delivery"),
            ),
          ],
        ),
      ),
    );
  }
}
