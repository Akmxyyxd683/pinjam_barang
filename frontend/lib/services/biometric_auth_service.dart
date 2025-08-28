import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate({required String reason}) async {
    try {
      final isAvailable = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        return false;
      }

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Gunakan biometrik untuk login',
        options: const AuthenticationOptions(
          biometricOnly: true, // hanya biometrik
          stickyAuth: true, // biar gak reset kalau pindah app
        ),
      );

      return didAuthenticate;
    } catch (e) {
      print("Error biometrik: $e");
      return false;
    }
  }
}
