import 'package:owomi/common_libs.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  var savingsCardInfo = [
    {
      "Name": "Regular Savings",
      'Description': 'Reach a specific goal with your circle.',
      'key': "1",
      "Color": Colors.greenAccent[600],
    },
    {
      "Name": "Target Savings",
      'Description': 'Reach a specific goal with your circle.',
      'key': "2",
      "Color": Colors.redAccent[600],
    },
    {
      "Name": "Strict Savings",
      'Description': 'Reach a specific goal with your circle.',
      'key': "3",
      "Color": Colors.orangeAccent[600],
    },
    {
      "Name": "Savings Circle",
      'Description': 'Reach a specific goal with your circle.',
      'key': "4",
      "Color": Colors.blueAccent[600],
    }
  ];

  Color selectColor(key) {
    if (key == "1") {
      return const Color(0xFF69F0AE);
    } else if (key == "2") {
      return const Color(0xFFFF5252);
    } else if (key == "3") {
      return const Color(0xFFFFAB40);
    } else {
      return const Color(0xFF448AFF);
    }
  }

  Widget balance() {
    return Center(
      child: Container(
        width: 350,
        height: 85,
        constraints: const BoxConstraints(maxHeight: 150.0),
        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 7, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: Text('Total Savings'),
                  ),
                  Text('15,000 sui', style: AppTheme.boldHeading1Text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget savingsCard(String title, String description, String key) {
    return InkWell(
      onTap: () {
        context.push("/savingsForm?savingsType=$key&savingsName=$title");
      },
      child: Center(
        child: Container(
          width: 170,
          height: 130,
          // constraints: const BoxConstraints(maxHeight: 40.0),
          // margin: const EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: selectColor(key),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTheme.boldHeading3Text,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Savings',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        children: [
          balance(),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Save your Tokens',
            style: AppTheme.boldHeading3Text,
          ),
          const SizedBox(
            height: 30,
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            children: savingsCardInfo
                .map(
                  (saving) => savingsCard(
                    saving['Name'] as String,
                    saving['Description'] as String,
                    saving['key'] as String,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
