import 'package:flutter/material.dart';
import 'package:videocall/src/utils/universal_variables.dart';
import 'package:videocall/service/auth.dart';
import 'package:videocall/src/utils/call_utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:videocall/model/store_user.dart';

class CustomTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final Userlar receiver;

  CustomTile({
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.onLongPress,
    this.mini = true,
    this.receiver,
  });

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  ClientRole _role = ClientRole.Broadcaster;
  AuthServices _auth = AuthServices();
  String _currentUserId;
  Userlar sender;
  @override
  void initState() {
    super.initState();
    _auth.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = Userlar(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.mini ? 10 : 0),
        margin: widget.margin,
        child: Row(
          children: <Widget>[
            widget.leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: widget.mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: widget.mini ? 3 : 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: UniversalVariables.separatorColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.title,
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            widget.icon ?? Container(),
                            widget.subtitle,
                          ],
                        )
                      ],
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.video_call,
                        ),
                        onPressed: () async {
                          await _handleCameraAndMic(Permission.camera);
                          await _handleCameraAndMic(Permission.microphone);
                          return CallUtils.dial(
                            from: sender,
                            to: widget.receiver,
                            context: context,
                            role: _role,
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
