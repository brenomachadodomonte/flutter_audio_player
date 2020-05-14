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
  bool _muted = false;
  double _volume = 1.0;

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

    advancedPlayer.setVolume(_volume);
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

  _seekToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
              ),
              child: Slider(
                value: _position.inSeconds.toDouble(),
                onChanged: (double value) {
                  _seekToSecond(value.toInt());
                },
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.stop, color: Colors.grey),
                  onTap: (){
                    _stop();
                  },
                ),
                InkWell(
                  child: Icon(Icons.volume_off, color: _muted ? Colors.blue : Colors.grey),
                  onTap: (){
                    setState(() {
                      if(_muted){
                        advancedPlayer.setVolume(_volume);
                      } else {
                        advancedPlayer.setVolume(0);
                      }
                      setState(() {
                        _muted = !_muted;
                      });
                    });
                  },
                ),
                InkWell(
                  child: Icon(state == PlayerState.playing ? Icons.pause_circle_outline: Icons.play_circle_outline, color: Colors.blue, size: 60,),
                  onTap: (){
                    if(state == PlayerState.playing){
                      _pause();
                    } else {
                      _play();
                    }
                  },
                ),
                InkWell(
                  child: Icon(Icons.loop, color: autoReplay ? Colors.blue : Colors.grey,),
                  onTap: (){
                    setState(() {
                      autoReplay = !autoReplay;
                    });
                  },
                ),
                InkWell(
                  child: Icon(Icons.volume_up, color: Colors.grey),
                  onTap: (){
                    setState(() {
                      autoReplay = !autoReplay;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
