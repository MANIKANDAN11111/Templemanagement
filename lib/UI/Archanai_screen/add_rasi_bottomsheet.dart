import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';

class AddRasiDialog extends StatefulWidget {
  const AddRasiDialog({super.key});

  @override
  State<AddRasiDialog> createState() => _AddRasiDialogState();
}

class _AddRasiDialogState extends State<AddRasiDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  final Map<String, List<String>> rasiToNatchathra = {
    'Mesham': ['Ashwini', 'Bharani', 'Krittika'],
    'Rishabam': ['Krittika', 'Rohini', 'Mrigashira'],
    'Mithunam': ['Mrigashira', 'Ardra', 'Punarvasu'],
    'Kadagam': ['Punarvasu', 'Pushya', 'Ashlesha'],
    'Simmem': ['Magha', 'Purva Phalguni', 'Uttara Phalguni'],
    'Kanni': ['Uttara Phalguni', 'Hasta', 'Chitra'],
    'Thulam': ['Chitra', 'Swati', 'Vishakha'],
    'Viruchigam': ['Vishakha', 'Anuradha', 'Jyeshtha'],
    'Thanusu': ['Mula', 'Purva Ashadha', 'Uttara Ashadha'],
    'Makaram': ['Uttara Ashadha', 'Shravana', 'Dhanishta'],
    'Kumbam': ['Dhanishta', 'Shatabhisha', 'Purva Bhadrapada'],
    'Meenam': ['Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'],
  };

  String? selectedRasi;
  String? selectedNatchathra;

  @override
  Widget build(BuildContext context) {
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
                /// Top Row
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

                /// Rasi Dropdown
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

                /// Natchathra Dropdown
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

                /// Submit & Add Buttons
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
                            Navigator.pop(context);
                            print('Submitted: ${nameController.text}, $selectedRasi, $selectedNatchathra');
                            // You can pass this data back or handle it as needed.
                          }
                        },
                        child: Text("Submit", style: MyTextStyle.f16(whiteColor)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            print('Added: ${nameController.text}, $selectedRasi, $selectedNatchathra');
                          }
                        },
                        child: Text("Add", style: MyTextStyle.f16(whiteColor)),
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
