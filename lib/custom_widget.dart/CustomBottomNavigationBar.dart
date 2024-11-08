import 'package:flutter/material.dart';
import 'package:magixcart/constant/Colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; 
  final Function(int) onItemTapped; 
    
  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      
      currentIndex: selectedIndex, 
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
       
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
   
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
   
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppColors.baseLightCoral, 
      unselectedItemColor: Colors.grey, 
      onTap: onItemTapped, 
      showUnselectedLabels: true, 
    );
  }
}
