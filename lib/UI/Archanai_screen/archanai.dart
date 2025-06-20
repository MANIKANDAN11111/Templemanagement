import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Archanai_screen/add_rasi_bottomsheet.dart';

class ArchanaItem {
  final String title;
  final String tamilTitle;
  final String imagePath;
  final double price;
  int quantity;
  bool isSelected;

  ArchanaItem(this.title, this.tamilTitle, this.imagePath, this.price,
      {this.quantity = 0, this.isSelected = false});
}

class ArchanaiScreen extends StatelessWidget {
  const ArchanaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArchanaiScreenView();
  }
}

class ArchanaiScreenView extends StatefulWidget {
  const ArchanaiScreenView({super.key});

  @override
  State<ArchanaiScreenView> createState() => _ArchanaiScreenViewState();
}

class _ArchanaiScreenViewState extends State<ArchanaiScreenView>
    with TickerProviderStateMixin {
  String selectedFilter = 'All Archanai';
  final List<String> filterOptions = ['All Archanai', 'Archanai', 'Vaganam Archanai', 'Lamp'];
  late TabController _tabController;

  final List<ArchanaItem> generalArchanai = [
    ArchanaItem('Seer Thathu Archanai', 'சீர் தட்டு அர்ச்சனை', 'assets/image/seer.jpg', 10.0),
    ArchanaItem('Sahasranama Archanai', 'சஹஸ்ரநாமம்அர்ச்சனை', 'assets/image/seer.jpg', 10.0),
    ArchanaItem('Coconut Archanai', 'தேங்காய் அர்ச்சனை', 'assets/image/coconut.jpg', 10.0),
    ArchanaItem('Swamy Padam Archanai', 'சுவாமி பாத அர்ச்சனை', 'assets/image/saami.jpg', 10.0),
    ArchanaItem('Fruits Archanai', 'பழ அர்ச்சனை', 'assets/image/fruits.jpg', 10.0),
    ArchanaItem('Navagraha', 'நவகிரஹா', 'assets/image/navagraha.jpg', 10.0),
  ];

  final List<ArchanaItem> vaganamArchanai = [
    ArchanaItem('Bike Archanai', 'பைக் அர்ச்சனை', 'assets/image/bike.jpg', 10.0),
    ArchanaItem('Car Archanai', 'கார் அர்ச்சனை', 'assets/image/car.jpg', 10.0),
    ArchanaItem('Lorry Archanai', 'லாரி அர்ச்சனை', 'assets/image/car.jpg', 10.0),
  ];

  final List<ArchanaItem> lampArchanai = [
    ArchanaItem('Seetharu Coconut', 'சிதறு தேங்காய்', 'assets/image/coconut.jpg', 10.0),
    ArchanaItem('Poosani Lamp', 'பூசணி விளக்கு', 'assets/image/saami.jpg', 10.0),
    ArchanaItem('Ghee Lamp', 'நெய் விளக்கு', 'assets/image/saami.jpg', 10.0),
  ];

  List<ArchanaItem> get allItems => [
    ...generalArchanai,
    ...vaganamArchanai,
    ...lampArchanai,
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  double getTotalAmount() {
    return allItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  List<ArchanaItem> get cartItems =>
      allItems.where((item) => item.quantity > 0).toList();

  void increaseQuantity(ArchanaItem item) {
    setState(() {
      item.quantity++;
      item.isSelected = true;
    });
  }

  void decreaseQuantity(ArchanaItem item) {
    setState(() {
      if (item.quantity > 0) item.quantity--;
      if (item.quantity == 0) item.isSelected = false;
    });
  }

  void removeItem(ArchanaItem item) {
    setState(() {
      item.quantity = 0;
      item.isSelected = false;
    });
  }

  void clearCart() {
    setState(() {
      for (var item in allItems) {
        item.quantity = 0;
        item.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text("Archanai", style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold)),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: whiteColor,
            unselectedLabelColor: whiteColor,
            tabs: const [
              Tab(text: "Bookings"),
              Tab(text: "Cart"),
            ],
          ),
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back), color: whiteColor),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingTab(),
            _buildCartTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
               Text("Filter:", style: MyTextStyle.f16(
                appPrimaryColor,
                weight: FontWeight.bold,
              ),),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      iconEnabledColor: appPrimaryColor,
                      style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold),
                      items: filterOptions.map((filter) {
                        return DropdownMenuItem<String>(
                          value: filter,
                          child: Text(filter,
                          style: MyTextStyle.f16(
                            appPrimaryColor,
                            weight: FontWeight.bold,
                          ),),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              if (selectedFilter == 'All Archanai' || selectedFilter == 'Archanai') ...[
                _buildSectionTitle("Archanai"),
                _buildGridSection(generalArchanai),
              ],
              if (selectedFilter == 'All Archanai' || selectedFilter == 'Vaganam Archanai') ...[
                _buildSectionTitle("Vaganam Archanai"),
                _buildGridSection(vaganamArchanai),
              ],
              if (selectedFilter == 'All Archanai' || selectedFilter == 'Lamp') ...[
                _buildSectionTitle("Lamp"),
                _buildGridSection(lampArchanai),
              ],
            ],
          ),
        ),
        if (getTotalAmount() > 0)
          _bottomTotalBar("View Cart", () => _tabController.animateTo(1)),
      ],
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(title, style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
    );
  }

  Widget _buildGridSection(List<ArchanaItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              item.quantity++;
              item.isSelected = true;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(item.imagePath, height: 100, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(item.title, textAlign: TextAlign.center, style: MyTextStyle.f14(blackColor, weight: FontWeight.bold)),
                      Text(item.tamilTitle, style: MyTextStyle.f10(greyColor)),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("₹${item.price}", style: MyTextStyle.f12(blackColor, weight: FontWeight.bold)),
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
                          '${item.quantity} Selected',
                          style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const AddRasiDialog(),
                    );
                  },
                  child: Text("Add Raasi", style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appPrimaryColor),
                onPressed: clearCart,
                child: Text("Clear All", style: MyTextStyle.f14(whiteColor, weight: FontWeight.bold)),
              )
            ],
          ),
        ),
        Expanded(
          child: cartItems.isEmpty
              ? const Center(child: Text("No items in cart"))
              : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.66,
              ),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(item.imagePath,
                              height: 100, width: double.infinity, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 6),
                        Text(item.title,
                            textAlign: TextAlign.center,
                            style: MyTextStyle.f14(blackColor, weight: FontWeight.bold)),
                        Text(item.tamilTitle, style: MyTextStyle.f10(greyColor)),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _iconBtn(() => decreaseQuantity(item), Icons.remove, Colors.red),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text('${item.quantity}'),
                            ),
                            _iconBtn(() => increaseQuantity(item), Icons.add, Colors.green),
                            _iconBtn(() => removeItem(item), Icons.delete_outline, Colors.black54),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
        if (getTotalAmount() > 0)
          Column(
            children: [
              TextButton(
                onPressed: () => _showBillDialog(context),
                child: Text("View Detailed Bill",
                    style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
              ),
              _bottomTotalBar("Pay Now", () {
                // Payment logic
              }),
            ],
          )
      ],
    );
  }

  Widget _iconBtn(VoidCallback onTap, IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, size: 18, color: color),
      visualDensity: VisualDensity.compact,
      onPressed: onTap,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(4),
    );
  }

  Widget _bottomTotalBar(String label, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: ₹${getTotalAmount().toStringAsFixed(2)}",
              style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onPressed,
            child: Text(label, style: MyTextStyle.f16(whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Detailed Bill", style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: cartItems.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("${item.title} × ${item.quantity}")),
                  Text("₹ ${(item.price * item.quantity).toStringAsFixed(2)}"),
                ],
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Close", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
