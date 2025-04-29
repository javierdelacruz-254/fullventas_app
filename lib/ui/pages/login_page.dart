import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/login_data_provider.dart';
import 'package:fullventas_app/config/providers/screen_data_provider.dart';
import 'package:fullventas_app/config/providers/user_info_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';
import 'package:fullventas_app/domain/models/fullventas_data/user_info_data.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/widgets/logo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lottie/lottie.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false;
  double _logoOpacity = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _logoOpacity = 1.0;
      });
    });
  }

  Future<void> checkUserStatus(
      BuildContext context, WidgetRef ref, Function onSuccess) async {
    final userInfo = ref.read(userInfoDataProvider);
    final List<UserInfoData> userStatus = await userInfo.getUserInfoData();

    if (userStatus.isNotEmpty && userStatus.first.status == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
              return false;
            },
            child: AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/img/technical_error.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Hay problemas tecnicos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Intentalo mas tarde',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3391FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text(
                        'Salir',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ))
                ],
              ),
            ),
          );
        },
      );
    } else {
      onSuccess();
    }
  }

  Future<void> signIn(BuildContext context, WidgetRef ref) async {
    await GoogleSignIn().signOut();
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign in failed'),
      ));
      return;
    }
    checkUserStatus(
      context,
      ref,
      () {
        final googleUser = ClienteData(
          nombres: user.displayName ?? "Usuario",
          email: user.email,
        );

        ref.read(userProvider.notifier).setUser(googleUser, isGoogleUser: true);

        print(
            "Usuario guardado en Provider: ${googleUser.nombres}, ${googleUser.email}");

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  Future<void> loginWithCode(BuildContext context) async {
    final loginUseCase = ref.read(loginDataProvider);
    final codigo = _codigoController.text.trim();

    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, ingresa tu código")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cliente = await loginUseCase.login(codigo);

    setState(() {
      _isLoading = false;
    });

    if (cliente != null) {
      checkUserStatus(context, ref, () {
        ref.read(userProvider.notifier).setUser(cliente);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Código incorrecto, inténtalo nuevamente")),
      );
    }
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context) {
    final UserInfoDetailUseCase = ref.watch(userInfoDataProvider);
    final screenData = ref.watch(screenDataProvider).value ?? [];

    final String colorHex = screenData.isNotEmpty
        ? screenData.first.codigo ?? "#FFFFFF"
        : "#FFFFFF";
    final String secondColor = screenData.isNotEmpty
        ? screenData.first.color_secundario ?? "#FFFFFF"
        : "#FFFFFF";

    return Scaffold(
      backgroundColor: hexToColor(secondColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                opacity: _logoOpacity,
                duration: Duration(seconds: 1),
                child: GymScreen(),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SignInButton(
                  Buttons.Google,
                  text: 'Ingresar con Google',
                  onPressed: () => signIn(context, ref),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Si eres alumno, ingresa tu código",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 15.0),
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Codigo",
                  labelStyle: TextStyle(color: Colors.black54),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Bordes redondeados
                    borderSide: BorderSide.none, // Sin borde
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth:
                        40, // Ajusta el tamaño del icono para que no empuje el texto
                    minHeight: 40,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: _isLoading ? null : () => loginWithCode(context),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: hexToColor(colorHex),
                    boxShadow: [
                      BoxShadow(
                        color: hexToColor(secondColor).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Ingresar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Función aún no implementada")),
                  );
                },
                child: Text(
                  "¿Olvidaste tu código?",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
