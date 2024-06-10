import 'package:flutter/material.dart';

class NotificationMenu extends StatefulWidget {
  @override
  NotificationMenuState createState() => NotificationMenuState();
}

class NotificationMenuState extends State<NotificationMenu> {
  bool allowNotifications = false;
  bool playSound = false;
  double soundValue = 50;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Allow Notifications'),
          trailing: Switch(
            value: allowNotifications,
            onChanged: (value) {
              setState(() {
                allowNotifications = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Play sound on notification'),
          trailing: Switch(
            value: playSound,
            onChanged: (value) {
              setState(() {
                playSound = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Sound Volume', style: TextStyle(fontSize: 16)),
              Slider(
                value: soundValue,
                onChanged: allowNotifications && playSound
                    ? (value) {
                        setState(() {
                          soundValue = value;
                        });
                      }
                    : null,
                min: 0,
                max: 100,
                divisions: 10,
                label: soundValue.round().toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}