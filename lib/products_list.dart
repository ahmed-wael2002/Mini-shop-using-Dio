import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String image_url;

  Product({required this.id, required this.title, required this.price, required this.image_url});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      image_url: json['thumbnail'],
    );
  }
}

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  List<Product> cart = [];
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await dio.get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        setState(() {
          products = productsJson.map((json) => Product.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  void addToCart(Product product) {
    setState(() {
      if (!cart.contains(product)) {
        cart.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return the cart to the HomePage when back button is pressed
        Navigator.pop(context, cart);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, cart); // Pass the cart back to HomePage
            },
          ),
        ),
        body: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Image.network(
                product.image_url,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(product.title),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => addToCart(product),
              ),
              tileColor: Theme.of(context).colorScheme.surfaceBright, // Use theme-based background color
            );
          },
        ),
      ),
    );
  }
}