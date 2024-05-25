import 'package:backdrop/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/zklogin.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsScreen> {
  int _currentIndex = 0;
  bool backdropShowing = true;

  String enteredPin = '';
  String enteredConfirmedPin = '';
  bool enteredPinFull = false;
  bool isPinVisible = false;

  bool biometrics = true;
  Widget biometricsSwitch() => Transform.scale(
        scale: 1.1,
        child: SwitchListTile.adaptive(
          title: const Text('Unlock with Biometrics'),
          value: biometrics,
          onChanged: (value) => setState(() {
            biometrics = value;
          }),
        ),
      );

  String dynamicHeaderText() {
    if (backdropShowing) {
      return "Settings";
    } else if (_currentIndex == 0) {
      return "Change Pin";
    } else if (_currentIndex == 1) {
      return "Check for Updates";
    } else if (_currentIndex == 2) {
      return "Withdraw Funds";
    } else {
      return '';
    }
  }

  Widget checkForUpdates() {
    return Container(
      color: Colors.blue,
    );
  }

  Widget withdrawFunds() {
    return Container(
      color: Colors.redAccent,
    );
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPinFull) {
              if (enteredConfirmedPin.length < 4) {
                enteredConfirmedPin += number.toString();
              }
            } else {
              if (enteredPin.length < 4) {
                enteredPin += number.toString();
              }
            }
            if (!enteredPinFull && enteredPin.length == 4) {
              enteredPinFull = true;
            }
            if (enteredPin.length == 4 && enteredConfirmedPin.length == 4) {
              pinValidator();
            }
            print(enteredPin);
            print(enteredPinFull);
            print(enteredConfirmedPin);
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void pinValidator() {
    if (enteredPin == enteredConfirmedPin) {
      savePin();
    } else {
      Zklogin().showSnackBar(context, "Pin doesn't match");
      setState(() {
        enteredPin = '';
        enteredConfirmedPin = '';
        enteredPinFull = false;
      });
    }
  }

  savePin() {
    ZkLoginStorageManager.setUserPin(enteredPin);
    Zklogin().showSnackBar(context, 'Pin Saved');
  }

  Color showPinColor(index) {
    if (enteredPinFull) {
      if (index < enteredConfirmedPin.length) {
        if (isPinVisible) {
          return Colors.green;
        } else {
          return CupertinoColors.activeBlue;
        }
      } else {
        return CupertinoColors.activeBlue.withOpacity(0.1);
      }
    } else {
      if (index < enteredPin.length) {
        if (isPinVisible) {
          return Colors.green;
        } else {
          return CupertinoColors.activeBlue;
        }
      } else {
        return CupertinoColors.activeBlue.withOpacity(0.1);
      }
    }
  }

  Widget inputPinView() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          Text(
            enteredPinFull ? 'Confirm Your Pin' : 'Enter Your Pin',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          /// Pin Code Area
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                width: isPinVisible ? 50 : 16,
                height: isPinVisible ? 50 : 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: showPinColor(index),
                ),
                child: enteredPinFull
                    ? isPinVisible && index < enteredConfirmedPin.length
                        ? Center(
                            child: Text(
                              enteredPinFull
                                  ? enteredConfirmedPin[index]
                                  : enteredPin[index],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.systemBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : null
                    : isPinVisible && index < enteredPin.length
                        ? Center(
                            child: Text(
                              enteredPinFull
                                  ? enteredConfirmedPin[index]
                                  : enteredPin[index],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: CupertinoColors.systemBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : null,
              );
            }),
          ),

          /// Visibility toggle button
          IconButton(
            onPressed: () {
              setState(() {
                isPinVisible = !isPinVisible;
              });
            },
            icon: Icon(isPinVisible ? Icons.visibility_off : Icons.visibility),
          ),

          SizedBox(
            height: isPinVisible ? 50.0 : 8.0,
          ),

          /// Digits
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => numButton(1 + 3 * i + index),
                ).toList(),
              ),
            ),

          /// 0 digit with backspace
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextButton(
                  onPressed: null,
                  child: SizedBox(),
                ),
                numButton(0),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (enteredPinFull) {
                        if (enteredConfirmedPin.isNotEmpty) {
                          enteredConfirmedPin = enteredConfirmedPin.substring(
                              0, enteredConfirmedPin.length - 1);
                        }
                      } else {
                        if (enteredPin.isNotEmpty) {
                          enteredPin =
                              enteredPin.substring(0, enteredPin.length - 1);
                        }
                      }
                    });
                  },
                  child: const Icon(
                    Icons.backspace,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          ///Reset Button
          TextButton(
            onPressed: () {
              setState(() {
                enteredPin = '';
                enteredConfirmedPin = '';
                enteredPinFull = false;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget changePin() {
    return Container(
      color: Colors.green,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Text(
              enteredPinFull ? 'Confirm Your Pin' : 'Enter Your Pin',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            /// Pin Code Area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  width: isPinVisible ? 50 : 16,
                  height: isPinVisible ? 50 : 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: showPinColor(index),
                  ),
                  child: enteredPinFull
                      ? isPinVisible && index < enteredConfirmedPin.length
                          ? Center(
                              child: Text(
                                enteredPinFull
                                    ? enteredConfirmedPin[index]
                                    : enteredPin[index],
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: CupertinoColors.systemBlue,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : null
                      : isPinVisible && index < enteredPin.length
                          ? Center(
                              child: Text(
                                enteredPinFull
                                    ? enteredConfirmedPin[index]
                                    : enteredPin[index],
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: CupertinoColors.systemBlue,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : null,
                );
              }),
            ),

            /// Visibility toggle button
            IconButton(
              onPressed: () {
                setState(() {
                  isPinVisible = !isPinVisible;
                });
              },
              icon:
                  Icon(isPinVisible ? Icons.visibility_off : Icons.visibility),
            ),

            SizedBox(
              height: isPinVisible ? 50.0 : 8.0,
            ),

            /// Digits
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),

            /// 0 digit with backspace
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (enteredPinFull) {
                          if (enteredConfirmedPin.isNotEmpty) {
                            enteredConfirmedPin = enteredConfirmedPin.substring(
                                0, enteredConfirmedPin.length - 1);
                          }
                        } else {
                          if (enteredPin.isNotEmpty) {
                            enteredPin =
                                enteredPin.substring(0, enteredPin.length - 1);
                          }
                        }
                      });
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            ///Reset Button
            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                  enteredConfirmedPin = '';
                  enteredPinFull = false;
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // final List<Widget> _pages = [changePin(), checkForUpdates(), withdrawFunds()];

  Widget _pages() {
    if (_currentIndex == 0) {
      return changePin();
    } else if (_currentIndex == 1) {
      return checkForUpdates();
    } else {
      return withdrawFunds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(dynamicHeaderText()),
        actions: const <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      revealBackLayerAtStart: true,
      onBackLayerConcealed: () {
        setState(() {
          backdropShowing = false;
        });
      },
      onBackLayerRevealed: () {
        setState(() {
          backdropShowing = true;
        });
      },
      subHeaderAlwaysActive: false,
      // frontLayerScrim: Colors.transparent,

      frontLayer: _pages(),
      backLayer: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 100.0, 10.0, 20.0),
        // color: Colors.blue,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 40.0, bottom: 30.0, left: 10.0, right: 10.0),
              // decoration: const BoxDecoration(
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(8.0),
              //   ),
              //   gradient: LinearGradient(
              //       colors: [Colors.transparent, Colors.blue],
              //       begin: FractionalOffset(0.0, 0.0),
              //       end: FractionalOffset(1.0, 0.0),
              //       stops: [0.0, 1.0],
              //       tileMode: TileMode.clamp),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.fromSize(
                    size: const Size(70, 70),
                    child: ClipOval(
                      child: Material(
                        color: Colors.grey,
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('jobaadewumis@gmail.com'),
                      ElevatedButton(
                        style: const ButtonStyle(
                          // iconSize: MaterialStatePropertyAll(13.0),
                          // fixedSize: MaterialStatePropertyAll(
                          //   Size.fromWidth(200.0),
                          // ),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                        ),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Text('0xsdsdsdsdsdssd'),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Icon(
                                Icons.copy,
                                size: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  biometricsSwitch(),
                  BackdropNavigationBackLayer(
                    items: const [
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Pin'),
                        trailing: Icon(Icons.chevron_right_rounded),
                      ),
                      ListTile(
                        leading: Icon(Icons.file_upload_rounded),
                        title: Text('Check for Updates'),
                        trailing: Icon(Icons.chevron_right_rounded),
                      ),
                      ListTile(
                        leading: Icon(Icons.wallet),
                        title: Text('Withdraw Funds'),
                        trailing: Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                    onTap: (int position) => {
                      setState(() => _currentIndex = position),
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
