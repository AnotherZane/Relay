import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:relay/actions/server_actions.dart';
import 'package:relay/models/cached/server.dart';
import 'package:relay/models/relay_state.dart';

class EditServerScreen extends StatefulWidget {
  final CachedServer server;

  const EditServerScreen(this.server, {Key? key}) : super(key: key);

  @override
  State<EditServerScreen> createState() => _EditServerScreenState();
}

class _EditServerScreenState extends State<EditServerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _ssl = false;

  @override
  void initState() {
    _nameController.text = widget.server.name;
    _addressController.text = widget.server.host;
    _portController.text = widget.server.port.toString();
    _usernameController.text = widget.server.username;
    _nicknameController.text = widget.server.nickname ?? "";
    _passwordController.text = widget.server.password ?? "";
    _ssl = widget.server.ssl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Server"),
              SizedBox(height: 2),
              Text("Edit ${widget.server.name}",
                  style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
          titleSpacing: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                    flex: 0,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Server Name",
                      ),
                      autofocus: true,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a server name";
                        }
                        else if (value.length > 32) {
                          return "Server name must be less than 32 characters";
                        }

                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: "Address",
                          ),
                          autofillHints: const [AutofillHints.url],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a server address";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _portController,
                          decoration: const InputDecoration(
                            hintText: "Port (optional)",
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }

                            final port = int.tryParse(value);

                            if (port == null) {
                              return "Port must be a number";
                            }
                            else if (port < 1 || port > 65535) {
                              return "Port must be between 1 and 65535";
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text("Use SSL"),
                  value: _ssl,
                  onChanged: (newValue) => setState(() { _ssl = newValue ?? false; }),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "Username",
                  ),
                  autofillHints: const [AutofillHints.username],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    hintText: "Nickname (optional)",
                  ),
                  autofillHints: const [AutofillHints.nickname],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password (optional)",
                  ),
                  autofillHints: const [AutofillHints.password],
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please enter a server name"),
                ));
                return;
              }
              else if (_addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please enter a server address"),
                ));
                return;
              }
              else if (_usernameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please enter a username"),
                ));
                return;
              }

              StoreProvider.of<RelayState>(context).dispatch(UpdateServerAction(
                      widget.server.copyWith(
                        name: _nameController.text,
                        host: _addressController.text,
                        port: _portController.text.isEmpty
                            ? 6667
                            : int.parse(_portController.text),
                        username: _usernameController.text,
                        ssl: _ssl,
                        nickname: _nicknameController.text.isNotEmpty ? _nicknameController.text : null,
                        password: _passwordController.text.isNotEmpty ? _passwordController.text : null
                      )
              ));

              Navigator.pop(context);
            },
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.check)
        ));
  }
}
