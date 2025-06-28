import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';

class RasiDetail {
  final String name;
  final String rasi;
  final String natchathra;

  RasiDetail({
    required this.name,
    required this.rasi,
    required this.natchathra,
  });
}

class AddRasiDialog extends StatelessWidget {
  const AddRasiDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const AddRasiDialogView(),
    );
  }
}

class AddRasiDialogView extends StatefulWidget {
  const AddRasiDialogView({super.key});

  @override
  State<AddRasiDialogView> createState() => _AddRasiDialogViewState();
}

class _AddRasiDialogViewState extends State<AddRasiDialogView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  final Map<String, List<String>> rasiToNatchathra = {
    'Mesham': ['Ashwini', 'Parani', 'Kiruthigal'],
    'Risabam': ['Kiruthigal', 'Rohini', 'Mrigashirsha'],
    'Mithunam': ['Mrigashirsha', 'Thiruvathirai', 'Punarpoosam'],
    'Kadagam': ['Punarpoosam', 'Poosam', 'Aayiliyam'],
    'Simmem': ['Magam', 'Pooram', 'Uthiram'],
    'Kanni': ['Uthiram', 'Hastam', 'Chitrirai'],
    'Thulam': ['Chithirai', 'Swati', 'Visagam'],
    'Viruchigam': ['Visagam', 'Anusham', 'Kettai'],
    'Thanusu': ['Moolam', 'Pooradam', 'Utharadam'],
    'Makaram': ['Utharadam', 'Thiruvonam', 'Avitam'],
    'Kumbam': ['Avitam', 'Sadhayam', 'Pooratadhi'],
    'Meenam': ['Pooratadhi', 'Uthiratadhi', 'Revati'],
  };

  String? selectedRasi;
  String? selectedNatchathra;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return mainContainer();
      },
    );
  }

  Widget mainContainer() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: appPrimaryColor),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Add Rasi',
                          style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// Full Name
                Text("Full Name *", style: MyTextStyle.f16(appPrimaryColor)),
                const SizedBox(height: 5),
                TextFormField(
                  controller: nameController,
                  cursorColor: appPrimaryColor,
                  decoration: const InputDecoration(
                    hintText: "Enter Name",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appPrimaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                Text("Rasi *", style: MyTextStyle.f16(appPrimaryColor)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Rasi",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appPrimaryColor),
                    ),
                  ),
                  value: selectedRasi,
                  items: rasiToNatchathra.keys
                      .map((rasi) => DropdownMenuItem(
                    value: rasi,
                    child: Text(rasi),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRasi = value;
                      selectedNatchathra = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Rasi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                Text("Natchathra *", style: MyTextStyle.f16(appPrimaryColor)),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select Natchathra",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appPrimaryColor),
                    ),
                  ),
                  value: selectedNatchathra,
                  items: (selectedRasi != null
                      ? rasiToNatchathra[selectedRasi]!
                      : <String>[])
                      .map((natch) => DropdownMenuItem(
                    value: natch,
                    child: Text(natch),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedNatchathra = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Natchathra';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                                context,
                                RasiDetail(
                                  name: nameController.text,
                                  rasi: selectedRasi!,
                                  natchathra: selectedNatchathra!,
                                ));
                          }
                        },
                        child: Text("Add", style: MyTextStyle.f16(whiteColor)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: appPrimaryColor),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel", style: MyTextStyle.f16(appPrimaryColor)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}