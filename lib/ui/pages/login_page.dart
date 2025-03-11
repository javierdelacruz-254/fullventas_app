import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullventas_app/config/providers/login_data_provider.dart';
import 'package:fullventas_app/config/providers/user_provider.dart';
import 'package:fullventas_app/domain/models/fullventas_data/cliente_data.dart';
import 'package:fullventas_app/ui/pages/home_page.dart';
import 'package:fullventas_app/ui/widgets/logo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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

  Future signIn(BuildContext context, WidgetRef ref) async {
    await GoogleSignIn().signOut();
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign in failed'),
      ));
      return;
    }

    final googleUser = ClienteData(
      nombres: user.displayName ?? "Usuario",
      email: user.email,
    );

    ref.read(userProvider.notifier).setUser(googleUser, isGoogleUser: true);

    print(
        "Usuario guardado en Provider: ${googleUser.nombres}, ${googleUser.email}");

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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
      ref.read(userProvider.notifier).setUser(cliente);

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Código incorrecto, inténtalo nuevamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3391FA),
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
                  color: Colors.white70,
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
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
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
                    color: Colors.white54,
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
