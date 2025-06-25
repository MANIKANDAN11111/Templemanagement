import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';

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
  final TextEditingController phoneController = TextEditingController();

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
            'Hall Booking submitted for ${DateFormat('MMMM d, yyyy').format(widget.selectedDate)}',
            style: MyTextStyle.f14(Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
        title: Text('Hall Booking', style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold)),
        backgroundColor: appPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: whiteColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking Date: ${DateFormat('MMMM d, yyyy').format(widget.selectedDate)}',
              style: MyTextStyle.f16(blackColor,weight: FontWeight.bold),),
              const SizedBox(height: 12),
              _buildTextField('Name', nameController),
              _buildTextField('Phone', phoneController, keyboard: TextInputType.phone),
              _buildTextField('Total Amount', totalAmountController, keyboard: TextInputType.number),
              _buildTextField('Paid Amount', paidAmountController, keyboard: TextInputType.number),
              _buildTextField('Balance Amount', balanceAmountController, keyboard: TextInputType.number, readOnly: true),
              const SizedBox(height: 16),
              _buildDropdown('Slot', selectedSlot, ['Evening', 'Night'], (val) => setState(() => selectedSlot = val)),
              _buildDropdown('Package', selectedPackage, ['Basic', 'Standard', 'Premium'], (val) {
                setState(() {
                  selectedPackage = val;
                  totalAmountController.text = val == 'Basic' ? '100' : val == 'Standard' ? '200' : '300';
                  _updateBalanceAmount();
                });
              }),
              _buildDropdown('Free Addons', selectedFreeAddon, ['Decoration', 'Chairs'], (val) => setState(() => selectedFreeAddon = val)),
              _buildDropdown('Paid Addons', selectedPaidAddon, ['Music', 'AC'], (val) => setState(() => selectedPaidAddon = val)),


              const SizedBox(height: 16),
              _buildTextField('Bride Name', brideNameController),
              _buildFileUpload('Bride Document', brideDocument, () => pickFile(true)),
              _buildTextField('Groom Name', groomNameController),
              _buildFileUpload('Groom Document', groomDocument, () => pickFile(false)),

              const SizedBox(height: 16),
              ...rasiStarFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Column(
                  children: [
                    _buildDropdown('Rasi', field['rasi'], rasiOptions, (val) {
                      setState(() {
                        field['rasi'] = val;
                        field['star'] = null;
                      });
                    }),
                    _buildDropdown('Star', field['star'], getStarOptions(field['rasi']), (val) {
                      setState(() => field['star'] = val);
                    }),
                    if (rasiStarFields.length > 1)
                      TextButton.icon(
                        icon: Icon(Icons.remove, color: Colors.red),
                        label: Text('Remove', style: MyTextStyle.f14(Colors.red)),
                        onPressed: () => _removeRasiStarField(index),
                      ),
                  ],
                );
              }),
              if (rasiStarFields.length < 2)
                ElevatedButton.icon(
                  onPressed: _addRasiStarField,
                  icon: Icon(Icons.add),
                  label: Text('Add Rasi/Star'),
                  style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor, foregroundColor: whiteColor),
                ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: appPrimaryColor),
                        padding: EdgeInsets.symmetric(vertical: 14),
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
                        padding: EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: value,
        items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Select $label' : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildFileUpload(String label, File? file, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(file != null ? file.path.split('/').last : 'No file chosen')),
          ElevatedButton(
            onPressed: onTap,
            child: Text('Choose File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: appPrimaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
