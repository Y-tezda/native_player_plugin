import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_player_plugin_platform_interface.dart';

/// An implementation of [NativePlayerPluginPlatform] that uses method channels.
class MethodChannelNativePlayerPlugin extends NativePlayerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_player_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
