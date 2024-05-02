import 'package:owomi/common_libs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _progressValue = 0.5;

  Widget customAppBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/avatars/animoji.png'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Image.asset('assets/images/avatars/animoji.png'),
          ),
          const Icon(Icons.list_alt_rounded)
        ],
      ),
    );
  }

  Widget balances() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10.0, right: 30.0),
        children: [
          Center(
            child: Container(
              width: 350,
              height: 110,
              constraints: const BoxConstraints(maxHeight: 150.0),
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 7, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints:
                              BoxConstraints.tight(const Size(100, 30)),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.plus_one),
                              Text('Quick Save'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Savings'),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(Icons.remove_red_eye),
                                iconSize: 17,
                              )
                            ],
                          ),
                        ),
                        const Text(
                          '15,000 sol',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 150,
              constraints: const BoxConstraints(maxHeight: 150.0),
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.plus_one),
                        Text('Quick Save'),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text('Total Savings'),
                    Text('15,000 sol'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customAppBar(),
            Expanded(
              child: ListView(
                children: [
                  balances(),
                  SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Send Button
                        Column(
                          children: [
                            SizedBox.fromSize(
                              size: const Size(40, 40),
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
                            const SizedBox(
                              height: 7,
                            ),
                            const Text('Save')
                          ],
                        ),
                        // Quick save button
                        Column(
                          children: [
                            SizedBox.fromSize(
                              size: const Size(40, 40),
                              child: ClipOval(
                                child: Material(
                                  color: Colors.grey,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            const Text('Withdraw')
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox.fromSize(
                              size: const Size(40, 40),
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
                            const SizedBox(
                              height: 7,
                            ),
                            const Text('Receive')
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox.fromSize(
                              size: const Size(40, 40),
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
                            const SizedBox(
                              height: 7,
                            ),
                            const Text('Invest')
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // Container(
    //   child: Center(
    //     child: TextButton(
    //       child: const Text('Yoo'),
    //       onPressed: () => context.go('/'),
    //     ),
    //   ),
    // );
  }
}
