import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magixcart/constant/Colors.dart';
import 'package:magixcart/constant/TextStyle.dart';
import 'package:magixcart/model/AllProducts.dart';
import 'package:magixcart/screens/Checkout.dart';
import 'package:magixcart/services/Product_Service.dart';
import 'package:magixcart/services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late Future<Product> _productFuture;
  late TabController _tabController;
  bool isInCart = false;
  late CartService _cartService;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService().fetchProductById(widget.productId);
    _tabController = TabController(length: 2, vsync: this);
    _cartService = CartService(userId: 'mor_2314');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleCart(Product product) {
    setState(() {
      if (isInCart) {
        _cartService.removeFromCart(product.id);
        Fluttertoast.showToast(msg: "Product removed from cart", backgroundColor: Colors.red);
      } else {
        _cartService.addToCart(product);
        Fluttertoast.showToast(msg: "Product added to cart", backgroundColor: Colors.green);
      }
      isInCart = !isInCart;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 239, 239),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Product not found.'));
          } else {
            final product = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(product.image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1.0,
                        right: 16.0,
                        child: GestureDetector(
                          onTap: () => toggleCart(product),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              size: 25,
                              isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                              color: isInCart ? Colors.green : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20.0,
                        left: 16.0,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.baseLightCoral,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.baseLightCoral,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: AppColors.baseLightCoral,
                        tabs: [
                          Tab(text: "Details"),
                          Tab(text: "More Tabs"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.title, style: poppinsTextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Text("\$${product.price}", style: poppinsTextStyle(fontSize: 20, color: Colors.green)),
                                  SizedBox(height: 10),
                                  Text(product.category, style: poppinsTextStyle(fontSize: 16, color: Colors.grey)),
                                  SizedBox(height: 20),
                                  Text(product.description, style: poppinsTextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            Container(child: Center(child: Text("Tab content goes here"))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(productId: widget.productId),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.lightCoralButtonColor,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            "Buy Now",
            style: poppinsTextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
