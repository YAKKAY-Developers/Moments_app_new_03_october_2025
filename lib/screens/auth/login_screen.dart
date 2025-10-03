// import 'package:flutter/material.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Future<void> _signIn() async {
//   //   if (_formKey.currentState!.validate()) {
//   //     try {
//   //       await Provider.of<AuthProvider>(context, listen: false).signIn(
//   //         phoneNumber: _phoneController.text.trim(),
//   //         password: _passwordController.text,
//   //       );

//   //       if (mounted) {
//   //         Navigator.pushReplacementNamed(context, '/home');
//   //       }
//   //     } catch (e) {
//   //       if (mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           SnackBar(
//   //             content: Text(e.toString()),
//   //             backgroundColor: Colors.red,
//   //           ),
//   //         );
//   //       }
//   //     }
//   //   }
//   // }


// Future<void> _signIn() async {
//   if (_formKey.currentState!.validate()) {
//     try {
//       await Provider.of<AuthProvider>(context, listen: false).signIn(
//         phoneNumber: _phoneController.text.trim(),
//         password: _passwordController.text,
//       );

//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     } on Exception catch (e) {
//       String errorMessage;

//       if (e.toString().contains("SocketException")) {
//         errorMessage = "No internet connection. Please check your network.";
//       } else if (e.toString().contains("TimeoutException")) {
//         errorMessage = "The request timed out. Please try again.";
//       } else if (e.toString().contains("500")) {
//         errorMessage = "Server error. Please try again later.";
//       } else if (e.toString().contains("401")) {
//         errorMessage = "Invalid phone number or password.";
//       } else if (e.toString().contains("400")) {
//         errorMessage = "Invalid input. Please check your details.";
//       } else {
//         errorMessage = "Something went wrong. Please try again.";
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }


// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 48, // 48 = top + bottom padding
//               ),
//               child: IntrinsicHeight(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const Icon(
//                       Icons.event,
//                       size: 80,
//                       color: Color(0xFF6C63FF),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2D3748),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Sign in to continue to Moments',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xFF718096),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 40),
//                     TextFormField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       decoration: const InputDecoration(
//                         labelText: 'Phone Number',
//                         prefixIcon: Icon(Icons.phone_outlined),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your phone number';
//                         }
//                         if (value.length < 10) {
//                           return 'Please enter a valid phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _passwordController,
//                       obscureText: _obscurePassword,
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         prefixIcon: const Icon(Icons.lock_outlined),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         if (value.length < 6) {
//                           return 'Password must be at least 6 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     Consumer<AuthProvider>(
//                       builder: (context, authProvider, child) {
//                         return ElevatedButton(
//                           onPressed: authProvider.isLoading ? null : _signIn,
//                           child: authProvider.isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 )
//                               : const Text('Sign In'),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/register');
//                       },
//                       child: const Text("Don't have an account? Sign Up"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
// }







import 'package:flutter/material.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedCountryCode = '+91'; // Default to India

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Combine country code with phone number
        final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
        
        await Provider.of<AuthProvider>(context, listen: false).signIn(
          phoneNumber: fullPhoneNumber, // Send full number with country code
          password: _passwordController.text,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on Exception catch (e) {
        String errorMessage;

        if (e.toString().contains("SocketException")) {
          errorMessage = "No internet connection. Please check your network.";
        } else if (e.toString().contains("TimeoutException")) {
          errorMessage = "The request timed out. Please try again.";
        } else if (e.toString().contains("500")) {
          errorMessage = "Server error. Please try again later.";
        } else if (e.toString().contains("401")) {
          errorMessage = "Invalid phone number or password.";
        } else if (e.toString().contains("400")) {
          errorMessage = "Invalid input. Please check your details.";
        } else {
          errorMessage = "Something went wrong. Please try again.";
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.event,
                        size: 80,
                        color: Color(0xFF6C63FF),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in to continue to Moments',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF718096),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // Phone Number Field with Country Code Picker
                      Row(
                    children: [
                      // Country Code Picker
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CountryCodePicker(
                          onChanged: (CountryCode countryCode) {
                            setState(() {
                              _selectedCountryCode = countryCode.dialCode ?? '+91';
                            });
                          },
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Phone Number Input
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            // Remove any non-digit characters for validation
                            final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                            if (digitsOnly.length < 7) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return ElevatedButton(
                            onPressed: authProvider.isLoading ? null : _signIn,
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Sign In'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Don't have an account? Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}