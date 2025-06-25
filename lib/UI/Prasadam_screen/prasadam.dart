import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Prasadam_screen/prasadam_item.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

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

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  double getTotalAmount() {
    return items.fold(0, (sum, item) => sum + (item.quantity * item.price));
  }

  List<PrasadamItem> get cartItems => items.where((item) => item.quantity > 0).toList();

  void increaseQuantity(PrasadamItem item) => setState(() => item.quantity++);
  void decreaseQuantity(PrasadamItem item) => setState(() => item.quantity = item.quantity > 0 ? item.quantity - 1 : 0);
  void removeItem(PrasadamItem item) => setState(() => item.quantity = 0);
  void clearCart() => setState(() => items.forEach((item) => item.quantity = 0));

  Widget mainContainer() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text("Prasadam", style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Bookings"), Tab(text: "Cart")],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
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
        Expanded(
          child: cartItems.isEmpty
              ? const Center(child: Text("No items in cart"))
              : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
        if (getTotalAmount() > 0)
          Column(
            children: [
              TextButton(
                onPressed: () => _showBillDialog(context),
                child: Text("View Detailed Bill", style: MyTextStyle.f14(appPrimaryColor, weight: FontWeight.bold)),
              ),
              _bottomTotalSection(context, label: "Pay Now", onPressed: () {})
            ],
          ),
      ],
    );
  }

  Widget _prasadamGridCard(PrasadamItem item, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Explicit white color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: greyColor200), // Light grey border
        ),
        elevation: 0, // Remove shadow
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
                      style: MyTextStyle.f15(blackColor,weight: FontWeight.bold)),
                  Text(item.tamilTitle,
                      style: MyTextStyle.f12(greyColor),),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("₹${item.price}",
                          style: MyTextStyle.f14(appPrimaryColor,weight: FontWeight.bold),),
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
                      '${item.quantity} Selected', style:MyTextStyle.f12(greenColor,weight: FontWeight.bold,)
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
      color: Colors.white, // Explicit white color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: greyColor200), // Light grey border
      ),
      elevation: 0, // Remove shadow
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item.imageUrl, height: 80, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(item.title, textAlign: TextAlign.center, style: MyTextStyle.f14(blackColor,weight: FontWeight.bold)),
            Text(item.tamilTitle, textAlign: TextAlign.center, style: MyTextStyle.f12(greyColor)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20, color: Colors.red),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => decreaseQuantity(item),
                ),
                Text('${item.quantity}', style: const TextStyle(fontSize: 14)),
                IconButton(
                  icon: const Icon(Icons.add, size: 20, color: Colors.green),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () => increaseQuantity(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.black54),
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

  Widget _bottomTotalSection(BuildContext context, {required String label, required VoidCallback onPressed}) {
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
