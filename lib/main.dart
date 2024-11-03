import 'package:flutter/material.dart';
import 'products_list.dart';
import 'cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Assessment (2)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, surfaceBright: Colors.green[100]),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lab Assessment (2)'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Product> cart = [];

  // Method to handle tap on BottomNavBar items
  void _onItemTapped(int index) {
    setState(() async {
      _selectedIndex = index;
      switch(_selectedIndex){
        // Navigating to the Product page
        case 0:
          // Navigate to ProductsPage and wait for the cart result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsPage()),
          );

          // Update the cart with the result returned from ProductsPage
          if (result != null && result is List<Product>) {
            setState(() {
              cart = result;
            });
          }
          break;

        // Navigating to the cart page
        case 1:
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
          );

          // Update the cart after returning from CartPage
          if (result != null && result is List<Product>) {
            setState(() {
              cart = result;
            });
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lab'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color:Theme.of(context).colorScheme.primary),),
            const Text('We wish you happy shopping :)'),
            Center(child: Image.asset(width: 300, height: 300, 'assets/images/shopping.png')),
          ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );

  }
}
