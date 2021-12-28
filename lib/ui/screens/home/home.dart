import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/all_bookings/all_bookings.dart';
import 'package:owner_app/ui/screens/past_bookings/past_bookings.dart';
import 'package:owner_app/ui/screens/upcoming_bookings/upcoming_bookings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: SizeConfig.kPrimaryColor),
        iconTheme: IconThemeData(color: SizeConfig.kPrimaryColor),
      ),
      drawer: Drawer(),
      bottomNavigationBar: BottomNav(
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
      body: [
        UpcomingBookingsScreen(),
        AllBookingsScreen(),
        PastBookingsScreen()
      ][_currentIndex],
    );
  }
}

class BottomNav extends StatelessWidget {
  final Function(int index) onTabTapped;
  final int currentIndex;
  BottomNav({Key? key, required this.onTabTapped, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTabTapped,
      backgroundColor: Color(0xfffcfcfd),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            label: '',
            activeIcon: SvgPicture.asset(
              'assets/icons/todays_bookings.svg',
              color: Theme.of(context).primaryColor,
            ),
            icon: SvgPicture.asset(
              'assets/icons/todays_bookings.svg',
              color: Color(0xffA7A7A7),
            )),
        BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              'assets/icons/all_bookings.svg',
              color: Color(0xffA7A7A7),
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/all_bookings.svg',
              color: Theme.of(context).primaryColor,
            )),
        BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              'assets/icons/past_bookings.svg',
              color: Color(0xffA7A7A7),
            ),
            activeIcon: SvgPicture.asset('assets/icons/past_bookings.svg',
                color: Theme.of(context).primaryColor)),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.amber[800],
    );
  }
}
