part of app.auth;

class ForgotPsView extends StatefulWidget {
  static String route = '${AuthView.route}/forgot_ps';

  _ForgotPsUpViewState createState() => _ForgotPsUpViewState();
}

class _ForgotPsUpViewState extends State<ForgotPsView> {
  final AuthRepository repository = locator<AuthRepository>();
  final NavigatorService navigator = locator<NavigatorService>();
  TextEditingController emailController = TextEditingController();

  String? emailError;
  bool get disableButton =>
      emailController.text.isEmpty;

  void onValidateEmail(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    bool isValid = regex.hasMatch(email.trim());
    setState(() {
      isValid ? emailError = null : emailError = 'invalid email';
    });
  }

    Future<void> sendPassword() async {
      if (emailError != null){
        return;
      }
     await repository.restorePassword(email: emailController.text);
     _mensajeAlert();
  }

  void navigateToSignUp() {
    navigator.push(route: SignUpView.route, key: navigator.authNavigatorKey);
  }

  void navigateToLogin() {
    navigator.replace(route: LoginView.route, key: navigator.authNavigatorKey);
  }


  // Future<void> _mensajeAlert() {
  _mensajeAlert() {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: const <Widget>[
              Text('Message succesfully sent'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop();    
                  navigateToLogin();
            },
            child: const Text('Accept'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: getProportionsScreenHeigth(14), color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        // Bloquear el scroll superior
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Forgo Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionsScreenHeigth(28),
                ),
              ),
              Text(
                'Please enter your email and we will send  \nyou a link to return to your account',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.05,
              ),
              Input(
                label: 'email',
                icon: Icons.email_outlined,
                controller: emailController,
                placeholder: 'add your email',
                onChange: onValidateEmail,
                error: emailError,
              ),
              SizedBox(
                height: getProportionsScreenHeigth(350),
              ),
              Button(
                label: 'Send',
                onPress: sendPassword,
                disable: disableButton,
              ),
              SizedBox(
                height: getProportionsScreenHeigth(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account? ",
                  ),
                  InkWell(
                    onTap: navigateToSignUp,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: primaryColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
