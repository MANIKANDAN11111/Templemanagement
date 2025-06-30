import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';
import 'package:simple/UI/Prasadam_screen/prasadam_item.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class Devotee {
  String name;
  String email;
  String phone;
  String address;
  String remarks;

  Devotee({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.remarks,
  });
}

class PrasadamScreen extends StatelessWidget {
  const PrasadamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const PrasadamView(),
    );
  }
}

class PrasadamView extends StatefulWidget {
  const PrasadamView({super.key});

  @override
  State<PrasadamView> createState() => _PrasadamViewState();
}

class _PrasadamViewState extends State<PrasadamView> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<PrasadamItem> items = [
    PrasadamItem("Chakkara Ponggal", "சக்கரை பொங்கல்", 60, "assets/image/pongal.jpg"),
    PrasadamItem("Puli Sadam", "புளி சாதம்", 60, "assets/image/puli.jpg"),
    PrasadamItem("Thair Sadham", "தயிர் சாதம்", 60, "assets/image/puli.jpg"),
    PrasadamItem("Konda Kadalai", "கொண்ட கடலை", 60, "assets/image/kadalai.jpg"),
    PrasadamItem("Kesari", "கேசரி", 60, "assets/image/kesari.jpg"),
    PrasadamItem("108 Vadai", "108 வடை", 120, "assets/image/vadai.jpg"),
    PrasadamItem("Milagu Sadham", "மிளகு சாதம்", 60, "assets/image/sambar.jpg"),
    PrasadamItem("Sambar Sadham", "சாம்பார் சாதம்", 60, "assets/image/sambar.jpg"),
  ];

  final List<Devotee> _devoteeList = [];

  final _devoteeFormKey = GlobalKey<FormState>();

  final TextEditingController _devoteeNameController = TextEditingController();
  final TextEditingController _devoteeEmailController = TextEditingController();
  final TextEditingController _devoteePhoneController = TextEditingController();
  final TextEditingController _devoteeAddressController = TextEditingController();
  final TextEditingController _devoteeRemarksController = TextEditingController();

  String? _selectedCountryCode = '+91';

  final List<String> _countryCodes = [
    '+1',
    '+44',
    '+91',
    '+61',
    '+81',
    '+33',
    '+49',
    '+86',
    '+55',
    '+7',
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _devoteeNameController.dispose();
    _devoteeEmailController.dispose();
    _devoteePhoneController.dispose();
    _devoteeAddressController.dispose();
    _devoteeRemarksController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double getTotalAmount() {
    return items.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  List<PrasadamItem> get cartItems => items.where((item) => item.quantity > 0).toList();

  void increaseQuantity(PrasadamItem item) => setState(() => item.quantity++);
  void decreaseQuantity(PrasadamItem item) => setState(() => item.quantity = item.quantity > 0 ? item.quantity - 1 : 0);
  void removeItem(PrasadamItem item) => setState(() => item.quantity = 0);
  void clearCart() => setState(() => items.forEach((item) => item.quantity = 0));

  void deleteDevotee(int index) {
    setState(() {
      _devoteeList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Devotee removed.')),
    );
  }

  Future<void> _showPaymentSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Successful", style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
          content: Text("Your payment of ₹${getTotalAmount().toStringAsFixed(2)} was successful.",
              style: MyTextStyle.f14(blackColor)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      (route) => false,
                );
              },
              child: Text("OK", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDevoteeDetailsDialog(BuildContext context) async {
    _devoteeNameController.clear();
    _devoteeEmailController.clear();
    _devoteePhoneController.clear();
    _devoteeAddressController.clear();
    _devoteeRemarksController.clear();
    setState(() {
      _selectedCountryCode = '+91';
    });

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: appPrimaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Devotee Details", style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _devoteeFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _devoteeNameController,
                    cursorColor: appPrimaryColor,
                    decoration: InputDecoration(
                      labelText: 'Devotee Name',
                      hintText: 'Enter devotee name',
                      labelStyle: TextStyle(color: greyColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appPrimaryColor, width: 2.0),
                      ),
                      floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _devoteeEmailController,
                    cursorColor: appPrimaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email address',
                      labelStyle: TextStyle(color: greyColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appPrimaryColor, width: 2.0),
                      ),
                      floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountryCode,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: MyTextStyle.f14(blackColor),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCountryCode = newValue;
                              });
                              _devoteeFormKey.currentState?.validate();
                            },
                            items: _countryCodes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _devoteePhoneController,
                          cursorColor: appPrimaryColor,
                          keyboardType: TextInputType.phone,
                          maxLength: (_selectedCountryCode == '+91') ? 10 : 15,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter phone number',
                            labelStyle: TextStyle(color: greyColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: appPrimaryColor, width: 2.0),
                            ),
                            counterText: "",
                            floatingLabelStyle: TextStyle(color: appPrimaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (_selectedCountryCode == '+91') {
                              if (value.length != 10) {
                                return 'Phone number must be 10 digits for India';
                              }
                            } else {
                              if (value.length < 7 || value.length > 15) {
                                return 'Phone number should be 7-15 digits';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _devoteeAddressController,
                    cursorColor: appPrimaryColor,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter full address',
                      labelStyle: TextStyle(color: greyColor),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appPrimaryColor, width: 2.0),
                      ),
                      floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _devoteeRemarksController,
                    cursorColor: appPrimaryColor,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      hintText: 'Any special requests or remarks',
                      labelStyle: TextStyle(color: greyColor),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appPrimaryColor, width: 2.0),
                      ),
                      floatingLabelStyle: TextStyle(color: appPrimaryColor),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_devoteeFormKey.currentState!.validate()) {
                        final newDevotee = Devotee(
                          name: _devoteeNameController.text,
                          email: _devoteeEmailController.text,
                          phone: '$_selectedCountryCode${_devoteePhoneController.text}',
                          address: _devoteeAddressController.text,
                          remarks: _devoteeRemarksController.text,
                        );

                        setState(() {
                          _devoteeList.add(newDevotee);
                        });

                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(content: Text('Devotee details added for ${newDevotee.name}! You can add more.')),
                        );

                        _devoteeNameController.clear();
                        _devoteeEmailController.clear();
                        _devoteePhoneController.clear();
                        _devoteeAddressController.clear();
                        _devoteeRemarksController.clear();
                        setState(() {
                          _selectedCountryCode = '+91';
                        });
                        _devoteeFormKey.currentState?.reset();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Add", style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Submit", style: MyTextStyle.f16(whiteColor, weight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget mainContainer() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Prasadam", style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold)),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Bookings"), Tab(text: "Cart")],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildBookingsTab(), _buildCartTab()],
      ),
    );
  }

  Widget _buildBookingsTab() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _prasadamGridCard(item, () => increaseQuantity(item));
              },
            ),
          ),
        ),
        if (getTotalAmount() > 0)
          _bottomTotalSection(context, label: "View Cart", onPressed: () => _tabController.animateTo(1)),
      ],
    );
  }

  Widget _buildCartTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showDevoteeDetailsDialog(context),
                          style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor),
                          child: Text("Add Devotee Details", style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: clearCart,
                        style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor),
                        child: Text("Clear All", style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // const Divider(thickness: 1, height: 32, indent: 16, endIndent: 16),

                if (cartItems.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _devoteeList.isEmpty
                          ? const Text("No items or devotee details in cart")
                          : const Text("No prasadam items in cart"),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return _cartItemCard(item);
                      },
                    ),
                  ),

                if (cartItems.isNotEmpty)
                  const Divider(thickness: 1, height: 32, indent: 16, endIndent: 16),

                if (_devoteeList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Devotee Details", style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            dataRowMinHeight: 40,
                            dataRowMaxHeight: 60,
                            headingRowColor: MaterialStateProperty.resolveWith((states) => appPrimaryColor.withOpacity(0.1)),
                            columns: const [
                              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Phone No.', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: List<DataRow>.generate(
                              _devoteeList.length,
                                  (index) {
                                final devotee = _devoteeList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(devotee.name)),
                                    DataCell(Text(devotee.email)),
                                    DataCell(Text(devotee.phone)),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => deleteDevotee(index),
                                        tooltip: 'Delete Devotee',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_devoteeList.isNotEmpty)
                  const Divider(thickness: 1, height: 32, indent: 16, endIndent: 16),
              ],
            ),
          ),
        ),
        if (getTotalAmount() > 0)
          Column(
            children: [
              TextButton(
                onPressed: () => _showBillDialog(context),
                child: Text("View Detailed Bill", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
              ),
              _bottomTotalSection(
                context,
                label: "Pay Now",
                onPressed: () => _showPaymentSuccessDialog(context),
              )
            ],
          ),
      ],
    );
  }

  Widget _prasadamGridCard(PrasadamItem item, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: greyColor200),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(item.imageUrl, height: 100, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(item.title, textAlign: TextAlign.center,
                      style: MyTextStyle.f14(blackColor, weight: FontWeight.bold)),
                  Text(item.tamilTitle,
                      style: MyTextStyle.f12(greyColor)),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("₹${item.price}",
                          style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
                      if (item.quantity > 0)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.check_circle, color: Colors.green, size: 16),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (item.quantity > 0)
                    Text(
                        '${item.quantity} Selected', style: MyTextStyle.f12(greenColor, weight: FontWeight.bold)
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItemCard(PrasadamItem item) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: greyColor200),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 8, 5, 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item.imageUrl, height: 80, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(item.title, textAlign: TextAlign.center, style: MyTextStyle.f14(blackColor, weight: FontWeight.bold)),
            Text(item.tamilTitle, textAlign: TextAlign.center, style: MyTextStyle.f12(greyColor)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appPrimaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20, color: Colors.red),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () => decreaseQuantity(item),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text('${item.quantity}', style: const TextStyle(fontSize: 14)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20, color: Colors.green),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () => increaseQuantity(item),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 1),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.black54),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => removeItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomTotalSection(BuildContext context, {
    required String label,
    required VoidCallback onPressed
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: greyColor200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: ₹${getTotalAmount().toStringAsFixed(2)}", style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: appPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(label, style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Detailed Bill", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cartItems.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${item.title} × ${item.quantity}")),
                  Text("₹${(item.price * item.quantity).toStringAsFixed(2)}"),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Close", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state) => mainContainer(),
    );
  }
}