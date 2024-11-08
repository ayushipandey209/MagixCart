import 'package:flutter/material.dart';
import 'package:magixcart/constant/Colors.dart';
import 'package:magixcart/constant/Shared_Pref.dart';
import 'package:magixcart/constant/TextStyle.dart';
import 'package:magixcart/custom_widget.dart/CustomCategoryTabs.dart';
import 'package:magixcart/custom_widget.dart/CustomProductCard.dart';
import 'package:magixcart/model/AllProducts.dart';
import 'package:magixcart/screens/Cart.dart';
import 'package:magixcart/screens/Search.dart';
import 'package:magixcart/services/Product_Service.dart';
import 'package:magixcart/services/Sort_Service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<List<String>> _categoriesFuture;
  String selectedCategory = '';
  String selectedSortOrder = 'asc';
  int _selectedIndex = 0;
  String? _userId = "";

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ProductService().fetchCategories();
    _productsFuture = ProductService().fetchProducts();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final userId = await SharedPrefs.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  void _showSortDialog() async {
    String? selectedSort = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.baseLightCoral,
          title: Text("Sort Products", style: poppinsTextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.arrow_upward, color: Colors.green),
                label: Text(
                  "Ascending",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'asc');
                },
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.arrow_downward, color: Colors.red),
                label: Text(
                  "Descending",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'desc');
                },
              ),
            ],
          ),
        );
      },
    );


    if (selectedSort != null) {
      setState(() {
        selectedSortOrder = selectedSort;
        _productsFuture = SortService().fetchSortedProducts(selectedSortOrder);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ),
      );
    }
  }void _showFilterDialog() async {
  String? selectedFilter = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.baseLightCoral,
        title: Text("Filter Products", style: poppinsTextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.category, color: Colors.blue),
                label: Text(
                  "By Category",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'category');
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.price_change, color: Colors.green),
                label: Text(
                  "By Price Range",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'price');
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.star, color: Colors.orange),
                label: Text(
                  "By Rating",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'rating');
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                icon: Icon(Icons.check_circle, color: Colors.purple),
                label: Text(
                  "In Stock",
                  style: poppinsTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, 'in_stock');
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            padding: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
            color: AppColors.baseLightCoral,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MagixCart!',
                  style: poppinsTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10), 
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          focusNode.unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchScreen()),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.search, color: Colors.grey),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'What are you looking for?',
                                    border: InputBorder.none,
                                  ),
                                  onTap: () {
                                    focusNode.unfocus();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showSortDialog,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Icon(Icons.compare_arrows, color: AppColors.baseLightCoral, size: 30),
                      ),
                    ),
                     SizedBox(width: 10),
                    GestureDetector(
                      onTap: _showFilterDialog,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Icon(Icons.filter_list, color: AppColors.baseLightCoral, size: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //catgegory tabs  // done
          CustomCategoryTabs(
            categoriesFuture: _categoriesFuture,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                _productsFuture = ProductService().fetchProductsByCategory(category);
              });
            },
          ),
          //product card - custom  //done
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products available.'));
                  } else {
                    List<Product> products = snapshot.data!;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product, userId: _userId!);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
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
