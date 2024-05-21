import 'package:backdrop/backdrop.dart';
import 'package:owomi/common_libs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  int _currentIndex = 0;
  bool backdropShowing = true;

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

  Widget changePin() {
    return Container(
      color: Colors.green,
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
