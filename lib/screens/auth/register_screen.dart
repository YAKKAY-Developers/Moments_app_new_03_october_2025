// import 'package:flutter/material.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   // Future<void> _signUp() async {
//   //   if (_formKey.currentState!.validate()) {
//   //     try {
//   //       // Get FCM token
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       String? fcmToken = prefs.getString('fcmToken');

//   //       // ignore: use_build_context_synchronously
//   //       await Provider.of<AuthProvider>(context, listen: false).signUp(
//   //         name: _nameController.text.trim(),
//   //         email: _emailController.text.trim(),
//   //         phoneNumber: _phoneController.text.trim(),
//   //         password: _passwordController.text,
//   //         confirmPassword: _confirmPasswordController.text,
//   //         fcmToken: fcmToken ?? '',
//   //       );

//   //       // After successful registration, automatically log the user in
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

// Future<void> _signUp() async {
//   if (_formKey.currentState!.validate()) {
//     try {
//       // Get FCM token
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? fcmToken = prefs.getString('fcmToken');

//       await Provider.of<AuthProvider>(context, listen: false).signUp(
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         phoneNumber: _phoneController.text.trim(),
//         password: _passwordController.text,
//         confirmPassword: _confirmPasswordController.text,
//         fcmToken: fcmToken ?? '',
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


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Create Account'),
//       //   backgroundColor: Colors.transparent,
//       //   elevation: 0,
//       //   foregroundColor: Theme.of(context).primaryColor,
//       // ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Join Moments',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3748),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Create your account to start sharing events',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF718096),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Full Name',
//                       prefixIcon: Icon(Icons.person_outlined),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       if (value.length < 2) {
//                         return 'Name must be at least 2 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.email_outlined),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: const InputDecoration(
//                       labelText: 'Phone Number',
//                       prefixIcon: Icon(Icons.phone_outlined),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       if (value.length < 10) {
//                         return 'Please enter a valid phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: const Icon(Icons.lock_outlined),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: _obscureConfirmPassword,
//                     decoration: InputDecoration(
//                       labelText: 'Confirm Password',
//                       prefixIcon: const Icon(Icons.lock_outlined),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureConfirmPassword = !_obscureConfirmPassword;
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   Consumer<AuthProvider>(
//                     builder: (context, authProvider, child) {
//                       return ElevatedButton(
//                         onPressed: authProvider.isLoading ? null : _signUp,
//                         child: authProvider.isLoading
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               )
//                             : const Text('Create Account'),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Already have an account? Sign In'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedCountryCode = '+91'; // Default to India

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get FCM token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? fcmToken = prefs.getString('fcmToken');

        // Combine country code with phone number
        final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';

        await Provider.of<AuthProvider>(context, listen: false).signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: fullPhoneNumber, // Send full number with country code
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          fcmToken: fcmToken ?? '',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Join Moments',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account to start sharing events',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF718096),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _signUp,
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Create Account'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}