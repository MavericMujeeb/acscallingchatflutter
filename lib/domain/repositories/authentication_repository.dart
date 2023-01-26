import 'package:acscallingchatflutter/domain/entities/user_dao.dart';

abstract class AuthenticationRepository {
  /// Login
  Future<UserDao> loginUser(String username, String password);
}
