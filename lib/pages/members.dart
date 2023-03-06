import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../dialogs/confirm_dialog.dart';
import '../dialogs/new_edit_member.dart';
import '../exceptions/invalid_direction_exception.dart';
import '../models/member.dart';
import '../services/member.dart';
import '../widgets/member_tile.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  List<Member> members = <Member>[];

  final Divider divider = const Divider(
    thickness: 1,
    color: Colors.grey,
    indent: 16,
    endIndent: 16,
    height: 0,
  );

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<MemberTile> membersTiles = members.map((Member member) => MemberTile(
          member: member,
          onEdit: (Member member) {
            edit(member);
          },
          onDelete: (Member member) {
            showConfirmationDialog(context, 'delete.lower'.tr()).then((bool? result) {
              if (result ?? false) {
                delete(member);
              }
            });
          },
        ));

    if (members.isEmpty) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <CircularProgressIndicator>[
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return Expanded(
          child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: add, child: const Icon(Icons.add)),
        body: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => divider,
          itemCount: membersTiles.length,
          itemBuilder: (BuildContext context, int index) => ClipRRect(
            clipBehavior: Clip.hardEdge,
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                final Member member = membersTiles.elementAt(index).member;
                switch (direction) {
                  case DismissDirection.startToEnd:
                    delete(member);
                    break;
                  case DismissDirection.endToStart:
                  case DismissDirection.vertical:
                  case DismissDirection.horizontal:
                  case DismissDirection.up:
                  case DismissDirection.down:
                  case DismissDirection.none:
                    throw InvalidDirectionException('error.direction'.tr());
                }
              },
              confirmDismiss: (DismissDirection dismissDirection) async {
                switch (dismissDirection) {
                  case DismissDirection.endToStart:
                    final Member member = membersTiles.elementAt(index).member;
                    edit(member);
                    return false;
                  case DismissDirection.startToEnd:
                    return await showConfirmationDialog(context, 'delete.lower'.tr()) ?? false;
                  case DismissDirection.horizontal:
                  case DismissDirection.vertical:
                  case DismissDirection.up:
                  case DismissDirection.down:
                  case DismissDirection.none:
                    assert(false);
                }
                return false;
              },
              background: deleteBackground(),
              secondaryBackground: editBackground(),
              child: membersTiles.elementAt(index),
            ),
          ),
        ),
      ));
    }
  }

  void edit(Member member) {
    showDialog<Member>(
        context: context,
        builder: (BuildContext context) {
          return MemberDialog(
              edit: true,
              firstName: member.firstName,
              lastName: member.lastName,
              phone: member.phone,
              image: member.image);
        }).then(
      (Member? result) {
        if (result != null) {
          setState(() {
            member.firstName = result.firstName;
            member.lastName = result.lastName;
            member.phone = result.phone;
            member.image = result.image;
          });
        }
      },
    );
  }

  void delete(Member member) {
    setState(() {
      members.remove(member);
    });
  }

  void add() {
    showDialog<Member>(
        context: context,
        builder: (BuildContext context) {
          return const MemberDialog(
            edit: false,
          );
        }).then(
      (Member? result) {
        if (result != null) {
          setState(() {
            // TODO(mael): add member via API
          });
        }
      },
    );
  }

  Future<void> getMembers() async {
    final List<dynamic> result = await MemberService().getMembers();
    setState(() {
      members = result[1] as List<Member>;
    });
  }
}
