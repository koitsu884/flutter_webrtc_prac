import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTF',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _localRenderer = new RTCVideoRenderer();
  final _remoteRenderer = new RTCVideoRenderer();

  final sdpController = TextEditingController();

  @override
  dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> constraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream = await navigator.getUserMedia(constraints);

    _localRenderer.srcObject = stream;
  }

SizedBox videoRenderers() => SizedBox(
  height: 210,
  child: Row(
    children: [
      Flexible(
        child: Container(
          key: Key('local'),
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          decoration: BoxDecoration(color: Colors.black),
          child: RTCVideoView(_localRenderer)
        ),
        ),
        Flexible(
        child: Container(
          key: Key('remote'),
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          decoration: BoxDecoration(color: Colors.black),
          child: RTCVideoView(_remoteRenderer)
        ),
        ),
    ],
  )
);

Row offerAndAnswerButtons() => Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    RaisedButton(
      onPressed: null,
      child: Text('Offed'),
      color: Colors.amber,
    ),
    RaisedButton(
      onPressed: null,
      child: Text('ANswer'),
      color: Colors.amber,
    )
  ],
);

Padding sdpCandidateTF() => Padding(
  padding: const EdgeInsets.all(16.0),
  child: TextField(
    controller: sdpController,
    keyboardType: TextInputType.multiline,
    maxLines: 4,
    maxLength: TextField.noMaxLength,
  )
);

Row sdpCandidateButtons() => Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    RaisedButton(
      onPressed: null, //_setRemoteDescription, 
      child: Text('Set Remote desc.'),
      color: Colors.amber,
    ),
      RaisedButton(
      onPressed: null, //_setCandidateDescription, 
      child: Text('Set Candidate.'),
      color: Colors.amber,
    ),
  ],
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            videoRenderers(),
            offerAndAnswerButtons(),
            sdpCandidateTF(),
            sdpCandidateButtons(),
          ],
        )
        )
    );
  }
}
