import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class UbayamBookingScreen extends StatelessWidget {
  final DateTime selectedDate;
  const UbayamBookingScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: UbayamBookingScreenView(selectedDate: selectedDate),
    );
  }
}

class UbayamBookingScreenView extends StatefulWidget {
  final DateTime selectedDate;
  const UbayamBookingScreenView({super.key, required this.selectedDate});

  @override
  State<UbayamBookingScreenView> createState() => _UbayamBookingScreenViewState();
}

class _UbayamBookingScreenViewState extends State<UbayamBookingScreenView> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDelvam;
  String? selectedSlot;
  String? selectedPackage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController(text: '0');
  final TextEditingController paidAmountController = TextEditingController(text: '0');
  final TextEditingController balanceAmountController = TextEditingController(text: '0');

  List<Map<String, String?>> rasiStarFields = [];

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

  List<String> getStarOptions(String? selectedRasi) {
    if (selectedRasi == null) return [];
    return rasiToStars[selectedRasi] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _addRasiStarField();
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

  void _addRasiStarField() {
    if (rasiStarFields.length < 5) {
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking submitted for ${DateFormat('MMMM d, yyyy').format(widget.selectedDate)}',
            style: MyTextStyle.f14(Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Ubayam Booking',
              style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              color: whiteColor,
            ),
            centerTitle: true,
            backgroundColor: appPrimaryColor,
          ),
          body: mainContainer(),
        );
      },
    );
  }

  Widget mainContainer() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Ubayam Date'),
              Text(DateFormat('MMMM d, yyyy').format(widget.selectedDate),
                  style: MyTextStyle.f16(greyColor800)),
              const SizedBox(height: 16),
              _buildDropdown('Deivam', selectedDelvam, ['Deivam 1', 'Deivam 2', 'Deivam 3'], (value) {
                setState(() => selectedDelvam = value);
              }),
              const SizedBox(height: 16),
              _buildDropdown('Slot', selectedSlot, ['Morning', 'Afternoon', 'Evening'], (value) {
                setState(() => selectedSlot = value);
              }),
              const SizedBox(height: 16),
              _buildDropdown('Package', selectedPackage, ['Basic', 'Standard', 'Premium'], (value) {
                setState(() {
                  selectedPackage = value;
                  totalAmountController.text = value == 'Basic'
                      ? '100'
                      : value == 'Standard'
                      ? '200'
                      : '300';
                  _updateBalanceAmount();
                });
              }),
              const SizedBox(height: 16),
              _buildAmountField('Total Amount', totalAmountController),
              const SizedBox(height: 16),
              _buildAmountField('Paid Amount', paidAmountController),
              const SizedBox(height: 16),
              _buildAmountField('Balance Amount', balanceAmountController, readOnly: true),
              const SizedBox(height: 16),
              _buildTextField('Name', nameController, 'Enter your name'),
              const SizedBox(height: 16),
              _buildTextField('Phone', phoneController, 'Enter your phone number',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Email', emailController, 'Enter your email',
                  keyboardType: TextInputType.emailAddress, emailValidation: true),
              const SizedBox(height: 16),
              Text('Rasi and Star', style: MyTextStyle.f16(Colors.grey[800]!, weight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...rasiStarFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: field['rasi'],
                      decoration: _inputDecoration('Select Rasi'),
                      validator: (value) => value == null ? 'Please select Rasi' : null,
                      items: rasiOptions.map((rasi) => DropdownMenuItem(value: rasi, child: Text(rasi))).toList(),
                      onChanged: (value) {
                        setState(() {
                          rasiStarFields[index]['rasi'] = value;
                          rasiStarFields[index]['star'] = null;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: field['star'],
                      decoration: _inputDecoration('Select Star'),
                      validator: (value) => value == null ? 'Please select Star' : null,
                      items: getStarOptions(field['rasi'])
                          .map((star) => DropdownMenuItem(value: star, child: Text(star)))
                          .toList(),
                      onChanged: field['rasi'] == null
                          ? null
                          : (value) {
                        setState(() {
                          rasiStarFields[index]['star'] = value;
                        });
                      },
                    ),
                    if (rasiStarFields.length > 1)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _removeRasiStarField(index),
                          icon: const Icon(Icons.remove, color: Colors.red),
                          label: Text('Remove', style: MyTextStyle.f14(Colors.red)),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
              if (rasiStarFields.length < 5)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _addRasiStarField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Rasi/Star'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: Colors.white,
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: appPrimaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancel', style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Submit Booking',
                          style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold)),
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
    style: MyTextStyle.f16(greyColor800, weight: FontWeight.bold),
  );

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: _inputDecoration('Select $label'),
          validator: (val) => val == null ? 'Please select $label' : null,
          items: options.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildAmountField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          readOnly: readOnly,
          decoration: _inputDecoration(''),
          validator: (value) {
            if (!readOnly && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            if (!readOnly && double.tryParse(value!) == null) {
              return 'Enter valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text, bool emailValidation = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter $label';
            if (emailValidation && !value.contains('@')) return 'Please enter valid email';
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    hintText: hint,
  );
}
