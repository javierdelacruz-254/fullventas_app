import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';

class UserNotifier extends StateNotifier<ClienteData?> {
  UserNotifier() : super(null);

  bool _isGoogleUser = false;

  void setUser(ClienteData user, {bool isGoogleUser = false}) {
    state = user;
    _isGoogleUser = isGoogleUser;
  }

  bool get isGoogleUser => _isGoogleUser;
  void logout() {
    state = null;
    _isGoogleUser = false;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, ClienteData?>((ref) {
  return UserNotifier();
});
