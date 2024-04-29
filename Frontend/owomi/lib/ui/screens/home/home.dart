import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0,
                      spreadRadius: -3.0,
                      offset: Offset(5, 7),
                    ),
                  ],
                ),
                child: Image.asset('assets/images/avatars/animoji.png'),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '095309039043',
                      ),
                      Icon(Icons.copy_outlined),
                    ],
                  ),
                  Text('#jjbbdjsb')
                ],
              ),
            ],
          ),
          const Icon(Icons.notifications_active)
        ],
      ),
    );
  }

  Widget balances() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10.0, right: 30.0),
        children: [
          Center(
            child: Container(
              width: 350,
              height: 150,
              constraints: const BoxConstraints(maxHeight: 150.0),
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    spreadRadius: 2.0,
                    offset: Offset(8, 12),
                  ),
                ],
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
          Center(
            child: Container(
              width: 350,
              height: 150,
              constraints: const BoxConstraints(maxHeight: 150.0),
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    spreadRadius: 2.0,
                    offset: Offset(8, 12),
                  ),
                ],
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Savings',
            icon: Icon(
              Icons.chat,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Portfolio',
            icon: Icon(
              Icons.bar_chart_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            customAppBar(),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Wallet Connected'),
                      ),
                    ],
                  ),
                  Container(
                    child: const Text('Your journey so far'),
                  ),
                  balances(),
                  Row(
                    children: [
                      const Text('Use Auto save mode'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Customize'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                      children: [
                        Center(
                          child: Container(
                            width: 100,
                            height: 45,
                            constraints: const BoxConstraints(maxHeight: 50.0),
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0,
                                  spreadRadius: -2.0,
                                  offset: Offset(5, 8),
                                ),
                              ],
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.plus_one),
                                  Column(
                                    children: [
                                      Text('30.60'),
                                      Text('sol'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Reach your goal!🔥'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Make more'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                      children: [
                        Center(
                          child: Container(
                            width: 150,
                            height: 100,
                            constraints: const BoxConstraints(maxHeight: 150.0),
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0,
                                  spreadRadius: -2.0,
                                  offset: Offset(5, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Goal:'),
                                      Text('30.60'),
                                      Icon(Icons.info),
                                    ],
                                  ),
                                  Text('$_progressValue'),
                                  SizedBox(
                                    height: 10.0,
                                    width: 40.0,
                                    child: LinearProgressIndicator(
                                      value: _progressValue,
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.blue),
                                    ),
                                  ),
                                  const Text('15 Sol')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Your partners in earning'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See circle'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                      children: [
                        Center(
                          child: Container(
                            width: 150,
                            height: 100,
                            constraints: const BoxConstraints(maxHeight: 150.0),
                            margin:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0,
                                  spreadRadius: -2.0,
                                  offset: Offset(5, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Goal:'),
                                      Text('30.60'),
                                      Icon(Icons.info),
                                    ],
                                  ),
                                  Text('$_progressValue'),
                                  SizedBox(
                                    height: 10.0,
                                    width: 40.0,
                                    child: LinearProgressIndicator(
                                      value: _progressValue,
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.blue),
                                    ),
                                  ),
                                  const Text('15 Sol')
                                ],
                              ),
                            ),
                          ),
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
