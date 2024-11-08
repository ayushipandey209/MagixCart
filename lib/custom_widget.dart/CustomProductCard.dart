import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magixcart/model/AllProducts.dart';
import 'package:magixcart/screens/Product_Detail.dart'; 

class ProductCard extends StatefulWidget {
  final Product product;
  final String userId;

  const ProductCard({required this.product , required this.userId});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorited = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: widget.product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5, right: 5, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
               //image 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.product.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
    
                  Positioned(
                    top: 5,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      radius: 20,
                      child: IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                          size: 25,
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Product added to like");
                          setState(() {
                            isFavorited = !isFavorited; 
                          });
                        },
                      ),
                    ),
                    
                  ),
                     // new product badge
                  if (true) 
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
           
              Text(
                widget.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
           
              Text(
                '\$ ${widget.product.price}', 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
             
              Text(
                '\$ 253', 
                style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
              ),
              
              //optional ui 
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "4.5 Sold",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
