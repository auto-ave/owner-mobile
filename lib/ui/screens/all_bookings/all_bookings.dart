import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owner_app/blocs/all_bookings/bloc/all_bookings_bloc.dart';
import 'package:owner_app/data/repos/repository.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/all_bookings/components/date_selection_tab.dart';
import 'package:owner_app/ui/widget/common_booking_tile.dart';
import 'package:owner_app/utils.dart';

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({Key? key}) : super(key: key);

  @override
  _AllBookingsScreenState createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  int _currentSelectedTabIndex = 0;
  late final AllBookingsBloc _allBookingsBloc;
  List<DateTime> calendarDays = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 6; i++) {
      calendarDays.add(DateTime.now().add(Duration(days: i + 1)));
    }
    _allBookingsBloc =
        AllBookingsBloc(repository: RepositoryProvider.of<Repository>(context));
    _allBookingsBloc.add(
        GetAllBookingsByDate(date: calendarDays[_currentSelectedTabIndex]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'All Bookings',
              style: SizeConfig.kStyle16Bold.copyWith(color: Colors.black),
            ),
          ),
          DateSelectionTab(
              dates:
                  calendarDays.map((e) => DateSelectionItem(date: e)).toList(),
              currentSelectedTabIndex: _currentSelectedTabIndex,
              onTap: (index) {
                setState(() {
                  _currentSelectedTabIndex = index;
                });
                _allBookingsBloc
                    .add(GetAllBookingsByDate(date: calendarDays[index]));
              }),
          BlocBuilder<AllBookingsBloc, AllBookingsState>(
            bloc: _allBookingsBloc,
            builder: (context, state) {
              if (state is AllBookingsLoaded) {
                return state.bookings.length == 0
                    ? Expanded(
                        child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/no_results.png'),
                            SizeConfig.kverticalMargin16,
                            Text(
                              'No Bookings on this day',
                              style: SizeConfig.kStyle16W500,
                            )
                          ],
                        ),
                      ))
                    : Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _currentSelectedTabIndex >= 0
                                ? Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                        'Bookings on  ${calendarDays[_currentSelectedTabIndex].day}',
                                        style: SizeConfig.kStyle20Bold),
                                  )
                                : Container(),
                            Expanded(
                                child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return CommonBookingTile(
                                  bookingDetail: state.bookings[index],
                                  showStatusTag: false,
                                );
                              },
                              itemCount: state.bookings.length,
                            )),
                          ],
                        ),
                      );
              }
              return Expanded(
                child: Center(
                  child: loadingAnimation(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
