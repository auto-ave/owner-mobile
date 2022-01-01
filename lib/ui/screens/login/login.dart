import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owner_app/blocs/email_auth/bloc/email_auth_bloc.dart';
import 'package:owner_app/blocs/global_auth/global_auth_bloc.dart';
import 'package:owner_app/data/api/api_methods.dart';
import 'package:owner_app/data/api/api_service.dart';
import 'package:owner_app/data/local/local_data_service.dart';
import 'package:owner_app/data/repos/auth_repository.dart';
import 'package:owner_app/data/repos/auth_rest_repository.dart';
import 'package:owner_app/main.dart';
import 'package:owner_app/size_config.dart';
import 'package:owner_app/ui/screens/login/components/login_appbar.dart';
import 'package:owner_app/ui/widget/common_button.dart';
import 'package:owner_app/ui/widget/common_textfield.dart';
import 'package:owner_app/utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final EmailAuthBloc _emailAuthBloc;
  late final GlobalAuthBloc _globalAuthBloc;
  late final AuthRepository _authRepository;
  late final LocalDataService _localDataService;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localDataService = getIt.get<LocalDataService>(
        instanceName: LocalDataService.getItInstanceName);
    _authRepository = RepositoryProvider.of<AuthRepository>(context);
    _globalAuthBloc = BlocProvider.of<GlobalAuthBloc>(context);
    _emailAuthBloc = EmailAuthBloc(
        globalAuthBloc: _globalAuthBloc,
        authRepository: _authRepository,
        localDataService: _localDataService);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: const LoginScreenAppBar(),
        body: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Owner Login',
                          style: SizeConfig.kStyle24Bold
                              .copyWith(color: SizeConfig.kPrimaryColor),
                        ),
                        SizeConfig.kverticalMargin24,
                        Text(
                          'Email',
                          style: SizeConfig.kStyle16,
                        ),
                        SizeConfig.kverticalMargin8,
                        CommonTextField(
                          fieldController: _emailController,
                          hintText: 'email',
                          maxLines: 1,
                          validator: (email) => validateEmail(email),
                        ),
                        SizeConfig.kverticalMargin16,
                        Text(
                          'Password',
                          style: SizeConfig.kStyle16,
                        ),
                        SizeConfig.kverticalMargin8,
                        CommonTextField(
                          fieldController: _passwordController,
                          hintText: 'password',
                          obscureText: true,
                          maxLines: 1,
                          validator: (pass) {
                            if (pass != null) {
                              if (pass.isNotEmpty) {
                                return null;
                              }
                              return 'Password cannot be empty';
                            }
                            return 'Check your password';
                          },
                        ),
                        SizeConfig.kverticalMargin16,
                        SizedBox(
                          width: 100.w,
                          child: BlocConsumer<EmailAuthBloc, EmailAuthState>(
                            listener: (context, state) {
                              // TODO: implement listener
                              if (state is EmailAuthenticated) {
                                showSnackbar(context, 'Logged In');
                                _btnController.success();
                              } else if (state is WrongCredentials) {
                                showSnackbar(
                                    context, 'Wrong email or password');
                                _btnController.stop();
                              } else if (state is EmailAuthError) {
                                _btnController.stop();
                                showSnackbar(context,
                                    'Something went wrong on our side. Please contact info@autoave.in');
                              }
                            },
                            bloc: _emailAuthBloc,
                            builder: (context, state) {
                              return RoundedLoadingButton(
                                child: Text(
                                  'Login',
                                  style: SizeConfig.kStyle16Bold
                                      .copyWith(color: Colors.white),
                                ),
                                controller: _btnController,
                                borderRadius: 4,
                                width: 100.w,
                                height: 40,
                                color: SizeConfig.kPrimaryColor,
                                animateOnTap: false,
                                onPressed: () async {
                                  if (_formKey.currentState != null) {
                                    if (_formKey.currentState!.validate()) {
                                      _btnController.start();
                                      String? token = await FirebaseMessaging
                                          .instance
                                          .getToken();
                                      print('tokennn' + token.toString());
                                      _emailAuthBloc.add(Login(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          fcmToken: token.toString()));
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 35.w,
                ),
              ),
              top: 0,
            ),
          ],
        ),
      ),
    );
  }
}
