
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'admin_dashboard_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  bool isLoggedIn = false;
  bool isAdmin = false;
  bool isOpeningLogin = false;

  String customerName = '';
  String customerEmail = '';

  bool _requiresLogin(int index) {
    return index == 2 || index == 3 || index == 4;
  }

  void _onDestinationSelected(int index) {
    if (_requiresLogin(index) && !isLoggedIn) {
      _openLogin(targetIndex: index);
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _openLogin({required int targetIndex}) async {
    if (isOpeningLogin) return;

    setState(() {
      isOpeningLogin = true;
    });

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onCustomerLogin: (session) {
            setState(() {
              customerName = session.name;
              customerEmail = session.email;
            });
          },
          onLogin: (admin) {
            Navigator.pop(context, admin);
          },
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      isOpeningLogin = false;
    });

    if (result == null) return;

    setState(() {
      isLoggedIn = true;
      isAdmin = result;
    });

    if (result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(
            onLogout: () {
              setState(() {
                isLoggedIn = false;
                isAdmin = false;
                customerName = '';
                customerEmail = '';
                selectedIndex = 0;
              });

              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      setState(() {
        selectedIndex = targetIndex;
      });
    }
  }

  void _logoutCustomer() {
    setState(() {
      isLoggedIn = false;
      isAdmin = false;
      customerName = '';
      customerEmail = '';
      selectedIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kamu berhasil keluar dari akun.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeScreen(),
      const ExploreScreen(),
      const CartScreen(),
      const OrdersScreen(),
      ProfileScreen(
        isLoggedIn: isLoggedIn && !isAdmin,
        customerName: customerName,
        customerEmail: customerEmail,
        onLogout: _logoutCustomer,
        onLoginTap: () => _openLogin(targetIndex: 4),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.pinkLight,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
