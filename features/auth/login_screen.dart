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
