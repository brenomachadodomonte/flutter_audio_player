import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flare_flutter/flare_actor.dart';
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
  bool _showVolControl = false;
  double _volume = 0.8;

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

  _resume(){
    setState(() {
      advancedPlayer.resume();
      state = PlayerState.playing;
    });
  }

  _seekToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: width,
              height: width,
              child: FlareActor('assets/animation/vinyl_player.flr',
                animation: 'spin',
                isPaused: !(state == PlayerState.playing),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${_position.inMinutes.toString().padLeft(2, '0')}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  '${(_duration - _position).inMinutes.toString().padLeft(2, '0')}:${((_duration - _position).inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            Slider(
              value: _position.inSeconds.toDouble(),
              onChanged: (double value) {
                _seekToSecond(value.toInt());
              },
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
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
                    switch(state){
                      case PlayerState.stopped: _play(); break;
                      case PlayerState.paused: _resume(); break;
                      case PlayerState.playing: _pause(); break;
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
                  child: Icon(Icons.volume_up, color: _showVolControl ? Colors.blue : Colors.grey),
                  onTap: (){
                    setState(() {
                      _showVolControl = !_showVolControl;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Opacity(
              opacity: _showVolControl ? 1.0 : 0.0,
              child: Container(
                width: width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(Icons.volume_mute, color: Colors.grey),
                      onTap: (){
                        setState(() {
                          double newVol = _volume - 0.1;
                          _volume = (newVol < 0) ? 0 : newVol;
                          advancedPlayer.setVolume(_volume);
                        });
                      },
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (double value) {
                          setState(() {
                            _volume = value;
                            advancedPlayer.setVolume(value);
                          });
                        },
                        label: '$_volume',
                        min: 0.0,
                        max: 1.0,
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.volume_up, color: Colors.grey),
                      onTap: (){
                        setState(() {
                          double newVol = _volume + 0.1;
                          _volume = (newVol > 1) ? 1 : newVol;
                          advancedPlayer.setVolume(_volume);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
