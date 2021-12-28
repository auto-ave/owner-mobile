// import 'package:add_2_calendar/add_2_calendar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/navigation/arguments.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/feedback/feedback_screen.dart';
import 'package:owner_app/ui/widget/common_booking_tile.dart';
import 'package:owner_app/ui/widget/common_button.dart';
import 'package:owner_app/ui/widget/dashed_booking_box.dart';
import 'package:owner_app/utils.dart';

class BookingDetailScreen extends StatefulWidget {
  final BookingListModel booking;
  const BookingDetailScreen({Key? key, required this.booking})
      : super(key: key);
  static final String route = '/bookingDetailScreen';
  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackButton(context: context, actions: [
          CommonTextButton(
              onPressed: () {
                Navigator.pushNamed(context, FeedbackScreen.route,
                    arguments: FeedbackScreenArguments(
                        isFeedback: false,
                        orderNumber: widget.booking.bookingId));
              },
              child: Text(
                'Support',
                style: SizeConfig.kStyle16PrimaryColor,
              ),
              backgroundColor: Colors.white)
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Order Details',
                  style: SizeConfig.kStyle20W500,
                ),
                SizeConfig.kverticalMargin16,
                BookingStatusTag(status: widget.booking.status),
                SizeConfig.kverticalMargin24,
                Text('Booking Details',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.kfontSize20)),
                SizeConfig.kverticalMargin8,
                DashedBookingBox(bookingDetail: widget.booking),
                SizeConfig.kverticalMargin16,
              ],
            ),
          ),
        ));
  }
}
