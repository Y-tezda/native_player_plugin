import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_player_plugin_method_channel.dart';

abstract class NativePlayerPluginPlatform extends PlatformInterface {
  /// Constructs a NativePlayerPluginPlatform.
  NativePlayerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativePlayerPluginPlatform _instance = MethodChannelNativePlayerPlugin();

  /// The default instance of [NativePlayerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativePlayerPlugin].
  static NativePlayerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativePlayerPluginPlatform] when
  /// they register themselves.
  static set instance(NativePlayerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
