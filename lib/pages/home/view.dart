import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app_e/pages/detail/view.dart';
import 'package:note_app_e/utils/notif_show.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.initNotification(context);
    Utils.initNotificationToken();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<HomeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Note")),
      body: StreamBuilder(
        stream: provider.noteRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot note = snapshot.data!.docs[index];
                  return Slidable(
                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((context) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete Note"),
                                  content: const Text(
                                      "Do you agree to delete the note?"),
                                  actions: [
                                    _textButtonDialog(
                                      text: "Cancel",
                                      color: Colors.white,
                                      id: note['id'],
                                    ),
                                    _textButtonDialog(
                                      text: "Delete",
                                      color: Colors.red,
                                      id: note['id'],
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(note['title'],
                            overflow: TextOverflow.ellipsis),
                        subtitle: Text(note['body']),
                        trailing: Column(
                          children: [
                            Text(note['time'].substring(11, 16)),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(child: Text("No data"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const DetailPage()));
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }

  MaterialButton _textButtonDialog({text, color, id}) {
    return MaterialButton(
      onPressed: () {
        if (text == "Cancel") {
          Navigator.pop(context);
        } else {
          HomeProvider.deleteNote(id);
          Navigator.pop(context);
        }
      },
      child: Text(text),
      textColor: color,
    );
  }
}
