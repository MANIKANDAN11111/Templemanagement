import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const DonationPageView(),
    );
  }
}

class DonationPageView extends StatefulWidget {
  const DonationPageView({super.key});

  @override
  State<DonationPageView> createState() => _DonationPageViewState();
}

class _DonationPageViewState extends State<DonationPageView> {
  final _formKey = GlobalKey<FormState>();

  String selectedDonation = 'General Donation';
  final List<Map<String, String>> donationTypes = [
    {
      'title': 'General Donation',
      'image': 'assets/image/donation.png',
    },
  ];

  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController donationForController = TextEditingController();

  bool showPayButton = false;
  int maxPhoneLength = 10;

  @override
  void initState() {
    super.initState();
  }

  void validateForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final phoneValid = phoneController.text.length == maxPhoneLength;
    setState(() {
      showPayButton = isFormValid && phoneValid;
    });
  }

  void showDonationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Select Donation",
                  style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: donationTypes.length,
                  itemBuilder: (context, index) {
                    final item = donationTypes[index];
                    return ListTile(
                      leading: Image.asset(item['image']!, width: 40, height: 40),
                      title: Text(item['title']!),
                      trailing: item['title'] == selectedDonation
                          ? const Icon(Icons.check_circle, color: greenColor)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedDonation = item['title']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: const TextStyle(color: appPrimaryColor),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: appPrimaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Donation', style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold)),
            backgroundColor: appPrimaryColor,
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
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: greyColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                onChanged: validateForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Donation", style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: showDonationPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: appPrimaryColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(selectedDonation),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: appPrimaryColor,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: inputDecoration("Amount to donate *"),
                      validator: (value) {
                        final val = double.tryParse(value ?? '');
                        if (val == null || val < 1) return "Minimum ₹1 required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "₹${amountController.text.isEmpty ? '0.00' : amountController.text}",
                        style: const TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("Devotee Details", style: TextStyle(color: appPrimaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: appPrimaryColor,
                      controller: nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      ],
                      decoration: inputDecoration("Full Name *"),
                      validator: (value) => value == null || value.isEmpty ? "Enter Name" : null,
                    ),
                    const SizedBox(height: 20),
                    IntlPhoneField(
                      cursorColor: appPrimaryColor,
                      controller: phoneController,
                      initialCountryCode: 'IN',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[,]')),
                      ],
                      decoration: inputDecoration('Phone Number *'),
                      onChanged: (phone) => validateForm(),
                      validator: (value) {
                        final number = value?.number ?? '';
                        if (value == null || number.length != maxPhoneLength) {
                          return 'Phone number must be $maxPhoneLength digits';
                        }
                        return null;
                      },
                      onCountryChanged: (country) {
                        setState(() {
                          if (country.code == "IN") {
                            maxPhoneLength = 10;
                          } else if (country.code == "US") {
                            maxPhoneLength = 10;
                          } else if (country.code == "MY") {
                            maxPhoneLength = 9;
                          } else {
                            maxPhoneLength = 12;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      cursorColor: appPrimaryColor,
                      controller: donationForController,
                      minLines: 5,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: inputDecoration("Donation for (Optional)"),
                    ),
                    const SizedBox(height: 30),
                    if (showPayButton)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Payment successful!"),backgroundColor: greenColor,),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                  (route) => false,
                            );
                          }
                        },
                        child: Text(
                          "Pay ₹${amountController.text}",
                          style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}