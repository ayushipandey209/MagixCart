import 'package:flutter/material.dart';
import 'package:magixcart/constant/TextStyle.dart';
import 'package:magixcart/model/AllProducts.dart';
import 'package:magixcart/services/Product_Service.dart';



class CheckoutScreen extends StatefulWidget {
  final int productId;

  const CheckoutScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<Product> _productFuture;
  int quantity = 1;
  double deliveryCharge = 5.99;
  static const Color baseLightCoral = Color.fromARGB(255, 69, 128, 212);

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService().fetchProductById(widget.productId);
  }

  double calculateSubtotal(double price) {
    return price * quantity;
  }

  double calculateTotal(double price) {
    return calculateSubtotal(price) + deliveryCharge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summary", style: poppinsTextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.white)),
        backgroundColor: baseLightCoral,
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: poppinsTextStyle(fontSize: 16)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Product not found.', style: poppinsTextStyle(fontSize: 16)));
          } else {
            final product = snapshot.data!;
            double price = double.parse(product.price);
            double subtotal = calculateSubtotal(price);
            double total = calculateTotal(price);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Image.network(
                        product.image,
                        height: 120,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.title, style: poppinsTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("\$${product.price}", style: poppinsTextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text(quantity.toString(), style: poppinsTextStyle(fontSize: 18)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 1, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal", style: poppinsTextStyle(fontSize: 16)),
                      Text("\$${subtotal.toStringAsFixed(2)}", style: poppinsTextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Shipping", style: poppinsTextStyle(fontSize: 16)),
                      Text("\$${deliveryCharge.toStringAsFixed(2)}", style: poppinsTextStyle(fontSize: 16)),
                    ],
                  ),
                  Divider(thickness: 1, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total", style: poppinsTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseLightCoral)),
                      Text("\$${total.toStringAsFixed(2)}", style: poppinsTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: baseLightCoral)),
                    ],
                  ),
                  Divider(thickness: 1, height: 30),
                  Text("Track your Order:", style: poppinsTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOrderStatusStep('Order Confirmed', Icons.check, true),
                      _buildOrderStatusStep('Out for Delivery', Icons.delivery_dining, false),
                      _buildOrderStatusStep('Order Placed', Icons.check_circle, false),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Order Guidelines:", style: poppinsTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("- Cancellation: Orders can be canceled within 24 hours of purchase.", style: poppinsTextStyle(fontSize: 14)),
                  Text("- Refund: Refunds are processed within 7 business days after cancellation.", style: poppinsTextStyle(fontSize: 14)),
                  Text("- Support: For any assistance, contact support@magixcart.com or call +1-800-123-4567.", style: poppinsTextStyle(fontSize: 14)),
                  Text("- Delivery: Please ensure your address is accurate for timely delivery.", style: poppinsTextStyle(fontSize: 14)),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showOrderPlacedDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: baseLightCoral,
                      ),
                      child: Text("Checkout", style: poppinsTextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderStatusStep(String label, IconData icon, bool isActive) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
          color: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: poppinsTextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? Colors.green : Colors.grey),
        ),
      ],
    );
  }

  void _showOrderPlacedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: baseLightCoral,
                radius: 30,
                child: Icon(Icons.check, color: Colors.white, size: 40),
              ),
              SizedBox(height: 10),
              Text("Order Placed", textAlign: TextAlign.center, style: poppinsTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text("Your order has been placed successfully!", textAlign: TextAlign.center, style: poppinsTextStyle(fontSize: 16)),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("OK", style: poppinsTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }
}
