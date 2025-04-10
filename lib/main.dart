import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _correctId = 'Inmakes';
  final String _correctPassword = 'flutter123';


  void _login() {
    if (_formKey.currentState!.validate()) {

      final id = _idController.text.trim();
      final password = _passwordController.text;

      if (id == _correctId && password == _correctPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        _showMessage('Oops!!! Invalid ID or Password, please try again!!',);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.blueAccent,
      ),
      
       body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    FlutterLogo(size: 100,),
                    Text('Flutter',style:TextStyle(fontSize: 90) ,)
                  ],
                ),
                const SizedBox(height: 32),
            
                
                TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                            labelText: 'Login ID',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person)),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your ID' : null,
                      ),
                const SizedBox(height: 16),
            
                
                TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your password' : null,
                      ),
            
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 16),
            
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _login,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                ),
            
                const SizedBox(height: 24),
                const Text("New User? Create Account"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _fakeStore = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // Automatically fetch on page load
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _fakeStore = jsonData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fake Store')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(child: Text('Something went wrong. Try again later.'))
              : ListView.builder(
                  itemCount: _fakeStore.length,
                  itemBuilder: (context, index) {
                    final item = _fakeStore[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      color: Colors.pink[50],
                      child: ListTile(
                        leading: Image.network(
                          item['image'],
                          height: 75,
                          width: 75,
                        ),
                        title: Text(item['title']),
                        subtitle: Text(
                          item['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '\$${item['price']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
