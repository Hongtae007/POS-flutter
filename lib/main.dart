import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS UI',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: POSScreen(),
    );
  }
}

class POSScreen extends StatefulWidget {
  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  List<Item> items = [
  Item(name: 'Pizza', price: 250, imagePath: 'assets/images/pizza.jpeg'),
  Item(name: 'Burger', price: 150, imagePath: 'assets/images/burger.jpeg'),
  Item(name: 'Pasta', price: 200, imagePath: 'assets/images/pasta.jpeg'),
  Item(name: 'Salad', price: 100, imagePath: 'assets/images/salad.jpeg'),
  Item(name: 'Sandwich', price: 120, imagePath: 'assets/images/sandwich.jpeg'),
  Item(name: 'Soup', price: 80, imagePath: 'assets/images/soup.jpeg'),
  Item(name: 'Fries', price: 70, imagePath: 'assets/images/fries.jpeg'),
  Item(name: 'Ice Cream', price: 90, imagePath: 'assets/images/ice_cream.jpeg'),
  Item(name: 'Cake', price: 110, imagePath: 'assets/images/cake.jpeg'),
  Item(name: 'Coffee', price: 60, imagePath: 'assets/images/coffee.jpeg'),
  Item(name: 'Tea', price: 50, imagePath: 'assets/images/tea.jpeg'),
  Item(name: 'Juice', price: 90, imagePath: 'assets/images/juice.jpeg'),
];

  List<OrderItem> orderItems = [];

  void addItemToOrder(Item item) {
    setState(() {
      var existingItem = orderItems.firstWhere(
        (orderItem) => orderItem.item.name == item.name,
        orElse: () => OrderItem(item: item, quantity: 0), // Provide a default value
      );

      if (existingItem.quantity == 0) {
        orderItems.add(OrderItem(item: item, quantity: 1));
      } else {
        existingItem.quantity++;
      }
    });
  }

  void updateQuantity(OrderItem orderItem, int change) {
    setState(() {
      orderItem.quantity += change;
      if (orderItem.quantity <= 0) {
        orderItems.remove(orderItem);
      }
    });
  }

  double getSubtotal() {
    return orderItems.fold(0, (sum, orderItem) => sum + orderItem.item.price * orderItem.quantity);
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = getSubtotal();
    double serviceCharge = subtotal * 0.1;
    double vat = (subtotal + serviceCharge) * 0.07;
    double grandTotal = subtotal + serviceCharge + vat;

    return Scaffold(
      appBar: AppBar(
        title: Text('LOGO POS'),
        backgroundColor: Colors.pink,
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 60,
            color: Colors.pink[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                ...List.generate(5, (index) => IconButton(icon: Icon(Icons.circle), onPressed: () {})),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Categories
                Container(
                  height: 100,
                  color: Colors.pink[100],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryButton(label: 'Food'),
                      CategoryButton(label: 'Drink'),
                      CategoryButton(label: 'Dessert'),
                      CategoryButton(label: 'Other'),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.pink[50],
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SubCategoryButton(label: 'ENTREE'),
                      SubCategoryButton(label: 'SOUP'),
                      SubCategoryButton(label: 'SALAD'),
                      SubCategoryButton(label: 'BBQ'),
                      SubCategoryButton(label: 'CURRIES'),
                      SubCategoryButton(label: 'STIR FRIED'),
                      SubCategoryButton(label: 'NOODLE & RICE'),
                      SubCategoryButton(label: 'SPECIAL'),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  height: 50,
                  padding: EdgeInsets.all(8.0),
                  color: Colors.pink[50],
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                  ),
                ),
                // Items Grid
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ItemCard(item: items[index], onTap: addItemToOrder);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Order Summary Section
          Container(
            width: 300,
            color: Colors.pink[50],
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Order
                Expanded(
                  child: ListView(
                    children: orderItems.map((orderItem) => OrderItemWidget(
                      orderItem: orderItem,
                      onUpdateQuantity: updateQuantity,
                    )).toList(),
                  ),
                ),
                // Total and Order Button
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.pink[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Subtotal: ${subtotal.toStringAsFixed(2)}.-',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Service Charge: ${serviceCharge.toStringAsFixed(2)}.-',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'VAT: ${vat.toStringAsFixed(2)}.-',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Grand Total: ${grandTotal.toStringAsFixed(2)}.-',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {},
                        child: Text('Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String name;
  final double price;
  final String imagePath;

  Item({required this.name, required this.price, required this.imagePath});
}

class OrderItem {
  final Item item;
  int quantity;

  OrderItem({required this.item, this.quantity = 1});
}

class CategoryButton extends StatelessWidget {
  final String label;

  CategoryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

class SubCategoryButton extends StatelessWidget {
  final String label;

  SubCategoryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[200],
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final void Function(Item) onTap;

  ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item),
      child: Card(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.imagePath,
                height: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8.0),
              Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text('${item.price.toStringAsFixed(2)}.-', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}


class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;
  final void Function(OrderItem, int) onUpdateQuantity;

  OrderItemWidget({required this.orderItem, required this.onUpdateQuantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.pink[200],
      child: ListTile(
        title: Text(orderItem.item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text('Price: ${orderItem.item.price.toStringAsFixed(2)}.-', style: TextStyle(fontSize: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => onUpdateQuantity(orderItem, -1),
              icon: Icon(Icons.remove),
            ),
            Text(orderItem.quantity.toString()),
            IconButton(
              onPressed: () => onUpdateQuantity(orderItem, 1),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
