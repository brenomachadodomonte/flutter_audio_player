import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

enum PlayerState { stopped, playing, paused }

class _PlayerState extends State<Player> {

  String audioPath = 'music/music.mp3';

  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  PlayerState state = PlayerState.stopped;
  bool autoReplay = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer(){
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });

    advancedPlayer.positionHandler = (p) => setState(() {
      _position = p;
    });

    advancedPlayer.completionHandler = () => setState((){
      if(autoReplay){
        _play();
      } else {
        state = PlayerState.stopped;
      }
    });

  }

  //Audio Controls
  _play() {
    setState(() {
      audioCache.play(audioPath);
      state = PlayerState.playing;
    });
  }

  _stop() {
    setState(() {
      advancedPlayer.stop();
      state = PlayerState.stopped;
      _position = Duration();
    });
  }

  _pause(){
    setState(() {
      advancedPlayer.pause();
      state = PlayerState.paused;
    });
  }

  _resume(){
    setState(() {
      advancedPlayer.resume();
      state = PlayerState.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text('Comming Soon'),
        ),
      ),
    );
  }
}
