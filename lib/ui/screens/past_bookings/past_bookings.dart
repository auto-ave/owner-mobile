import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owner_app/blocs/past_bookings/bloc/past_bookings_bloc.dart';
import 'package:owner_app/data/repos/repository.dart';
import 'package:owner_app/ui/widget/common_booking_tile.dart';
import 'package:owner_app/utils.dart';

class PastBookingsScreen extends StatefulWidget {
  const PastBookingsScreen({Key? key}) : super(key: key);

  @override
  _PastBookingsScreenState createState() => _PastBookingsScreenState();
}

class _PastBookingsScreenState extends State<PastBookingsScreen> {
  late final PastBookingsBloc _pastBookingsBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pastBookingsBloc = PastBookingsBloc(
        repository: RepositoryProvider.of<Repository>(context));
    _pastBookingsBloc.add(GetPastBookings(offset: 0, forLoadMore: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PastBookingsBloc, PastBookingsState>(
        bloc: _pastBookingsBloc,
        builder: (context, state) {
          if (state is PastBookingsLoaded) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return CommonBookingTile(bookingDetail: state.bookings[index]);
              },
              itemCount: state.bookings.length,
            );
          }
          return Center(
            child: loadingAnimation(),
          );
        },
      ),
    );
  }
}
