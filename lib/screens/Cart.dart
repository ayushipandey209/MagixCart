import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magixcart/constant/Colors.dart';
import 'package:magixcart/constant/Shared_Pref.dart';
import 'package:magixcart/custom_widget.dart/CustomBottomNavigationBar.dart';
import 'package:magixcart/custom_widget.dart/CustomProductCard.dart';
import 'package:magixcart/model/AllProducts.dart';
import 'package:magixcart/services/Cart_Service.dart'; 

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartService _cartService;
  List<Product> _cartItems = [];
  bool _isLoading = true;
  int _selectedIndex = 2;
  late String userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId(); 
  }

  Future<void> _fetchUserId() async {
    userId = await SharedPrefs.getUserId() ?? ''; 

    if (userId.isNotEmpty) {
      _cartService = CartService(userId: userId);
      _fetchCartItems();
    } else {
      setState(() {
        _isLoading = false;
      });
      print('User ID not found!');
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      List<Product> cartItems = await _cartService.getCartItems();
      setState(() {
        _cartItems = cartItems;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeItemFromCart(Product product) async {
    try {
      await _cartService.removeFromCart(product.id); 
      Fluttertoast.showToast(
        msg: "Item removed from cart", 
        backgroundColor: Colors.red, 
        textColor: Colors.white 
      );
      setState(() {
        _cartItems.remove(product); 
      });
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(color: Colors.white)), 
        backgroundColor: AppColors.baseLightCoral,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(child: Text('No products in the cart.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final product = _cartItems[index];
                    return Stack(
                      children: [
                        ProductCard(product: product, userId: userId),
                        Positioned(
                          top: 60,
                          right: 15,
                          child: GestureDetector(
                            onTap: () => _removeItemFromCart(product), 
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.remove_shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: AppColors.baseLightCoral,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
