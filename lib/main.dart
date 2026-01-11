// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'cart/bloc/cart_bloc.dart';
import 'products/bloc/product_bloc.dart';
import 'products/bloc/product_event.dart';
import 'products/product_service.dart';
import 'products/product_list_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(
          create: (context) => ProductBloc(ProductService())..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Product Store',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}