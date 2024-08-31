import 'package:flutter_test/flutter_test.dart';
import 'package:native_player_plugin/native_player_plugin.dart';
import 'package:native_player_plugin/native_player_plugin_platform_interface.dart';
import 'package:native_player_plugin/native_player_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNativePlayerPluginPlatform
    with MockPlatformInterfaceMixin
    implements NativePlayerPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NativePlayerPluginPlatform initialPlatform = NativePlayerPluginPlatform.instance;

  test('$MethodChannelNativePlayerPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNativePlayerPlugin>());
  });

  test('getPlatformVersion', () async {
    NativePlayerPlugin nativePlayerPlugin = NativePlayerPlugin();
    MockNativePlayerPluginPlatform fakePlatform = MockNativePlayerPluginPlatform();
    NativePlayerPluginPlatform.instance = fakePlatform;

    expect(await nativePlayerPlugin.getPlatformVersion(), '42');
  });
}
