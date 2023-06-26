import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class PortBlockerPage extends StatefulWidget {
  static const List<String> items = [
    'Close Port',
    'Show Ports',
    'Scan Ports',
  ];

  @override
  State<PortBlockerPage> createState() => _PortBlockerPageState();
}

class _PortBlockerPageState extends State<PortBlockerPage> {
  final inputPortController = TextEditingController();
  List<int> blockedPorts = [];
  final formKey = GlobalKey<FormState>();

  addBlockedPorts(int port) {
    setState(() {
      if (!blockedPorts.contains(port)) {
        blockedPorts.add(port);
      }
    });
  }

  @override
  void dispose() {
    inputPortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Port Blocker'),
      ),
      body: Row(
        children: [
          Drawer(
            child: ListView.builder(
              itemCount: PortBlockerPage.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(PortBlockerPage.items[index]),
                  onTap: () async {
                    if (index == 0) {
                      final portInput = await _dialogBuilder(context);
                      if (portInput != null && !portInput.isEmpty) {
                        addBlockedPorts(int.parse(portInput));
                      }
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: blockedPorts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.explore),
                        title: Text(blockedPorts[index].toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              blockedPorts.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _dialogBuilder<String>(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Close Port'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: inputPortController,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select a port",
                labelText: "Port",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Port cannot be empty";
                } else if (int.tryParse(value) == null) {
                  return "Port must be a number";
                } else if (int.parse(value) < 1024) {
                  return "Port must be greater than 1023";
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop('');
                inputPortController.clear();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(inputPortController.text);
                  inputPortController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
