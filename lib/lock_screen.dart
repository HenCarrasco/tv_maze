import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_maze/home.dart';

class LockScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final StreamController<bool> verificationNotifier =
      StreamController<bool>.broadcast();
  String storedPinCode, pinCode;

  @override
  void initState() {
    super.initState();
    getStoredPinCode();
  }

  @override
  void dispose() {
    verificationNotifier.close();
    super.dispose();
  }

  getStoredPinCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    storedPinCode = sharedPreferences.getString("pinCode");
  }

  void showSnackBarMessage(context, String message,
      {double heightFactor = 1.0,
      bool isWarning = false,
      bool isInfo = false,
      bool isError = false,
      bool isSuccess = false}) {
    Color primaryColor = Theme.of(context).primaryColor;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isInfo
          ? primaryColor
          : isWarning
              ? Colors.orangeAccent
              : isError
                  ? Colors.red
                  : isSuccess
                      ? Colors.green
                      : primaryColor,
      content: Center(heightFactor: heightFactor, child: Text(message)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Center(child: Text('TV Maze')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to TV Maze! \nWe're glad to see you back.",
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Icon(
              Icons.live_tv,
              size: 120,
              color: Colors.black.withOpacity(0.5),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Please, enter your pin number to enjoy our material.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            lockScreenButton(context),
          ],
        ),
      ),
    );
  }

  showEnterPinModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStates) {
            return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: Text(
                  'Enter your new pin number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: <Widget>[
                  Container(
                      child: Padding(
                          padding:
                              EdgeInsets.only(left: 23.0, right: 15.0, top: 20),
                          child: Column(children: <Widget>[
                            TextFormField(
                              key: Key('pin-input'),
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value.isNotEmpty &&
                                    (pinCode.length < 6 ||
                                        pinCode.length > 6)) {
                                  return 'Pin number must contains 6 characters.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                              ),
                              autofocus: true,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                pinCode = value;
                              },
                            ),
                            SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    key: Key('pin-save-btn'),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (pinCode == null) {
                                        showSnackBarMessage(
                                            context, 'Pin code is required.',
                                            isWarning: true);
                                      } else if (pinCode.length < 6 ||
                                          pinCode.length > 6) {
                                        showSnackBarMessage(context,
                                            'Pin number must contains 6 characters.',
                                            isError: true);
                                      } else if (pinCode != null &&
                                          pinCode.length == 6) {
                                        setState(() {
                                          storedPinCode = pinCode;
                                          prefs.setString(
                                              "pinCode", storedPinCode);
                                          pinCode = null;
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    child: Text('Save'),
                                  )
                                ])
                          ])))
                ]);
          });
        });
  }

  lockScreenButton(BuildContext context) => MaterialButton(
        key: Key('pin-btn'),
        padding: EdgeInsets.only(left: 50, right: 50),
        color: Theme.of(context).primaryColor,
        child: Text(
          'Pin Number',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        onPressed: () {
          storedPinCode == null
              ? showEnterPinModal(context)
              : showLockScreen(
                  context,
                  opaque: false,
                  cancelButton: Text(
                    'Cancel',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    semanticsLabel: 'Cancel',
                  ),
                );
        },
      );

  showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter Pin Number',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: (value) {
              passCodeEntered(value, context);
            },
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: passCodeCancelled,
            digits: digits,
            passwordDigits: 6,
            bottomWidget: passCodeRestoreButton(),
          ),
        ));
  }

  passCodeEntered(String enteredPasscode, context) {
    bool isValid = storedPinCode == enteredPasscode;
    verificationNotifier.add(isValid);
    if (isValid) {
      Navigator.of(context).pop();
      Navigator.of(this.context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home(title: 'TV Maze')));
    }
  }

  passCodeCancelled() {
    Navigator.of(context).pop();
  }

  passCodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: FlatButton(
            child: Text(
              "Reset pin number",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            splashColor: Colors.white.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.2),
            onPressed: resetApplicationPassword,
          ),
        ),
      );

  resetApplicationPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      restoreDialog(() {
        Navigator.of(context).pop();
      });
    });
  }

  restoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          title: Text(
            'Reset pin number',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to reset your pin number?",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Proceed",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showEnterPinModal(context);
              },
            ),
          ],
        );
      },
    );
  }
}
