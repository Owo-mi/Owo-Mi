import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/app_logic.dart';

class SavingsFormScreen extends ConsumerStatefulWidget {
  final String? savingType;
  final String? savingName;

  const SavingsFormScreen({super.key, this.savingType, this.savingName});

  @override
  ConsumerState<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends ConsumerState<SavingsFormScreen> {
  DateTime? selectedDate;
  String truncatedAddress =
      AppLogic().truncateString(StorageManager.getAddress()) ?? "";

  final formKey = GlobalKey<FormState>();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    print(picked);
    setState(() {
      selectedDate = picked;
    });
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Information",
                style: AppTheme.heading2Text,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Name",
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Name Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Description",
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Description Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Save Now",
                style: AppTheme.heading2Text,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Select Date",
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(
                  FocusNode(),
                );
                await _selectDate();
              },
            ),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              decoration: const InputDecoration(
                hintText: "Target Amount",
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Target amount Required";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chain Details",
                style: AppTheme.heading2Text,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: "Select Coin Type",
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onChanged: (vaue) {},
              items: [
                DropdownMenuItem(
                  value: CoinType.SUI,
                  child: const Text("SUI"),
                ),
                DropdownMenuItem(
                  value: CoinType.BUCK,
                  child: const Text("BUCK"),
                ),
                DropdownMenuItem(
                  value: CoinType.USDC,
                  child: const Text("USDC"),
                ),
                DropdownMenuItem(
                  value: CoinType.USDT,
                  child: const Text("USDT"),
                ),
              ],
            ),
            truncatedAddress != ""
                ? TextFormField(
                    decoration: InputDecoration(
                      enabled: false,
                      hintText: AppLogic()
                          .truncateString(StorageManager.getAddress()),
                      border: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value!.trim().isEmpty) {
                    //     return "Description Required";
                    //   }
                    //   return null;
                    // },
                  )
                : Container(),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  print("The form is valid");
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(truncatedAddress);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.savingName ?? ""),
      ),
      body: form(),
    );
  }
}
