import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List bills = [];

  @override
  void initState() {
    super.initState();
    loadBills();
  }

  Future<void> loadBills() async {
    final repo = ref.read(Provider((ref) => AppRepository()));
    final data = await repo.getBills();
    setState(() => bills = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text("Pre-Invite Visitor"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bills.length,
              itemBuilder: (_, i) {
                final bill = bills[i];
                return ListTile(
                  title: Text("₹${bill['amount']}"),
                  subtitle: Text(bill['status']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
