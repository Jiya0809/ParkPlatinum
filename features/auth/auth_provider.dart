import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/app_repository.dart';

final authProvider = Provider((ref) => AppRepository());
