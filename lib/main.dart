import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_enclave/secure_enclave.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Testing secure enclave'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Alert'),
                    content: Text('This is a Cupertino-style dialog.'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () async {
                          final _secureEnclavePlugin1 = SecureEnclave();
                          final bool? status = (await _secureEnclavePlugin1
                                  .isKeyCreated(tag: 'kota'))
                              .value;
                          print('pre creation status: $status');

                          final _secureEnclavePlugin = SecureEnclave();

                          ResultModel res =
                              await _secureEnclavePlugin.generateKeyPair(
                            accessControl: AccessControlModel(
                              password:
                                  'jakarta123', // Fill this password if you want custom pop up dialog of .applicationPassword.

                              options: [
                                AccessControlOption.applicationPassword,
                                AccessControlOption.privateKeyUsage,
                              ],
                              tag: 'kota',
                            ),
                          );

                          if (res.error != null) {
                            print(res.error!.desc.toString());
                          } else {
                            print(res.value);
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text('Show Dialog'),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () {
                // Add your action here
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
