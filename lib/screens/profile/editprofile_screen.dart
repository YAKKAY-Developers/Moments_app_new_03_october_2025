// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _ageController;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     final user = Provider.of<AuthProvider>(context, listen: false).user;
//     _nameController = TextEditingController(text: user?.name);
//     _emailController = TextEditingController(text: user?.email);
//     _phoneController = TextEditingController(text: user?.phoneNumber);
//     _addressController = TextEditingController(text: user?.address);
//     _ageController = TextEditingController(text: user?.age?.toString());
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await Provider.of<AuthProvider>(context, listen: false).updateProfile(
//           name: _nameController.text.trim(),
//           email: _emailController.text.trim(),
//           phoneNumber: _phoneController.text.trim(),
//           address: _addressController.text.trim(),
//           age: int.tryParse(_ageController.text.trim()),
//           imageFile: _selectedImage,
//         );

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Profile updated successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.toString()),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _updateProfile,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 // In your CircleAvatar widget:
//                 child:CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                   backgroundImage: _selectedImage != null
//                       ? FileImage(_selectedImage!)
//                       : (user?.photo != null
//                           ? NetworkImage(NetworkService.getImageUrl(user!.photo!, type: 'profile'))
//                           as ImageProvider<Object>?
//                           : null),
//                   child: _selectedImage == null && (user?.photo == null || user!.photo!.isEmpty)
//                       ? Icon(
//                           Icons.camera_alt,
//                           size: 40,
//                           color: Theme.of(context).primaryColor,
//                         )
//                       : null,
//                 )
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Tap to change photo',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _ageController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Age',
//                   prefixIcon: Icon(Icons.calendar_today),
//                 ),
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty) {
//                     final age = int.tryParse(value);
//                     if (age == null || age <= 0) {
//                       return 'Please enter a valid age';
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixIcon: Icon(Icons.phone),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   if (value.length < 10) {
//                     return 'Please enter a valid phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Address',
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: authProvider.isLoading ? null : _updateProfile,
//                 child: authProvider.isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
















// //working code country code missing add 
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _ageController;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     final user = Provider.of<AuthProvider>(context, listen: false).user;
//     _nameController = TextEditingController(text: user?.name);
//     _emailController = TextEditingController(text: user?.email);
//     _phoneController = TextEditingController(text: user?.phoneNumber);
//     _addressController = TextEditingController(text: user?.address);
//     _ageController = TextEditingController(text: user?.age?.toString());
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _showImageOptions() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage();
//                 },
//               ),
//               if (Provider.of<AuthProvider>(context, listen: false).user?.photo != null &&
//                   Provider.of<AuthProvider>(context, listen: false).user!.photo!.isNotEmpty)
//                 ListTile(
//                   leading: const Icon(Icons.delete, color: Colors.red),
//                   title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _removePhoto();
//                   },
//                 ),
//               ListTile(
//                 leading: const Icon(Icons.cancel),
//                 title: const Text('Cancel'),
//                 onTap: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _removePhoto() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.removeProfilePhoto();
      
//       setState(() {
//         _selectedImage = null;
//       });
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Profile photo removed successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(e.toString()),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _updateProfile() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await Provider.of<AuthProvider>(context, listen: false).updateProfile(
//           name: _nameController.text.trim(),
//           email: _emailController.text.trim(),
//           phoneNumber: _phoneController.text.trim(),
//           address: _addressController.text.trim(),
//           age: int.tryParse(_ageController.text.trim()),
//           imageFile: _selectedImage,
//         );

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Profile updated successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.toString()),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   Widget _buildProfileAvatar() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;
//     final hasPhoto = user?.photo != null && user!.photo!.isNotEmpty;
//     final hasSelectedImage = _selectedImage != null;

//     return Stack(
//       children: [
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//           backgroundImage: hasSelectedImage
//               ? FileImage(_selectedImage!)
//               : (hasPhoto
//                   ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//                   as ImageProvider<Object>?
//                   : null),
//           child: !hasSelectedImage && !hasPhoto
//               ? Icon(
//                   Icons.camera_alt,
//                   size: 40,
//                   color: Theme.of(context).primaryColor,
//                 )
//               : null,
//         ),
//         if (hasPhoto || hasSelectedImage)
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.edit, size: 20),
//                 onPressed: _showImageOptions,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _updateProfile,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _showImageOptions,
//                 child: _buildProfileAvatar(),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Tap to change photo',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _ageController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Age',
//                   prefixIcon: Icon(Icons.calendar_today),
//                 ),
//                 validator: (value) {
//                   if (value != null && value.isNotEmpty) {
//                     final age = int.tryParse(value);
//                     if (age == null || age <= 0) {
//                       return 'Please enter a valid age';
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixIcon: Icon(Icons.phone),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   if (value.length < 10) {
//                     return 'Please enter a valid phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Address',
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: authProvider.isLoading ? null : _updateProfile,
//                 child: authProvider.isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String _selectedCountryCode = '+91'; // Default country code

@override
void initState() {
  super.initState();
  final user = Provider.of<AuthProvider>(context, listen: false).user;
  _nameController = TextEditingController(text: user?.name);
  _emailController = TextEditingController(text: user?.email);
  
  // Extract country code and phone number from stored phone number
  final phoneNumber = user?.phoneNumber ?? '';
  
  if (phoneNumber.isNotEmpty) {
    // Handle different phone number formats
    if (phoneNumber.startsWith('+')) {
      // For numbers like +919159911257
      if (phoneNumber.startsWith('+91') && phoneNumber.length > 3) {
        _selectedCountryCode = '+91';
        _phoneController = TextEditingController(text: phoneNumber.substring(3));
      } 
      // For other country codes (1-3 digits after +)
      else {
        // Find the country code (1-3 digits after +)
        final countryCodeMatch = RegExp(r'^\+(\d{1,3})').firstMatch(phoneNumber);
        if (countryCodeMatch != null) {
          final countryCodeDigits = countryCodeMatch.group(1)!;
          _selectedCountryCode = '+$countryCodeDigits';
          _phoneController = TextEditingController(
            text: phoneNumber.substring(countryCodeDigits.length + 1)
          );
        } else {
          // Fallback: use default country code and show full number
          _selectedCountryCode = '+91';
          _phoneController = TextEditingController(text: phoneNumber);
        }
      }
    } else {
      // If no country code prefix, assume it's just the local number
      _selectedCountryCode = '+91';
      _phoneController = TextEditingController(text: phoneNumber);
    }
  } else {
    _phoneController = TextEditingController();
  }
  
  _addressController = TextEditingController(text: user?.address);
  _ageController = TextEditingController(text: user?.age?.toString());
}

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              if (Provider.of<AuthProvider>(context, listen: false).user?.photo != null &&
                  Provider.of<AuthProvider>(context, listen: false).user!.photo!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _removePhoto();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removePhoto() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.removeProfilePhoto();
      
      setState(() {
        _selectedImage = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo removed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Combine country code with phone number
        final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
        
        await Provider.of<AuthProvider>(context, listen: false).updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: fullPhoneNumber, // Send full number with country code
          address: _addressController.text.trim(),
          age: int.tryParse(_ageController.text.trim()),
          imageFile: _selectedImage,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildProfileAvatar() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final hasPhoto = user?.photo != null && user!.photo!.isNotEmpty;
    final hasSelectedImage = _selectedImage != null;

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          backgroundImage: hasSelectedImage
              ? FileImage(_selectedImage!)
              : (hasPhoto
                  ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
                  as ImageProvider<Object>?
                  : null),
          child: !hasSelectedImage && !hasPhoto
              ? Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
        if (hasPhoto || hasSelectedImage)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: _showImageOptions,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _showImageOptions,
                child: _buildProfileAvatar(),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap to change photo',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid age';
                    }
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
                  prefixIcon: Icon(Icons.email),
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
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _updateProfile,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}