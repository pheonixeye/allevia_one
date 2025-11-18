import 'package:allevia_one/assets/assets.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundHelper {
  const SoundHelper._();

  static final SoundHelper _instance = SoundHelper._();

  factory SoundHelper() {
    return _instance;
  }

  static final _player = AudioPlayer();

  static final _src = AssetSource(
    AppAssets.notification_sound,
  );

  static void playSound() async {
    await _player.play(_src);
  }
}
