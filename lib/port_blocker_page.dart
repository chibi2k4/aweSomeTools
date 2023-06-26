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
                  onTap: () {
                    if (index == 0) {
                      _dialogBuilder(context);
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Close Port'),
          content: TextFormField(
            controller: inputPortController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select a port",
                labelText: "Port"),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                addBlockedPorts(int.parse(inputPortController.text));
                inputPortController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
