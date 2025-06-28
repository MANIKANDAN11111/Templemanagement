import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  final String initialFullName;
  final String initialUsername;
  final String initialUserEmail;
  final String initialUserPhone;
  final String initialAddress;

  const EditProfileScreen({
    Key? key,
    required this.initialFullName,
    required this.initialUsername,
    required this.initialUserEmail,
    required this.initialUserPhone,
    required this.initialAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: EditProfileScreenView(
        initialFullName: initialFullName,
        initialUsername: initialUsername,
        initialUserEmail: initialUserEmail,
        initialUserPhone: initialUserPhone,
        initialAddress: initialAddress,
      ),
    );
  }
}

class EditProfileScreenView extends StatefulWidget {
  final String initialFullName;
  final String initialUsername;
  final String initialUserEmail;
  final String initialUserPhone;
  final String initialAddress;
  const EditProfileScreenView({
    Key? key,
    required this.initialFullName,
    required this.initialUsername,
    required this.initialUserEmail,
    required this.initialUserPhone,
    required this.initialAddress,
  }) : super(key: key);

  @override
  State<EditProfileScreenView> createState() => _EditProfileScreenViewState();
}

class _EditProfileScreenViewState extends State<EditProfileScreenView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late String _currentPhoneNumber;
  late String _currentCountryCode;
  late TextEditingController _addressController;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.initialFullName);
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController = TextEditingController(text: widget.initialUserEmail);

    String phoneToParse = widget.initialUserPhone.trim();
    if (phoneToParse.startsWith('+')) {
      List<String> parts = phoneToParse.split(' ');
      if (parts.length > 1) {
        _currentCountryCode = parts[0];
        _currentPhoneNumber = parts.sublist(1).join(' ');
      } else {
        _currentCountryCode = '+91';
        _currentPhoneNumber = phoneToParse;
      }
    } else {
      _currentCountryCode = '+91';
      _currentPhoneNumber = phoneToParse;
    }
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Take a Photo', style: MyTextStyle.f16(blackColor)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: Text('Choose from Gallery', style: MyTextStyle.f16(blackColor)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text('Cancel', style: MyTextStyle.f16(Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appPrimaryColor,
            title: Text(
              'Edit Profile',
              style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: mainContainer(),
        );
      },
    );
  }

  Widget mainContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => _showImageSourceActionSheet(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: appPrimaryColor.withOpacity(0.1),
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                          child: _imageFile == null
                              ? Icon(Icons.person, size: 70, color: appPrimaryColor)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: appPrimaryColor,
                            radius: 20,
                            child: Icon(
                              Icons.camera_alt,
                              color: whiteColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _fullNameController,
                    cursorColor: appPrimaryColor,
                    decoration: _inputDecoration('Full Name', Icons.person),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your full name' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _usernameController,
                    readOnly: true,
                    cursorColor: appPrimaryColor,
                    decoration: _inputDecoration('Username', Icons.person_outline).copyWith(
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true,
                    cursorColor: appPrimaryColor,
                    decoration: _inputDecoration('Email', Icons.email).copyWith(
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  IntlPhoneField(
                    decoration: _inputDecoration('Phone Number', Icons.phone),
                    initialCountryCode: 'IN',
                    initialValue: _currentPhoneNumber,
                    cursorColor: appPrimaryColor,
                    onChanged: (phone) {
                      _currentCountryCode = phone.countryCode;
                      _currentPhoneNumber = phone.number;
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    cursorColor: appPrimaryColor,
                    decoration: _inputDecoration('Address', Icons.home),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your address' : null,
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedData = {
                            'fullName': _fullNameController.text,
                            'username': _usernameController.text,
                            'email': _emailController.text,
                            'phone': '$_currentCountryCode $_currentPhoneNumber',
                            'address': _addressController.text,
                          };
                          Navigator.pop(context, updatedData);
                        }
                      },
                      child: Text(
                        'SAVE CHANGES',
                        style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: appPrimaryColor),
      prefixIcon: Icon(icon, color: appPrimaryColor),
      enabledBorder: OutlineInputBorder(
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
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
