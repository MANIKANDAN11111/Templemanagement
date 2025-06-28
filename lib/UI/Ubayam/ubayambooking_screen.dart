import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController(text: '0');
  final TextEditingController paidAmountController = TextEditingController(text: '0');
  final TextEditingController balanceAmountController = TextEditingController(text: '0');

  final List<Map<String, dynamic>> _persons = [];

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

  static const int _maxPersons = 5;

  List<String> getStarOptions(String? selectedRasi) {
    if (selectedRasi == null) return [];
    return rasiToStars[selectedRasi] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _addPerson();
    paidAmountController.addListener(_updateBalanceAmount);
    totalAmountController.addListener(_updateBalanceAmount);
  }

  @override
  void dispose() {
    paidAmountController.removeListener(_updateBalanceAmount);
    totalAmountController.removeListener(_updateBalanceAmount);
    emailController.dispose();
    totalAmountController.dispose();
    paidAmountController.dispose();
    balanceAmountController.dispose();

    for (var person in _persons) {
      (person['name'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _updateBalanceAmount() {
    final total = double.tryParse(totalAmountController.text) ?? 0;
    final paid = double.tryParse(paidAmountController.text) ?? 0;
    final balance = total - paid;
    balanceAmountController.text = balance.toStringAsFixed(2);
  }

  void _addPerson() {
    if (_persons.length < _maxPersons) {
      setState(() {
        _persons.add({
          'name': TextEditingController(),
          'rasi': null,
          'star': null,
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum of 5 persons reached.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _removePerson(int index) {
    setState(() {
      (_persons[index]['name'] as TextEditingController).dispose();
      _persons.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Booking submitted for ${DateFormat('MMMM d, y').format(widget.selectedDate)}',
            style: MyTextStyle.f14(Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to DashboardScreen after successful submission
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Ubayam',
              style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 18,),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      (route) => false,
                );
              },
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
    bool isMaxPersonsReached = _persons.length >= _maxPersons;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Ubayam Date'),
              Text(DateFormat('MMMM d, y').format(widget.selectedDate),
                  style: MyTextStyle.f16(appPrimaryColor)),
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

              _buildSectionTitle('Phone Number'),
              const SizedBox(height: 4),
              IntlPhoneField(
                decoration: _inputDecoration(hintText: 'Phone Number', icon: Icons.phone),
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
                  return null;
                },
                cursorColor: appPrimaryColor,
              ),
              const SizedBox(height: 16),

              _buildTextField('Email', emailController, 'Enter your email',
                  keyboardType: TextInputType.emailAddress, emailValidation: true),
              const SizedBox(height: 16),

              Text(
                'Person Details',
                style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ..._persons.asMap().entries.map((entry) {
                final index = entry.key;
                final person = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: appPrimaryColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Person ${index + 1}',
                              style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
                          if (_persons.length > 1)
                            TextButton.icon(
                              onPressed: () => _removePerson(index),
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              label: Text('Remove', style: MyTextStyle.f14(Colors.red)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: person['name'] as TextEditingController,
                        decoration: _inputDecoration(labelText: 'Name', hintText: 'Enter name'),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter person\'s name' : null,
                        cursorColor: appPrimaryColor,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: person['rasi'] as String?,
                        decoration: _inputDecoration(labelText: 'Select Rasi', hintText: 'Rasi'),
                        validator: (value) => value == null ? 'Please select Rasi' : null,
                        items: rasiOptions.map((rasi) => DropdownMenuItem(value: rasi, child: Text(rasi))).toList(),
                        onChanged: (value) {
                          setState(() {
                            person['rasi'] = value;
                            person['star'] = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: person['star'] as String?,
                        decoration: _inputDecoration(labelText: 'Select Star', hintText: 'Star'),
                        validator: (value) => value == null ? 'Please select Star' : null,
                        items: getStarOptions(person['rasi'] as String?)
                            .map((star) => DropdownMenuItem(value: star, child: Text(star))).toList(),
                        onChanged: (person['rasi'] == null)
                            ? null
                            : (value) {
                          setState(() {
                            person['star'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              if (!isMaxPersonsReached)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _addPerson,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Another Person'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      foregroundColor: Colors.white,
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
    style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
  );

  Widget _buildDropdown(String label, String? value, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: _inputDecoration(hintText: 'Select $label'),
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
          decoration: _inputDecoration(hintText: label),
          validator: (value) {
            if (!readOnly && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            if (!readOnly && double.tryParse(value!) == null) {
              return 'Enter valid number';
            }
            return null;
          },
          cursorColor: appPrimaryColor,
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
          decoration: _inputDecoration(hintText: hint),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter $label';
            if (emailValidation && !value.contains('@')) return 'Please enter valid email';
            return null;
          },
          cursorColor: appPrimaryColor,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? labelText, String? hintText, IconData? icon}) => InputDecoration(
    labelText: labelText,
    labelStyle: labelText != null ? TextStyle(color: appPrimaryColor) : null,
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
    hintText: hintText,
    prefixIcon: icon != null ? Icon(icon, color: appPrimaryColor) : null,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  );
}