import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

void registerProtocolHandler(String scheme) {
  if (!Platform.isWindows) return;

  final appPath = Platform.resolvedExecutable;
  final protocolKey = CURRENT_USER.create('Software\\Classes\\$scheme');

  try {
    protocolKey.setValue('URL Protocol', RegistryValue.string(''));

    final commandKey = protocolKey.create('shell\\open\\command');
    try {
      commandKey.setValue('', RegistryValue.string('"$appPath" "%1"'));
    } finally {
      commandKey.close();
    }
  } finally {
    protocolKey.close();
  }
}
