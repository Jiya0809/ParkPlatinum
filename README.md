# ParkPlatinum
Society App

lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── config/supabase_config.dart
│   ├── router/app_router.dart
│   └── theme/app_theme.dart
│
├── data/
│   ├── services/supabase_service.dart
│   └── repositories/app_repository.dart
│
├── features/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── auth_provider.dart
│   │
│   ├── home/home_screen.dart
│   ├── visitors/visitor_screen.dart
│   └── delivery/delivery_screen.dart
│
├── shared/widgets/primary_button.dart


🟢 1. main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

🟢 2. app.dart
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}

🟢 3. core/config/supabase_config.dart
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_KEY');

🟢 4. core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
  ],
);

🟢 5. core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: Colors.green,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
  );
}

🟢 6. data/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> sendOtp(String phone) async {
    await supabase.auth.signInWithOtp(phone: phone);
  }

  Future<void> verifyOtp(String phone, String otp) async {
    await supabase.auth.verifyOTP(
      phone: phone,
      token: otp,
      type: OtpType.sms,
    );
  }

  Future<List> getBills() async {
    return await supabase.from('bills').select();
  }

  Future<void> createVisitor(String name, String flatId) async {
    await supabase.from('visitors').insert({
      'name': name,
      'flat_id': flatId,
      'type': 'preapproved',
      'status': 'approved',
    });
  }

  Future<void> addDelivery(String flatId) async {
    await supabase.from('deliveries').insert({
      'flat_id': flatId,
      'status': 'entered',
    });
  }
}

🟢 7. data/repositories/app_repository.dart
import '../services/supabase_service.dart';

class AppRepository {
  final service = SupabaseService();

  Future sendOtp(String phone) => service.sendOtp(phone);

  Future verifyOtp(String phone, String otp) =>
      service.verifyOtp(phone, otp);

  Future getBills() => service.getBills();

  Future createVisitor(String name, String flatId) =>
      service.createVisitor(name, flatId);

  Future addDelivery(String flatId) =>
      service.addDelivery(flatId);
}

🟢 8. features/auth/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_repository.dart';

final authProvider = Provider((ref) => AppRepository());

🟢 9. features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool otpSent = false;

  void sendOtp() async {
    await ref.read(authProvider).sendOtp(phoneController.text);
    setState(() => otpSent = true);
  }

  void verifyOtp() async {
    await ref
        .read(authProvider)
        .verifyOtp(phoneController.text, otpController.text);

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Park Platinum")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            if (otpSent)
              TextField(
                controller: otpController,
                decoration: const InputDecoration(labelText: "OTP"),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? verifyOtp : sendOtp,
              child: Text(otpSent ? "Verify OTP" : "Send OTP"),
            )
          ],
        ),
      ),
    );
  }
}
🟢 10. features/home/home_screen.dart
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
🟢 11. features/visitors/visitor_screen.dart
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
🟢 12. features/delivery/delivery_screen.dart
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
🟢 13. shared/widgets/primary_button.dart
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
