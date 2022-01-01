import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:owner_app/blocs/start_complete_service/bloc/start_complete_service_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:owner_app/blocs/upcoming_bookings/upcoming_bookings_bloc.dart';
import 'package:owner_app/data/models/booking_list.dart';
import 'package:owner_app/data/models/price_time_list.dart';
import 'package:owner_app/data/models/vehicle_model.dart';
import 'package:owner_app/data/repos/repository.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/widget/common_button.dart';
import 'package:owner_app/ui/widget/common_textfield.dart';
import 'package:owner_app/ui/widget/error_widget.dart';
import 'package:owner_app/ui/widget/loading_more_tile.dart';
import 'package:owner_app/utils.dart';

class UpcomingBookingsScreen extends StatefulWidget {
  const UpcomingBookingsScreen({Key? key}) : super(key: key);

  @override
  _UpcomingBookingsScreenState createState() => _UpcomingBookingsScreenState();
}

class _UpcomingBookingsScreenState extends State<UpcomingBookingsScreen> {
  late final UpcomingBookingsBloc _upcomingBookingsBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _upcomingBookingsBloc = BlocProvider.of<UpcomingBookingsBloc>(context);
    _upcomingBookingsBloc
        .add(GetUpcomingBookings(offset: 0, forLoadMore: false));
  }

  List<BookingListModel> bookings = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Today\'s Bookings',
              style: SizeConfig.kStyle16Bold.copyWith(color: Colors.black),
            ),
          ),
        ),
        BlocConsumer<UpcomingBookingsBloc, UpcomingBookingsState>(
          listener: (_, state) {
            setState(() {});
          },
          bloc: _upcomingBookingsBloc,
          builder: (context, state) {
            if (state is UpcomingBookingsLoading) {
              return SliverFillRemaining(
                child: Center(
                  child: loadingAnimation(),
                ),
              );
            }
            if (state is UpcomingBookingsLoaded ||
                state is MoreUpcomingBookingsLoading) {
              if (state is UpcomingBookingsLoaded) {
                bookings = state.bookings;
              }

              return bookings.length == 0
                  ? SliverFillRemaining(
                      child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/no_results.png'),
                          SizeConfig.kverticalMargin16,
                          Text(
                            'No Bookings today',
                            style: SizeConfig.kStyle16W500,
                          )
                        ],
                      ),
                    ))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((_, index) {
                        var booking = bookings[index];
                        // var dateFormat = DateFormat.jm();
                        var tile = UpcomingBookingTile(
                          remainingAmount: booking.remainingAmount!,
                          services: booking.serviceNames!,
                          vehicleModel: booking.vehicleModel!,
                          endTime: booking.event!.endDateString,
                          startTime: booking.event!.startDateString,
                          onServiceStart: () {
                            setState(() {
                              bookings[index].status =
                                  BookingStatus.serviceStarted;
                            });
                          },
                          onServiceComplete: () {
                            print('on service com');
                            setState(() {
                              bookings[index].status =
                                  BookingStatus.serviceCompleted;
                            });
                            _upcomingBookingsBloc.add(GetUpcomingBookings(
                                offset: 0, forLoadMore: false));
                          },
                          status: booking.status,
                          bookingId: booking.bookingId!,
                        );
                        if (state is MoreUpcomingBookingsLoading &&
                            index == bookings.length - 1) {
                          return LoadingMoreTile(tile: tile);
                        }
                        return tile;
                      }, childCount: bookings.length),
                    );
            }

            if (state is UpcomingBookingsError) {
              return SliverFillRemaining(
                child: Center(
                  child: ErrorScreen(
                    ctaType: ErrorCTA.reload,
                    onCTAPressed: () {
                      _upcomingBookingsBloc.add(
                          GetUpcomingBookings(offset: 0, forLoadMore: false));
                    },
                  ),
                ),
              );
            }
            return SliverFillRemaining(
              child: Center(
                child: loadingAnimation(),
              ),
            );
          },
        )
      ],
    ));
  }
}

class UpcomingBookingTile extends StatefulWidget {
  final String startTime;
  final String endTime;
  final List<PriceTimeListModel> services;
  final num remainingAmount;
  final VehicleModel vehicleModel;
  final BookingStatus status;
  final VoidCallback onServiceStart;
  final VoidCallback onServiceComplete;
  final String bookingId;
  const UpcomingBookingTile(
      {Key? key,
      required this.startTime,
      required this.endTime,
      required this.services,
      required this.remainingAmount,
      required this.vehicleModel,
      required this.status,
      required this.onServiceComplete,
      required this.onServiceStart,
      required this.bookingId})
      : super(key: key);

  @override
  _UpcomingBookingTileState createState() => _UpcomingBookingTileState();
}

