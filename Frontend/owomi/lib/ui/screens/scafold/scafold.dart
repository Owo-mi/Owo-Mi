import 'package:owomi/common_libs.dart';
import 'package:owomi/ui/screens/home/home.dart';
import 'package:owomi/ui/screens/settings/settings.dart';

class Scafold extends StatefulWidget {
  const Scafold({super.key});

  @override
  State<Scafold> createState() => _ScafoldState();
}

class _ScafoldState extends State<Scafold> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  pageChanged(index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      physics: const NeverScrollableScrollPhysics(),
      children: const [HomeScreen(), SettingsScreen()],
    );
  }

  List<BottomNavigationBarItem> buildButtomNavbarItems() {
    return [
      const BottomNavigationBarItem(
        label: 'Home',
        icon: Icon(
          Icons.home,
        ),
      ),
      const BottomNavigationBarItem(
        label: 'Savings',
        icon: Icon(
          Icons.chat,
        ),
      ),
      const BottomNavigationBarItem(
        label: 'Investment',
        icon: Icon(
          Icons.bar_chart_rounded,
        ),
      ),
      const BottomNavigationBarItem(
        label: 'Account',
        icon: Icon(
          Icons.portrait_rounded,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          pageController.jumpToPage(index);
        },
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.blueAccent,
        currentIndex: bottomSelectedIndex,
        items: buildButtomNavbarItems(),
      ),
      body: buildPageView(),
    );
  }
}
