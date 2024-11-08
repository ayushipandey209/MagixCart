import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:magixcart/model/AllProducts.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  CartService({required this.userId});

  Future<void> addToCart(Product product) async {
    try {
      await _db.collection('users')
          .doc('mor_2314')   
          .collection('cart')
          .doc(product.id.toString())
          .set({
            'id' : product.id ,
            'title': product.title,
            'price': product.price,
            'image': product.image,
            'category': product.category,
            'description': product.description,
          });
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      await _db.collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId.toString())
          .delete();
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<List<Product>> getCartItems() async {
    try {
      QuerySnapshot snapshot = await _db.collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      
      List<Product> cartItems = snapshot.docs.map((doc) {
        return Product(
          id: doc['id'],
          title: doc['title'],
          image: doc['image'],
          price: doc['price'],
          description: doc['description'],
          category: doc['category'],
        );
      }).toList();
      
      return cartItems;
    } catch (e) {
      print('Error fetching cart items: $e');
      return [];
    }
  }
}
