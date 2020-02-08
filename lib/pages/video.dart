import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/api/car_api.dart';
import 'package:carros/api/loripsum_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  Car c;

  Video(this.c);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  final _bloc = LoripsumBloc();
  bool isShow = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
        _controller = VideoPlayerController.network(
            'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
          ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          isShow = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          !isShow ? Container(
            height: 150,
            child: LoadingRotating.square(
              size: 20,
              backgroundColor: Colors.greenAccent,
              duration: Duration(milliseconds: 900),
            ),
          ) :
          _video(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          _content(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          _description(),
        ],
      ),
    );
  }

  _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Text(
          "Descrição\n",
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: _bloc.stream,
          builder: (c, s) {
            if (!s.hasData) {
              return Center(
                child: LoadingBouncingGrid.circle(
                  size: 45,
                  inverted: true,
                  backgroundColor: Colors.greenAccent,
                  duration: Duration(milliseconds: 900),
                ),
              );
            }
            return Text(
              s.data,
              style: TextStyle(
                fontSize: 15,
              ),
            );
          },
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  _content() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.c.nome,
              maxLines: 1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Tipo: ${widget.c.tipo}",
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            !isShow
                ? Center(
                    child: LoadingBouncingLine.circle(
                      size: 20,
                      backgroundColor: Colors.greenAccent,
                      duration: Duration(milliseconds: 900),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: _onClickVideo,
                  ),
          ],
        ),
      ],
    );
  }

  imageCar(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      width: 250,
      height: 250,
      placeholder: (context, url) => SizedBox(
        height: 90,
        width: 90,
        child: LoadingFlipping.circle(
          size: 25,
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 900),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  _video() {
    return Column(
      children: <Widget>[
        Center(
          child: _controller.value.initialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
      ],
    );
  }

  _onClickVideo() {
    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }
}
