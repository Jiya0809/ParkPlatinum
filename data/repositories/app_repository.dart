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
