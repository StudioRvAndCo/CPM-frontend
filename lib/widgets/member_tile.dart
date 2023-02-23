import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Participant.dart';

enum MenuAction { edit, delete }

class ParticipantTile extends StatefulWidget {
  const ParticipantTile({super.key, required this.participant});

  final Participant participant;

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundImage: AssetImage('assets/placeholder_profile_picture.jpg')),
      title: Text(
        '${widget.participant.firstName} ${widget.participant.lastName.toUpperCase()}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.participant.phone,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              onPressed: () {
                launchUrl(Uri.parse('tel://0607706869'));
              },
              icon: const Icon(Icons.phone)),
          IconButton(
              onPressed: () {
                launchUrl(Uri.parse('sms://0607706869'));
              },
              icon: const Icon(Icons.message)),
          PopupMenuButton<MenuAction>(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                  )),
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                  )),
            ],
            onSelected: (MenuAction action) {
              setState(() {
                print(action);
              });
            },
          )
        ],
      ),
    );
  }
}
