import 'package:owomi/common_libs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
        // color: Colors.blue,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 40.0, bottom: 30.0, left: 10.0, right: 10.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.blue],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
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
                  const ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Pin'),
                    trailing: Icon(Icons.chevron_right_rounded),
                  ),
                  const ListTile(
                    leading: Icon(Icons.file_upload_rounded),
                    title: Text('Check for Updates'),
                    trailing: Icon(Icons.chevron_right_rounded),
                  ),
                  const ListTile(
                    leading: Icon(Icons.wallet),
                    title: Text('Withdraw Funds'),
                    trailing: Icon(Icons.chevron_right_rounded),
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
