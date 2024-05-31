import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/data/storage_manager.dart';
import 'package:owomi/logic/app_logic.dart';
import 'package:owomi/provider/app_provider.dart';
import 'package:owomi/provider/zk_login_provider.dart';

class SavingsFormScreen extends ConsumerStatefulWidget {
  final String? savingType;
  final String? savingName;
  final String? googleRedirect;

  const SavingsFormScreen(
      {super.key, this.savingType, this.savingName, this.googleRedirect});

  @override
  ConsumerState<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends ConsumerState<SavingsFormScreen> {
  String? name;
  String? description;
  String? targetAmount;
  String? coinType;
  String normalAddress = StorageManager.getAddress();

  DateTime? selectedDate;
  String truncatedAddress =
      AppLogic().truncateString(StorageManager.getAddress()) ?? "";

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.googleRedirect == 'true') {
      print(widget.googleRedirect);
      submitForm();
    }
  }

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

  submitForm() async {
    if (widget.googleRedirect == 'true') {
      print('From submit form');
      print(widget.googleRedirect);
      var targetObject = {
        "date": ref.read(selectedDateProvider)!.microsecondsSinceEpoch,
        "amount": ref.read(targetAmountProvider),
      };
      await AppLogic().warmUpForTransaction(ref, context);
      await AppLogic().signTransactions(
          ref.read(coinTypeProvider),
          ref.read(nameProvider),
          ref.read(descriptionProvider),
          ref.read(addressProvider),
          targetObject,
          ref);
    } else {
      Future(() {
        ref.read(zkloginProcessStatusProvider.notifier).state =
            'Buckle up for the ride';
      });
      print('From the beginning form');
      ref.read(nameProvider.notifier).state = name ?? '';
      ref.read(descriptionProvider.notifier).state = description ?? '';
      ref.read(targetAmountProvider.notifier).state = targetAmount ?? '';
      ref.read(coinTypeProvider.notifier).state = coinType ?? '';
      ref.read(selectedDateProvider.notifier).state = selectedDate;
      var targetObject = {
        "date": selectedDate!.microsecondsSinceEpoch,
        "amount": targetAmount,
      };
      await AppLogic().warmUpForTransaction(ref, context);
      await AppLogic().signTransactions(
          coinType, name, description, normalAddress, targetObject, ref);
    }
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Text(
              ref.watch(zkloginProcessStatusProvider),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
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
                "Target Details",
                style: AppTheme.heading2Text,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText:
                    selectedDate != null ? '$selectedDate' : "Select Date",
                border: const OutlineInputBorder(
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
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              decoration: const InputDecoration(
                hintText: "Target Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  targetAmount = value;
                });
              },
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
              hint: const Text("Select coin type"),
              decoration: const InputDecoration(
                // hintText: "Select Coin Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Coin Type Required";
                }
                return null;
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  coinType = value;
                });
              },
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
            const SizedBox(
              height: 10.0,
            ),
            truncatedAddress != ""
                ? TextFormField(
                    decoration: InputDecoration(
                      enabled: false,
                      hintText: truncatedAddress,
                      border: const OutlineInputBorder(
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await submitForm();
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
      body: widget.googleRedirect == 'true'
          ? Center(
              child: Column(
                children: [
                  Text(
                    ref.watch(zkloginProcessStatusProvider),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : form(),
    );
  }
}
