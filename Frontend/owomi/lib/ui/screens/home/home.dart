import 'package:owomi/common_libs.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/app_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _progressValue = 0.5;
  int topSelectedIndex = 0;
  String truncatedAddress =
      AppLogic().truncateString(StorageManager.getAddress()) ?? "";

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  pageChanged(index) {
    setState(() {
      topSelectedIndex = index;
    });
  }

  // Widget customAppBar() {
  //   return Container(
  //     margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //           height: 50,
  //           margin: const EdgeInsets.only(right: 10),
  //           decoration: BoxDecoration(
  //             image: const DecorationImage(
  //               image: AssetImage('assets/images/avatars/animoji.png'),
  //               fit: BoxFit.fill,
  //             ),
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           child: Image.asset('assets/images/avatars/animoji.png'),
  //         ),
  //         const Icon(Icons.list_alt_rounded)
  //       ],
  //     ),
  //   );
  // }

  Widget balances() {
    return SizedBox(
      height: 150,
      child: Center(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 7, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('15,000 sui', style: AppTheme.boldHeading1Text),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 7, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints.tight(
                        const Size(130, 30),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                Icons.add,
                                size: 18,
                              ),
                            ),
                            Text(
                              'Quick Save',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickButtons() {
    return SizedBox(
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
              const Text(
                'Save',
                style: TextStyle(color: Colors.grey),
              ),
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
              const Text(
                'Withdraw',
                style: TextStyle(color: Colors.grey),
              )
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
              const Text(
                'Receive',
                style: TextStyle(color: Colors.grey),
              )
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
              const Text(
                'Invest',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomHalf() {
    return Expanded(
      // constraints:
      //     const BoxConstraints(maxHeight: 380, maxWidth: double.infinity),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        pageController.jumpToPage(0);
                      },
                      child: Text('Transactions',
                          style: topSelectedIndex == 0
                              ? AppTheme.boldHeading3Text
                              : AppTheme.heading3Text),
                    ),
                    TextButton(
                      onPressed: () {
                        pageController.jumpToPage(1);
                      },
                      child: Text('Tokens',
                          style: topSelectedIndex == 1
                              ? AppTheme.boldHeading3Text
                              : AppTheme.heading3Text),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: topSelectedIndex == 0
                      ? const Icon(Icons.chevron_right_rounded)
                      : const Icon(Icons.settings),
                ),
              ],
            ),
            Expanded(
              child: buildBottomPageView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactions() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      color: Colors.blue,
      child: const Text('omo'),
    );
  }

  Widget tokens() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      color: Colors.red,
      child: const Text('omo'),
    );
  }

  Widget buildBottomPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: [transactions(), tokens()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(truncatedAddress != ""
            ? 'Hello, $truncatedAddress'
            : 'Hello, there'),
      ),
      body: Column(
        children: [
          balances(),
          quickButtons(),
          bottomHalf(),
        ],
      ),
    );
  }
}
