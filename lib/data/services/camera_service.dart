import 'package:local_auth/local_auth.dart';

class CameraService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    return canCheck || supported;
  }

  Future<bool> authenticate() async {
    if (!await canAuthenticate()) return false;
    return _auth.authenticate(
      localizedReason: 'Verifica tu identidad para acceder a NexusLED',
      options: const AuthenticationOptions(
        biometricOnly: false,
        stickyAuth: true,
      ),
    );
  }
}
