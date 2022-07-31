import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
// import './screens/splash_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) {
            return Auth();
          }),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(
              Provider.of<Auth>(ctx, listen: false).token,
              Provider.of<Auth>(ctx, listen: false).userId,
              [],
            ),
            update: (ctx, auth, previousProducts) {
              return Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              );
            },
          ),
          ChangeNotifierProvider(create: (ctx) {
            return Cart();
          }),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) {
              return Orders(
                Provider.of<Auth>(ctx, listen: false).token,
                Provider.of<Auth>(ctx, listen: false).userId,
                [],
              );
            },
            update: (ctx, auth, previousOrders) {
              return Orders(auth.token, auth.userId,
                  previousOrders == null ? [] : previousOrders.orders);
            },
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Color.fromARGB(255, 236, 148, 80),
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
              // : FutureBuilder(
              //     future: auth.tryAutoSingIn(),
              //     builder: (ctx, authResultSnapshot) =>
              //         authResultSnapshot.connectionState ==
              //                 ConnectionState.waiting
              //             ? SplashScreen()
              //             : AuthScreen(),
              //   ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreeen.routeName: (ctx) => UserProductsScreeen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
