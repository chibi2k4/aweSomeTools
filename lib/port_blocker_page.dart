import 'package:aweSomeTools/enums/ip.dart';
import 'package:aweSomeTools/util/socket_service.dart';
import 'package:flutter/material.dart';

class PortBlockerPage extends StatefulWidget {
  static const List<String> items = [
    'Close Port',
    'Reopen all Ports',
  ];

  @override
  State<PortBlockerPage> createState() => _PortBlockerPageState();
}

class _PortBlockerPageState extends State<PortBlockerPage> {
  final inputPortController = TextEditingController();
  final socketService = SocketService();
  List<int> blockedPorts = [];
  Map<int, IpType> blockPortTypes = {};
  final formKey = GlobalKey<FormState>();
  IpType _ipType = IpType.ipv4;

  addBlockedPorts(int port) async {
    if (!blockedPorts.contains(port)) {
      bool blocked = await socketService.startBlockingPort(port, _ipType);

      if (blocked) {
        setState(() {
          blockedPorts.add(port);
          blockPortTypes[port] = _ipType;
        });
      }
    } else {
      await _errorMessageDialog('Port could not be blocked!');
    }
  }

  testPort(int port) async {
    bool res =
        await socketService.testBlockingPort(port, blockPortTypes[port]!);

    if (res) {
      await (_errorMessageDialog('Port is blocked!'));
    } else {
      await (_errorMessageDialog('Port is not blocked!'));
    }
  }

  @override
  void dispose() {
    inputPortController.dispose();
    unblockAll(false);
    super.dispose();
  }

  unblockAll(bool stating) {
    for (int blockedPort in blockedPorts) {
      socketService.stopBlockingPort(blockedPort);
    }
    if (stating) {
      setState(() {
        blockedPorts.clear();
      });
    } else {
      blockedPorts.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Port Blocker'),
      ),
      body: Center(
        child: Row(
          children: [
            Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.attractions),
                    title: Text(PortBlockerPage.items[0]),
                    onTap: () async {
                      final portInput = await _portDialogBuilder(context);
                      if (!portInput!.isEmpty) {
                        addBlockedPorts(int.parse(portInput));
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attractions),
                    title: Text(PortBlockerPage.items[1]),
                    onTap: () {
                      unblockAll(true);
                    },
                  ),
                ],
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
                          subtitle: Text(
                              blockPortTypes[blockedPorts[index]].toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Open Port',
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    socketService
                                        .stopBlockingPort(blockedPorts[index]);
                                    blockedPorts.removeAt(index);
                                  });
                                },
                              ),
                              IconButton(
                                tooltip: 'Test Port',
                                icon: Icon(Icons.info),
                                onPressed: () {
                                  setState(() {
                                    testPort(blockedPorts[index]);
                                  });
                                },
                              ),
                            ],
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
      ),
    );
  }

  Future<String?> _portDialogBuilder<String>(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Close Port'),
          content: Wrap(
            children: [
              Form(
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
              Divider(),
              Column(
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          RadioListTile(
                            value: IpType.ipv4,
                            groupValue: _ipType,
                            title: const Text('IPv4'),
                            onChanged: (value) {
                              setState(() {
                                _ipType = IpType.ipv4;
                              });
                            },
                          ),
                          RadioListTile(
                            value: IpType.ipv6,
                            groupValue: _ipType,
                            title: const Text('IPv6'),
                            onChanged: (value) {
                              setState(() {
                                _ipType = IpType.ipv6;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
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
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white),
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

  _errorMessageDialog(String text) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Wrap(
            children: [],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
