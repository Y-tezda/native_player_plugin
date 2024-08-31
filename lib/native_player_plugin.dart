
import 'native_player_plugin_platform_interface.dart';
class NativePlayerPlugin {
  Future<String?> getPlatformVersion() {
    return NativePlayerPluginPlatform.instance.getPlatformVersion();
  }
}
