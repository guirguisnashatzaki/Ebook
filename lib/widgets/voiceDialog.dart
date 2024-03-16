import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoiceDialog extends StatefulWidget {
  const VoiceDialog({Key? key}) : super(key: key);

  @override
  State<VoiceDialog> createState() => _VoiceDialogState();
}

class _VoiceDialogState extends State<VoiceDialog> {

  final player = AudioPlayer();

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(

      ),
    );
  }
}
