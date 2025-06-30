import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';

const Color greyColor800 = Colors.grey;
const Color greyColor = Colors.grey;

class HallBookingScreen extends StatelessWidget {
  final DateTime selectedDate;
  const HallBookingScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: HallBookingScreenView(selectedDate: selectedDate),
    );
  }
}

class HallBookingScreenView extends StatefulWidget {
  final DateTime selectedDate;
  const HallBookingScreenView({super.key, required this.selectedDate});

  @override
  State<HallBookingScreenView> createState() => _HallBookingScreenViewState();
}

class _HallBookingScreenViewState extends State<HallBookingScreenView> {
  final _formKey = GlobalKey<FormState>();
  String? selectedSlot;
  String? selectedPackage;
  String? selectedFreeAddon;
  String? selectedPaidAddon;

  final TextEditingController totalAmountController = TextEditingController(text: '0');
  final TextEditingController paidAmountController = TextEditingController(text: '0');
  final TextEditingController balanceAmountController = TextEditingController(text: '0');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brideNameController = TextEditingController();
  final TextEditingController groomNameController = TextEditingController();

  File? brideDocument;
  File? groomDocument;

  List<Map<String, String?>> rasiStarFields = [{'rasi': null, 'star': null}];

  final List<String> rasiOptions = [
    'Mesham', 'Risabam', 'Mithunam', 'Kadagam', 'Simmem', 'Kanni',
    'Thulam', 'Viruchigam', 'Thanusu', 'Makaram', 'Kumbam', 'Meenam'
  ];
  final Map<String, List<String>> rasiToStars = {
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

  String _phoneNumber = '';
  String _countryCode = '+91';

  @override
  void initState() {
    super.initState();
    paidAmountController.addListener(_updateBalanceAmount);
    totalAmountController.addListener(_updateBalanceAmount);
  }

  @override
  void dispose() {
    paidAmountController.removeListener(_updateBalanceAmount);
    totalAmountController.removeListener(_updateBalanceAmount);
    nameController.dispose();
    totalAmountController.dispose();
    paidAmountController.dispose();
    balanceAmountController.dispose();
    brideNameController.dispose();
    groomNameController.dispose();
    super.dispose();
  }

  void _updateBalanceAmount() {
    final total = double.tryParse(totalAmountController.text) ?? 0;
    final paid = double.tryParse(paidAmountController.text) ?? 0;
    final balance = total - paid;
    balanceAmountController.text = balance.toStringAsFixed(2);
  }

  List<String> getStarOptions(String? rasi) => rasiToStars[rasi] ?? [];

  Future<void> pickFile(bool isBride) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isBride) {
          brideDocument = File(result.files.single.path!);
        } else {
          groomDocument = File(result.files.single.path!);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Hall Booking submitted for ${DateFormat('MMMM d, y').format(widget.selectedDate)}',
            style: MyTextStyle.f14(Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
      );
    }
  }

  void _addRasiStarField() {
    if (rasiStarFields.length < 2) {
      setState(() {
        rasiStarFields.add({'rasi': null, 'star': null});
      });
    }
  }

  void _removeRasiStarField(int index) {
    if (rasiStarFields.length > 1) {
      setState(() {
        rasiStarFields.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<DemoBloc, dynamic>(
        buildWhen: (previous, current) => false,
        builder: (context, state) => mainContainer(),
      ),
    );
  }

  Widget mainContainer() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hall Booking',
          style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold),
        ),
        backgroundColor: appPrimaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Booking Date'),
              Text(DateFormat('MMMM d, y').format(widget.selectedDate),
                  style: MyTextStyle.f16(appPrimaryColor)),
              const SizedBox(height: 16),

              _buildTextField('Name', nameController, hintText: 'Enter name'),
              const SizedBox(height: 8),

              _buildSectionTitle('Phone Number'),
              const SizedBox(height: 4),
              IntlPhoneField(
                decoration: _inputDecoration(hintText: 'Phone Number', prefixIcon: Icons.phone),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  setState(() {
                    _countryCode = phone.countryCode;
                    _phoneNumber = phone.number;
                  });
                },
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (phone.number.length < 7 || phone.number.length > 15) { // Common phone number length range
                    return 'Phone number must be 7-15 digits';
                  }
                  return null;
                },
                cursorColor: appPrimaryColor,
              ),
              const SizedBox(height: 8),

              _buildTextField('Total Amount', totalAmountController, keyboard: TextInputType.number, hintText: 'Enter total amount'),
              _buildTextField('Paid Amount', paidAmountController, keyboard: TextInputType.number, hintText: 'Enter paid amount'),
              _buildTextField('Balance Amount', balanceAmountController, keyboard: TextInputType.number, readOnly: true, hintText: 'Calculated balance'),
              const SizedBox(height: 16),

              _buildDropdown('Slot', selectedSlot, ['Evening', 'Night'], (val) => setState(() => selectedSlot = val), hintText: 'Select a slot'),
              _buildDropdown('Package', selectedPackage, ['Basic', 'Standard', 'Premium'], (val) {
                setState(() {
                  selectedPackage = val;
                  totalAmountController.text = val == 'Basic' ? '100' : val == 'Standard' ? '200' : '300';
                  _updateBalanceAmount();
                });
              }, hintText: 'Select a package'),
              _buildDropdown('Free Addons', selectedFreeAddon, ['Decoration', 'Chairs'], (val) => setState(() => selectedFreeAddon = val), hintText: 'Select free addons'),
              _buildDropdown('Paid Addons', selectedPaidAddon, ['Music', 'AC'], (val) => setState(() => selectedPaidAddon = val), hintText: 'Select paid addons'),

              const SizedBox(height: 16),
              _buildSectionTitle('Couple Details'),
              _buildTextField('Bride Name', brideNameController, hintText: 'Enter bride\'s name'),
              _buildFileUpload('Bride Document', brideDocument, (val) => brideDocument = val, () => pickFile(true)),
              _buildTextField('Groom Name', groomNameController, hintText: 'Enter groom\'s name'),
              _buildFileUpload('Groom Document', groomDocument, (val) => groomDocument = val, () => pickFile(false)),

              const SizedBox(height: 16),
              _buildSectionTitle('Rasi & Star Details'),
              ...rasiStarFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: appPrimaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rasiStarFields.length == 1 ? 'Rasi/Star' : (index == 0 ? 'Bride\'s Rasi/Star' : 'Groom\'s Rasi/Star'),
                          style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown('Rasi', field['rasi'], rasiOptions, (val) {
                        setState(() {
                          field['rasi'] = val;
                          field['star'] = null;
                        });
                      }, hintText: 'Select Rasi'),
                      _buildDropdown('Star', field['star'], getStarOptions(field['rasi']), (val) {
                        setState(() => field['star'] = val);
                      }, hintText: 'Select Star'),
                      if (rasiStarFields.length > 1)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            label: Text('Remove', style: MyTextStyle.f14(Colors.red)),
                            onPressed: () => _removeRasiStarField(index),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              if (rasiStarFields.length < 2)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _addRasiStarField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Rasi/Star for Second Person'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: appPrimaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel', style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Submit', style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
  );

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged, {String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: MyTextStyle.f14(appPrimaryColor)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            decoration: _inputDecoration(hintText: hintText ?? 'Select $label'),
            validator: (val) => val == null ? 'Please select $label' : null,
            items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: appPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, bool readOnly = false, String? hintText, IconData? prefixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: MyTextStyle.f14(appPrimaryColor)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            readOnly: readOnly,
            decoration: _inputDecoration(hintText: hintText, prefixIcon: prefixIcon),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter $label';
              }
              if (keyboard == TextInputType.number && double.tryParse(val) == null) {
                return 'Enter valid number';
              }
              return null;
            },
            cursorColor: appPrimaryColor,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? labelText, String? hintText, IconData? prefixIcon, Widget? suffixIcon}) => InputDecoration(
    labelText: labelText,
    labelStyle: labelText != null ? TextStyle(color: appPrimaryColor) : null,
    hintText: hintText,
    hintStyle: MyTextStyle.f14(greyColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: appPrimaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: appPrimaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: appPrimaryColor) : null,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  );

  Widget _buildFileUpload(String label, File? file, ValueChanged<File?> onFileSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: MyTextStyle.f14(appPrimaryColor)),
          const SizedBox(height: 4),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: file != null ? file.path.split('/').last : ''),
            decoration: _inputDecoration(
              hintText: 'No file chosen',
              suffixIcon: IconButton(
                icon: const Icon(Icons.attach_file, color: appPrimaryColor),
                onPressed: onTap,
              ),
            ),
            onTap: onTap,
            validator: (val) {
              if (file == null) {
                return 'Please upload $label';
              }
              return null;
            },
            cursorColor: appPrimaryColor,
          ),
        ],
      ),
    );
  }
}