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
