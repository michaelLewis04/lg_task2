import 'package:flutter/material.dart';
import 'package:lg_task2/components/connection_flag.dart';
import 'package:lg_task2/connections/ssh.dart';
import 'package:lg_task2/screens/home_page.dart';
import 'package:lg_task2/screens/screen_1.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SSH ssh;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    loadSetting();
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    ssh = SSH();
    bool result = await ssh.connectToLG();
    setState(() {
      ConnectionStatus = result;
    });
  }

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    _rigsController.dispose();
    super.dispose();
  }

  Future<void> loadSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('port') ?? '';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('port', _sshPortController.text);
    }
    if (_rigsController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', _rigsController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, ConnectionStatus);
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ConnectionFlag(
                      status: ConnectionStatus,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.computer),
                  labelText: 'IP address',
                  hintText: 'Enter Master IP',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'LG Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'LG Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _sshPortController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.settings_ethernet),
                  labelText: 'SSH Port',
                  hintText: '22',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _rigsController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.memory),
                  labelText: 'No. of LG rigs',
                  hintText: 'Enter the number of rigs',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                onPressed: () async {
                  await saveSettings();
                  await _connectToLG();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cast,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'CONNECT TO LG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // TextButton(
              //   style: const ButtonStyle(
              //     backgroundColor: WidgetStatePropertyAll(Colors.green),
              //     shape: WidgetStatePropertyAll(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(50),
              //         ),
              //       ),
              //     ),
              //   ),
              //   onPressed: () async {
              //     // TODO 7: Initialize SSH and execute the demo command and test
              //     // SSH ssh =
              //     //     SSH(); //Re-initialization of the SSH instance to avoid errors for beginners
              //     // await ssh.connectToLG();
              //     // SSHSession? execResult = await ssh.execute();
              //     // if (execResult != null) {
              //     //   print('Command executed successfully');
              //     // } else {
              //     //   print('Failed to execute command');
              //     // }
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: Center(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.cast,
              //             color: Colors.white,
              //           ),
              //           SizedBox(
              //             width: 20,
              //           ),
              //           Text(
              //             'SEND COMMAND TO LG',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 20,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
