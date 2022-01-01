import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:owner_app/blocs/global_auth/global_auth_bloc.dart';
import 'package:owner_app/blocs/upcoming_bookings/upcoming_bookings_bloc.dart';
import 'package:owner_app/data/api/api_endpoints.dart';
import 'package:owner_app/data/api/api_methods.dart';
import 'package:owner_app/data/api/api_service.dart';
import 'package:owner_app/data/local/local_data_service.dart';
import 'package:owner_app/data/notifications/fcm_helper.dart';
import 'package:owner_app/data/repos/auth_repository.dart';
import 'package:owner_app/data/repos/auth_rest_repository.dart';
import 'package:owner_app/data/repos/repository.dart';
import 'package:owner_app/data/repos/rest_repository.dart';
import 'package:owner_app/navigation/arguments.dart';
import 'package:owner_app/simple_bloc_observer.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/all_bookings/all_bookings.dart';
import 'package:owner_app/ui/screens/booking_detail/booking_detail.dart';
import 'package:owner_app/ui/screens/feedback/feedback_screen.dart';
import 'package:owner_app/ui/screens/home/home.dart';
import 'package:owner_app/ui/screens/login/login.dart';
import 'package:owner_app/ui/screens/upcoming_bookings/upcoming_bookings.dart';
import 'firebase_options.dart';

GetIt getIt = GetIt.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    print("helllo");
  }
  try {
    await FirebaseMessaging.instance.getToken();
  } catch (e) {}
  try {
    /// Create a [AndroidNotificationChannel] for heads up notifications
    late AndroidNotificationChannel channel;

    /// Initialize the [FlutterLocalNotificationsPlugin] package.
    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    //TODO : Implement FCM and Local Notification for iOS
    channel = const AndroidNotificationChannel(
      'default_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      // playSound: true,

      // sound: RawResourceAndroidNotificationSound('turbo'),
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } on Exception catch (e) {
    print(e.toString());
  }
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocalDataService _localDataService;
  late final GlobalAuthBloc _globalAuthBloc;
  late AuthRepository _authRepository;
  late Repository _repository;
  late final UpcomingBookingsBloc _upcomingBookingsBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIt.registerSingleton<LocalDataService>(LocalDataService(),
        instanceName: LocalDataService.getItInstanceName);
    _localDataService = getIt.get<LocalDataService>(
        instanceName: LocalDataService.getItInstanceName);
    _globalAuthBloc = GlobalAuthBloc(localDataService: _localDataService);
    getIt.registerSingleton<ApiMethods>(
        ApiService(apiConstants: ApiConstants(globalAuthBloc: _globalAuthBloc)),
        instanceName: ApiService.getItInstanceName);
    ApiMethods _apiMethodsImp =
        getIt.get<ApiMethods>(instanceName: ApiService.getItInstanceName);
    _repository = RestRepository(apiMethodsImp: _apiMethodsImp);
    _authRepository = AuthRestRepository(apiMethodsImp: _apiMethodsImp);
    _globalAuthBloc.add(AppStarted());
    _upcomingBookingsBloc = UpcomingBookingsBloc(repository: _repository);
    try {
      FcmHelper().showTest();
      FcmHelper().onMessageFCM(_upcomingBookingsBloc);
    } on Exception catch (e) {
      // TODO
      print("helllllll");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GlobalAuthBloc>(
          create: (_) => _globalAuthBloc,
        ),
        BlocProvider<UpcomingBookingsBloc>(
          create: (_) => _upcomingBookingsBloc,
        )
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => _authRepository),
          RepositoryProvider(create: (_) => _repository),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primaryColor: const Color(0xff3570B5),
                fontFamily: 'DM SANS',
                scaffoldBackgroundColor: Colors.white),
            home: BlocBuilder<GlobalAuthBloc, GlobalAuthState>(
                bloc: _globalAuthBloc,
                builder: (context, state) {
                  SizeConfig().init(context);

                  if (state is Authenticated) {
                    return Home();
                  }
                  return LoginScreen();
                }),
            onGenerateRoute: (settings) {
              if (settings.name == BookingDetailScreen.route) {
                final args = settings.arguments as BookingDetailScreenArguments;

                return MaterialPageRoute(
                  builder: (context) {
                    return BookingDetailScreen(
                      booking: args.booking,
                    );
                  },
                );
              }
              if (settings.name == Home.route) {
                return MaterialPageRoute(
                  builder: (context) {
                    return const Home();
                  },
                );
              }
              if (settings.name == FeedbackScreen.route) {
                final args = settings.arguments as FeedbackScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return FeedbackScreen(
                      isFeedback: args.isFeedback,
                      orderNumber: args.orderNumber,
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
