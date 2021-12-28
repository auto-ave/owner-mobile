import 'package:flutter/material.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/navigation/arguments.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/booking_detail/booking_detail.dart';
import 'package:owner_app/ui/screens/upcoming_bookings/upcoming_bookings.dart';
import 'package:owner_app/ui/widget/common_button.dart';

class CommonBookingTile extends StatelessWidget {
  final BookingListModel bookingDetail;
  final bool showStatusTag;
  const CommonBookingTile(
      {Key? key, required this.bookingDetail, this.showStatusTag = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 0),
                  color: Color.fromRGBO(138, 138, 138, 0.25))
            ],
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              var description =
                  getServicesNameWithComma(bookingDetail.serviceNames!);
              return Text(
                description.substring(2),
                style: SizeConfig.kStyle16W500,
              );
            }),
            SizeConfig.kverticalMargin8,
            Text(
              '${bookingDetail.event!.startDateString} to ${bookingDetail.event!.endDateString} • ${bookingDetail.vehicleModel!.brand} ${bookingDetail.vehicleModel!.model}',
              style: SizeConfig.kStyle14PrimaryColor,
            ),
            SizeConfig.kverticalMargin8,
            showStatusTag
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BookingStatusTag(status: bookingDetail.status),
                      SizeConfig.kverticalMargin4,
                    ],
                  )
                : SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonTextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(BookingDetailScreen.route,
                        arguments: BookingDetailScreenArguments(
                            booking: bookingDetail));
                  },
                  child: Text(
                    'View Details',
                    style:
                        SizeConfig.kStyle14W500.copyWith(color: Colors.white),
                  ),
                  backgroundColor: SizeConfig.kPrimaryColor,
                  border: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BookingStatusTag extends StatelessWidget {
  final BookingStatus status;
  BookingStatusTag({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = getBookingStatusTagColor(status);
    var text = getBookingStatusTagText(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        text,
        style: SizeConfig.kStyle14W500
            .copyWith(color: colors.textColor, letterSpacing: 1.2),
      ),
      decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(2)),
    );
  }

  BookingStatusTagColors getBookingStatusTagColor(BookingStatus status) {
    final BookingStatusTagColors redShade = BookingStatusTagColors(
        textColor: Color(0xffE94235), backgroundColor: Color(0xffFFD6D6));
    final BookingStatusTagColors greenShade = BookingStatusTagColors(
        textColor: Color(0xff35B559), backgroundColor: Color(0xffD6FFE1));
    switch (status) {
      case BookingStatus.cancellationRequestApproved:
        return greenShade;
      case BookingStatus.cancellationRequestRejected:
        return redShade;
      case BookingStatus.cancellationRequestSubmitted:
        return greenShade;
      case BookingStatus.paymentSuccess:
        return greenShade;
      case BookingStatus.paymentFailed:
        return redShade;
      case BookingStatus.notAttended:
        return redShade;
      case BookingStatus.serviceStarted:
        return greenShade;
      case BookingStatus.serviceCompleted:
        return greenShade;
      case BookingStatus.initiated:
        return greenShade;
      default:
        return redShade;
    }
  }

  String getBookingStatusTagText(BookingStatus status) {
    switch (status) {
      case BookingStatus.cancellationRequestApproved:
        return 'CANCELLATION APPROVED';
      case BookingStatus.cancellationRequestRejected:
        return 'CANCELLATION REJECTED';
      case BookingStatus.cancellationRequestSubmitted:
        return 'CANCELLATION REQUESTED';
      case BookingStatus.paymentSuccess:
        return 'PAYMENT DONE';
      case BookingStatus.paymentFailed:
        return 'PAYMENT FAILED';
      case BookingStatus.notAttended:
        return 'NOT ATTENDED';
      case BookingStatus.serviceStarted:
        return 'SERVICE STARTED';
      case BookingStatus.serviceCompleted:
        return 'COMPLETED';
      case BookingStatus
          .initiated: //TODO: Need to eliminate this status becuase it is of no use to the user
        return 'INITIATED';
      default:
        return 'STATUS UNAVAILABLE';
    }
  }
}

class BookingStatusTagColors {
  final Color textColor;
  final Color backgroundColor;
  BookingStatusTagColors({
    required this.textColor,
    required this.backgroundColor,
  });
}
