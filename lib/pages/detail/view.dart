import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    DetailProvider().titleController.dispose();
    DetailProvider().bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DetailProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<DetailProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Create new Note")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            if (provider.isLoading) const LinearProgressIndicator(),
            const Spacer(),
            _textField(label: "Title", controller: provider.titleController),
            const SizedBox(height: 20),
            _textField(label: "Body", controller: provider.bodyController),
            const SizedBox(height: 40),
            MaterialButton(
              onPressed: () {
                provider.saveNote();
                Navigator.pop(context);
              },
              child: const Text("Save"),
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  TextField _textField({label, controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
