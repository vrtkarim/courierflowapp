import 'package:courierflow/Home/ScanPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courierflow/Auth/bloc/auth_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthBloc authBloc = AuthBloc();
  // Text controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Login method that uses the AuthBloc
  void _login(t) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Dispatch the Login event to the AuthBloc
    authBloc.add(Login(email: email, password: password));
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is Logged) {
            // Navigate to home page on successful login
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ScanPage()));
          } else if (state is NotLogged) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 0, 173, 124),
                Color.fromARGB(255, 0, 126, 91)
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: SingleChildScrollView(
                
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(
                          children: [
                            Image.asset(
                              "img/login.png",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      
                                      child: Text(
                                        "Sign in to your account",
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 0, 173, 124),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(color: Color.fromARGB(255, 0, 173, 124),height: 10,),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 0, 173, 124),
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  hintStyle:
                                      TextStyle(color: Color.fromARGB(255, 0, 173, 124))),
                            ),
                            Divider(
                              color: Color.fromARGB(255, 0, 173, 124),
                              height: 29,
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintText: "Password ",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 0, 173, 124),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 173, 124)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  hintStyle:
                                      TextStyle(color: Color.fromARGB(255, 0, 173, 124))),
                            ),
                            Divider(color: Color.fromARGB(255, 0, 173, 124),height: 10,),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          authBloc.add(Login(
                              email: emailController.text,
                              password: passwordController.text));
                        },
                        child: BlocConsumer<AuthBloc, AuthState>(
                          bloc: authBloc,
                          listener: (context, state) {
                            if (state is NotLogged) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 0, 173, 124),Color.fromARGB(255, 0, 173, 124)
                                      ],
                  
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 5))
                                  ]),
                              child: Center(
                                child: state is AuthInitial
                                    ? Text(
                                        "SIGN IN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    : CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
