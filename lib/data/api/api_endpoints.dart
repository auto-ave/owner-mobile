import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:owner_app/blocs/global_auth/global_auth_bloc.dart';
import 'package:owner_app/data/api/auth_interceptor.dart';
import 'package:owner_app/data/api/log_interceptor.dart';

class ApiConstants {
  final GlobalAuthBloc _globalAuthBloc;
  ApiConstants({
    required GlobalAuthBloc globalAuthBloc,
  }) : _globalAuthBloc = globalAuthBloc;

  Dio dioClient() {
    var state = _globalAuthBloc.state;
    Map<String, dynamic>? headers;
    if (state is Authenticated) {
      headers = {'Authorization': 'JWT ${state.tokens.accessToken}'};
    }
    BaseOptions options = BaseOptions(
        // baseUrl: "<URL>",
        responseType: ResponseType.plain,
        headers: headers);
    Dio client = Dio(options);
    client.interceptors.add(Logging());
    client.interceptors.add(AuthInterceptor(globalAuthBloc: _globalAuthBloc));

    return client;
  }

  // final String baseUrl = "motorwash.herokuapp.com";
  final String baseUrl = "testapi.autoave.in";
  final int pageLimit = 10;

  String postStoreOwnerLoginEndPoint() {
    var uri = Uri.https(baseUrl, "/store-owner/login/");
    return uri.toString();
  }

  String getStoreOwnerNewBookingsEndPoint() {
    var uri = Uri.https(baseUrl, "/store-owner/new/bookings/");
    return uri.toString();
  }

  String postStoreOwnerServiceStartEndPoint() {
    var uri = Uri.https(baseUrl, "/owner/service/start/");
    return uri.toString();
  }

  String postStoreOwnerServiceCompleteEndPoint() {
    var uri = Uri.https(baseUrl, "/owner/service/complete/");
    return uri.toString();
  }

  String getStoreOwnerUpcomingBookingsEndPoint({required int offset}) {
    // Map<String, dynamic> params = {
    //   'offset': offset.toString(),
    //   'limit': pageLimit.toString(),
    // };
    // var uri = Uri.https(baseUrl, "/owner/bookings/upcoming/", params);
    String date = DateFormat('y-M-d').format(DateTime.now());
    Map<String, dynamic> params = {'date': date};
    var uri = Uri.https(baseUrl, "/owner/bookings/upcoming/", params);
    return uri.toString();
  }

  String getStoreOwnerBookingsByDateEndPoint({required String date}) {
    // Map<String, dynamic> params = {
    //   'offset': offset.toString(),
    //   'limit': pageLimit.toString(),
    // };

    Map<String, dynamic> params = {'date': date};
    var uri = Uri.https(baseUrl, "/owner/bookings/upcoming/", params);
    return uri.toString();
  }

  String postStoreOwnerNewBookingsByDateEndPoint() {
    return "$baseUrl/store-owner/new/bookings/";
  }

  String getStoreOwnerPastBookingsEndPoint() {
    // return "$baseUrl/owner/bookings/past/";
    var uri = Uri.https(
      baseUrl,
      "/owner/bookings/past/",
    );
    return uri.toString();
  }

  String getStoreOwnerRevenueEndPoint() {
    return "$baseUrl/store-owner/revenue/";
  }

  String getStoreOwnerStoreVehiclesEndPoint() {
    return "$baseUrl/store-owner/store/vehicles";
  }

  String getFeedbackEndpoint() {
    var uri = Uri.https(baseUrl, "/feedback/");
    return uri.toString();
  }
}