class _UpcomingBookingTileState extends State<UpcomingBookingTile> {
  late final StartCompleteServiceBloc _startCompleteServiceBloc;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startCompleteServiceBloc = StartCompleteServiceBloc(
        repository: RepositoryProvider.of<Repository>(context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartCompleteServiceBloc, StartCompleteServiceState>(
        bloc: _startCompleteServiceBloc,
        listener: (context, state) {
          print('listener called' + state.toString());
          // TODO: implement listener
          if (state is ServiceStarted) {
            widget.onServiceStart();
            _btnController.stop();
          } else if (state is ServiceCompleted) {
            print('state to servicecompleted');
            widget.onServiceComplete();
            _btnController.stop();
          } else if (state is StartServiceError) {
            _btnController.stop();
            showSnackbar(context,
                'Failed to start service. Please contact info@autoave.in');
          } else if (state is CompleteServiceError) {
            _btnController.stop();
            showSnackbar(context,
                'Failed to complete service. Please contact info@autoave.in');
          } else if (state is WrongOTPEntered) {
            _btnController.stop();
            showSnackbar(context, 'Wrong OTP Entered');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 0),
                      color: Color.fromRGBO(0, 0, 0, 0.25))
                ]),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: SizeConfig.kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Center(
                    child: Text(
                      '${widget.startTime} to ${widget.endTime}',
                      style:
                          SizeConfig.kStyle16Bold.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getDetailsRow(
                        leftText: 'Vehicle',
                        rightText:
                            '${widget.vehicleModel.brand} ${widget.vehicleModel.model}',
                        leftStyle: SizeConfig.kStyle14,
                        rightStyle: SizeConfig.kStyle14W500
                            .copyWith(color: SizeConfig.kPrimaryColor),
                      ),
                      SizeConfig.kverticalMargin8,
                      Builder(builder: (context) {
                        var description =
                            getServicesNameWithComma(widget.services);
                        return getDetailsRow(
                          leftText: 'Services',
                          rightText: description.substring(1),
                          leftStyle: SizeConfig.kStyle14,
                          rightStyle: SizeConfig.kStyle14W500
                              .copyWith(color: SizeConfig.kPrimaryColor),
                        );
                      }),
                      SizeConfig.kverticalMargin16,
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Color(0xffE5F1FF),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(text: 'Due amount: '),
                              TextSpan(
                                  text: '${widget.remainingAmount}',
                                  style: SizeConfig.kStyle16Bold.copyWith(
                                      color: SizeConfig.kPrimaryColor))
                            ])),
                          )
                        ],
                      ),
                      Divider(),
                      widget.status == BookingStatus.paymentSuccess
                          ? Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: CommonTextField(
                                    fieldController: _otpController,
                                    hintText: 'Enter OTP',
                                  ),
                                ),
                                SizeConfig.kHorizontalMargin8,
                                Flexible(
                                  flex: 1,
                                  child: RoundedLoadingButton(
                                    controller: _btnController,
                                    onPressed: () {
                                      _startCompleteServiceBloc.add(
                                          StartService(
                                              bookingId: widget.bookingId,
                                              otp: _otpController.text));
                                    },
                                    child: Text(
                                      'Start',
                                      style: SizeConfig.kStyle16Bold
                                          .copyWith(color: Colors.white),
                                    ),
                                    borderRadius: 4,
                                    width: 100.w,
                                    height: 40,
                                    color: SizeConfig.kPrimaryColor,
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                DottedBorder(
                                  dashPattern: [8, 4],
                                  color: Color(0xff1C5A2D),
                                  radius: Radius.circular(4),
                                  borderType: BorderType.Rect,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Color(0xffd5ffda),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'ONGOING',
                                      style: SizeConfig.kStyle14W500.copyWith(
                                          color: Color(0xff1C5A2D),
                                          letterSpacing: 4.32),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30.w,
                                  child: RoundedLoadingButton(
                                    controller: _btnController,
                                    onPressed: () {
                                      _startCompleteServiceBloc
                                          .add(CompleteService(
                                        bookingId: widget.bookingId,
                                      ));
                                    },
                                    child: Text(
                                      'Finish',
                                      style: SizeConfig.kStyle16Bold
                                          .copyWith(color: Colors.white),
                                    ),
                                    borderRadius: 4,
                                    height: 40,
                                    color: Color(0xff13A83D),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget getDetailsRow(
      {required String leftText,
      required String rightText,
      required TextStyle leftStyle,
      required TextStyle rightStyle}) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Text(
            leftText,
            style: leftStyle,
          ),
        ),
        Expanded(
          flex: 6,
          child: Align(
            child: Text(
              rightText,
              style: rightStyle,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
            alignment: Alignment.centerRight,
          ),
        ),
      ],
    );
  }
}

String getServicesNameWithComma(List<PriceTimeListModel> services) {
  String description = '';

  for (var element in services) {
    description = description + ', ' + element.service.toString();
  }
  return description;
}
