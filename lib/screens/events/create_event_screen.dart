// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/network_service/network_service.dart';
// import '../../utils/theme.dart';

// class CreateEventScreen extends StatefulWidget {
//   const CreateEventScreen({super.key});

//   @override
//   State<CreateEventScreen> createState() => _CreateEventScreenState();
// }

// class _CreateEventScreenState extends State<CreateEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _locationController = TextEditingController();

//   bool _useTemplate = true;
//   String? _selectedTemplateId;
//   String? _selectedTemplateName;
//   String? _selectedCategory;
//   String? _selectedCategoryCode;
//   File? _selectedImage;
//   DateTime? _selectedDateTime;
//   String? _selectedVisibilityCode;
//   bool _isLoading = false;

//   List<dynamic> _categories = [];
//   List<dynamic> _templates = [];
//   List<dynamic> _visibilityOptions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   Future<void> _loadInitialData() async {
//     try {
//       setState(() => _isLoading = true);
//       _categories = await NetworkService.getCategories();
//       _visibilityOptions = await NetworkService.getEventVisibilityOptions();

//       if (_visibilityOptions.isNotEmpty) {
//         _selectedVisibilityCode = _visibilityOptions.first['event_visibility_code'];
//       }

//       setState(() => _isLoading = false);
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showErrorSnackbar('Failed to load initial data: $e');
//     }
//   }

//   Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now().add(const Duration(days: 1)),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       if (_selectedDateTime != null) {
//         _selectedDateTime = DateTime(
//           picked.year,
//           picked.month,
//           picked.day,
//           _selectedDateTime!.hour,
//           _selectedDateTime!.minute,
//         );
//       } else {
//         _selectedDateTime = DateTime(
//           picked.year,
//           picked.month,
//           picked.day,
//         );
//       }
//       setState(() {});
//     }
//   }

//   Future<void> _selectTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       if (_selectedDateTime != null) {
//         _selectedDateTime = DateTime(
//           _selectedDateTime!.year,
//           _selectedDateTime!.month,
//           _selectedDateTime!.day,
//           picked.hour,
//           picked.minute,
//         );
//       } else {
//         final now = DateTime.now();
//         _selectedDateTime = DateTime(
//           now.year,
//           now.month,
//           now.day,
//           picked.hour,
//           picked.minute,
//         );
//       }
//       setState(() {});
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _selectedImage = File(image.path);
//       });
//     }
//   }

//   Future<void> _loadTemplates() async {
//     if (_selectedCategoryCode == null) {
//       setState(() {
//         _templates = [];
//       });
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _templates = [];
//       _selectedTemplateId = null;
//       _selectedTemplateName = null;
//     });
//     try {
//       final templates = await NetworkService.getTemplatesByCategory(_selectedCategoryCode!);
//       setState(() {
//         _templates = templates;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _templates = [];
//       });
//       _showErrorSnackbar('Failed to load templates: $e');
//     }
//   }

//   Future<void> _createEvent() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_selectedDateTime == null) {
//       _showErrorSnackbar("Please select date and time for your event.");
//       return;
//     }
//     if (_selectedCategoryCode == null || _selectedVisibilityCode == null) {
//       _showErrorSnackbar('Please select category and privacy settings.');
//       return;
//     }

//     try {
//       setState(() => _isLoading = true);

//       final result = await NetworkService.createEvent(
//         eventName: _titleController.text.trim(),
//         categoryCode: _selectedCategoryCode!,
//         eventDateTime: _selectedDateTime!,
//         location: _locationController.text.trim(),
//         description: _descriptionController.text.trim(),
//         visibilityCode: _selectedVisibilityCode!,
//         templateName: _useTemplate ? _selectedTemplateName : null,
//         imageFile: !_useTemplate ? _selectedImage : null,
//       );

//       setState(() => _isLoading = false);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(result['message'] ?? 'Event created successfully'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showErrorSnackbar('Failed to create event: $e');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

  
//   Widget _buildCategorySelector() {
//     return DropdownButtonFormField<String>(
//       value: _selectedCategory,
//       decoration: InputDecoration(
//         labelText: 'Select Category',
//         prefixIcon: const Icon(Icons.category),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         filled: true,
//         fillColor: Colors.grey[100],
//       ),
//       items: _categories.map<DropdownMenuItem<String>>((category) {
//         return DropdownMenuItem<String>(
//           value: category['category_name'],
//           child: Text(category['category_name']),
//           onTap: () {
//             _selectedCategoryCode = category['category_code'];
//             if (_useTemplate) {
//               _loadTemplates();
//             }
//           },
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           _selectedCategory = value;
//         });
//       },
//     );
//   }

//   Widget _buildTemplateSelector() {
//     if (_templates.isEmpty) {
//       return const Center(child: Text("No templates available."));
//     }
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: _templates.length,
//       itemBuilder: (context, index) {
//         final template = _templates[index];
// final selected = _selectedTemplateId == template['name'];
// return GestureDetector(
//   onTap: () {
//     setState(() {
//       _selectedTemplateId = template['name'];
//       _selectedTemplateName = template['name'];
//     });
//   },
//   child: Card(
//     elevation: selected ? 4 : 1,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//       side: BorderSide(
//         color: selected ? AppTheme.primaryColor : Colors.grey.shade300,
//         width: selected ? 2 : 1,
//       ),
//     ),
//     child: Column(
//       children: [
// Expanded(
//   child: ClipRRect(
//     borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//     child: Image.network(
//       template['image_url'], // Use the pre-constructed URL
//       fit: BoxFit.cover,
//       width: double.infinity,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//           child: CircularProgressIndicator(
//             value: loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded / 
//                   loadingProgress.expectedTotalBytes!
//                 : null,
//           ),
//         );
//       },
//       errorBuilder: (context, error, stackTrace) =>
//           const Center(child: Icon(Icons.broken_image)),
//     ),
//   ),
// ),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Text(
//             template['name']
//                 .replaceAll(RegExp(r'template', caseSensitive: false), 'Template ')
//                 .replaceAll(RegExp(r'[_\-]'), ' ')
//                 .toUpperCase(),
//             style: TextStyle(
//               fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//               color: selected ? AppTheme.primaryColor : Colors.black,
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );

//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       automaticallyImplyLeading: false, // ✅ removes the default back button
//         title: const Text("Create Event",
//         style: TextStyle(
//           fontFamily: 'Poppins', // ✅ Use Poppins family
//           fontWeight: FontWeight.w500, // ✅ Medium weight
//           fontSize: 24,
//           color: Colors.white,
//         ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: _isLoading && _categories.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 _useTemplate = true;
//                                 _selectedImage = null;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   _useTemplate ? AppTheme.primaryColor : Colors.grey,
//                             ),
//                             child: const Text("Use Template"),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 _useTemplate = false;
//                                 _selectedTemplateName = null;
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   !_useTemplate ? AppTheme.primaryColor : Colors.grey,
//                             ),
//                             child: const Text("Own Image"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     if (!_useTemplate) ...[
//                       _buildImageUploadSection(),
//                       const SizedBox(height: 16),
//                       _buildCategorySelector(),
//                     ],
//                     if (_useTemplate) ...[
//                       _buildCategorySelector(),
//                       const SizedBox(height: 16),
//                       if (_templates.isNotEmpty) _buildTemplateSelector(),
//                     ],
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(labelText: "Event Title"),
//                       validator: (value) =>
//                           value == null || value.isEmpty ? "Enter event title" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _locationController,
//                       decoration: const InputDecoration(labelText: "Location"),
//                       validator: (value) =>
//                           value == null || value.isEmpty ? "Enter location" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _descriptionController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(labelText: "Description"),
//                       validator: (value) =>
//                           value == null || value.isEmpty ? "Enter description" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.calendar_today),
//                             label: Text(_selectedDateTime == null
//                                 ? "Pick Date"
//                                 : DateFormat('MMM dd, yyyy').format(_selectedDateTime!)),
//                             onPressed: _selectDate,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: const Icon(Icons.access_time),
//                             label: Text(_selectedDateTime == null
//                                 ? "Pick Time"
//                                 : DateFormat('hh:mm a').format(_selectedDateTime!)),
//                             onPressed: _selectTime,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     // _buildVisibilitySelector(),
//                     // const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _createEvent,
//                         child: _isLoading
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text("Create Event"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildImageUploadSection() {
//     return GestureDetector(
//       onTap: _pickImage,
//       child: Container(
//         height: 200,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey),
//         ),
//         child: _selectedImage == null
//             ? const Center(child: Icon(Icons.add_photo_alternate, size: 50))
//             : ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(_selectedImage!, fit: BoxFit.cover),
//               ),
//       ),
//     );
//   }

// //   Widget _buildVisibilitySelector() {
// //   if (_visibilityOptions.isEmpty) return const SizedBox.shrink();

// //   return Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: _visibilityOptions.map((option) {
// //       final isPublic = option['event_visibility_code'] == 'EVS001';
// //       final icon = isPublic ? Icons.public : Icons.lock;
// //       final label = isPublic ? "PUBLIC" : "PRIVATE";

// //       return RadioListTile<String>(
// //         value: option['event_visibility_code'],
// //         groupValue: _selectedVisibilityCode,
// //         onChanged: (value) {
// //           setState(() {
// //             _selectedVisibilityCode = value;
// //           });
// //         },
// //         title: Row(
// //           children: [
// //             Icon(icon, color: AppTheme.primaryColor),
// //             const SizedBox(width: 8),
// //             Text(
// //               label,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //             ),
// //           ],
// //         ),
// //         subtitle: option['description'] != null && option['description'].isNotEmpty
// //             ? Text(option['description'])
// //             : null,
// //       );
// //     }).toList(),
// //   );
// // }

// }



//claude 14-5-25


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moments/network_service/network_service.dart';
import '../../utils/theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  bool _useTemplate = true;
  String? _selectedTemplateId;
  String? _selectedTemplateName;
  String? _selectedCategory;
  String? _selectedCategoryCode;
  File? _selectedImage;
  DateTime? _selectedDateTime;
  String? _selectedVisibilityCode;
  bool _isLoading = false;

  List<dynamic> _categories = [];
  List<dynamic> _templates = [];
  List<dynamic> _visibilityOptions = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadInitialData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() => _isLoading = true);
      _categories = await NetworkService.getCategories();
      _visibilityOptions = await NetworkService.getEventVisibilityOptions();

      if (_visibilityOptions.isNotEmpty) {
        _selectedVisibilityCode = _visibilityOptions.first['event_visibility_code'];
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Failed to load initial data: $e');
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (_selectedDateTime != null) {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime!.hour,
          _selectedDateTime!.minute,
        );
      } else {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      }
      setState(() {});
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (_selectedDateTime != null) {
        _selectedDateTime = DateTime(
          _selectedDateTime!.year,
          _selectedDateTime!.month,
          _selectedDateTime!.day,
          picked.hour,
          picked.minute,
        );
      } else {
        final now = DateTime.now();
        _selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
      }
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _loadTemplates() async {
    if (_selectedCategoryCode == null) {
      setState(() {
        _templates = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _templates = [];
      _selectedTemplateId = null;
      _selectedTemplateName = null;
    });
    try {
      final templates = await NetworkService.getTemplatesByCategory(_selectedCategoryCode!);
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _templates = [];
      });
      _showErrorSnackbar('Failed to load templates: $e');
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDateTime == null) {
      _showErrorSnackbar("Please select date and time for your event.");
      return;
    }
    if (_selectedCategoryCode == null || _selectedVisibilityCode == null) {
      _showErrorSnackbar('Please select category and privacy settings.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final result = await NetworkService.createEvent(
        eventName: _titleController.text.trim(),
        categoryCode: _selectedCategoryCode!,
        eventDateTime: _selectedDateTime!,
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        visibilityCode: _selectedVisibilityCode!,
        templateName: _useTemplate ? _selectedTemplateName : null,
        imageFile: !_useTemplate ? _selectedImage : null,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(result['message'] ?? 'Event created successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Failed to create event: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildCategorySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Choose Category',
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.category_outlined, 
                 color: AppTheme.primaryColor, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        items: _categories.map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem<String>(
            value: category['category_name'],
            child: Text(
              category['category_name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              _selectedCategoryCode = category['category_code'];
              if (_useTemplate) {
                _loadTemplates();
              }
            },
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
      ),
    );
  }

  Widget _buildTemplateSelector() {
    if (_templates.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, 
                   size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text("No templates available", 
                   style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        final selected = _selectedTemplateId == template['name'];
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTemplateId = template['name'];
              _selectedTemplateName = template['name'];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: selected 
                      ? AppTheme.primaryColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  spreadRadius: selected ? 2 : 1,
                  blurRadius: selected ? 15 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppTheme.primaryColor : Colors.grey[200]!,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      child: Stack(
                        children: [
                          Image.network(
                            template['image_url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppTheme.primaryColor,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(Icons.broken_image_outlined, 
                                     color: Colors.grey, size: 40),
                              ),
                            ),
                          ),
                          if (selected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.check, 
                                     color: Colors.white, size: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      template['name']
                          .replaceAll(RegExp(r'template', caseSensitive: false), 'Template ')
                          .replaceAll(RegExp(r'[_\-]'), ' ')
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                        color: selected ? AppTheme.primaryColor : Colors.black87,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Create Event",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading && _categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle buttons for template/custom image
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _useTemplate = true;
                                    _selectedImage = null;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _useTemplate 
                                        ? AppTheme.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.view_module_outlined,
                                        color: _useTemplate ? Colors.white : Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Use Template",
                                        style: TextStyle(
                                          color: _useTemplate ? Colors.white : Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _useTemplate = false;
                                    _selectedTemplateName = null;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: !_useTemplate 
                                        ? AppTheme.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: !_useTemplate ? Colors.white : Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Own Image",
                                        style: TextStyle(
                                          color: !_useTemplate ? Colors.white : Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (!_useTemplate) ...[
                        _buildImageUploadSection(),
                        const SizedBox(height: 20),
                        _buildCategorySelector(),
                      ],
                      if (_useTemplate) ...[
                        _buildCategorySelector(),
                        const SizedBox(height: 20),
                        if (_templates.isNotEmpty) _buildTemplateSelector(),
                      ],
                      const SizedBox(height: 20),

                      _buildModernTextField(
                        controller: _titleController,
                        label: "Event Title",
                        icon: Icons.event_outlined,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Enter event title" : null,
                      ),
                      const SizedBox(height: 16),

                      _buildModernTextField(
                        controller: _locationController,
                        label: "Location",
                        icon: Icons.location_on_outlined,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Enter location" : null,
                      ),
                      const SizedBox(height: 16),

                      _buildModernTextField(
                        controller: _descriptionController,
                        label: "Description",
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.isEmpty ? "Enter description" : null,
                      ),
                      const SizedBox(height: 20),

                      // Date and Time Selection
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.calendar_today_outlined, 
                                           color: AppTheme.primaryColor, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _selectedDateTime == null
                                              ? "Select Date"
                                              : DateFormat('MMM dd, yyyy').format(_selectedDateTime!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.access_time_outlined, 
                                           color: AppTheme.primaryColor, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Time",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _selectedDateTime == null
                                              ? "Select Time"
                                              : DateFormat('hh:mm a').format(_selectedDateTime!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
// Add this above the Create Event Button
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: DropdownButtonFormField<String>(
    value: _selectedVisibilityCode,
    decoration: InputDecoration(
      labelText: 'Event Privacy',
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      prefixIcon: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.visibility_outlined, 
             color: AppTheme.primaryColor, size: 20),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    items: _visibilityOptions.map<DropdownMenuItem<String>>((option) {
      return DropdownMenuItem<String>(
        value: option['event_visibility_code'],
        child: Text(
          option['event_visibility_name'] ?? 'Unknown',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedVisibilityCode = value;
      });
    },
    validator: (value) {
      if (value == null) {
        return 'Please select privacy setting';
      }
      return null;
    },
  ),
),
const SizedBox(height: 20),

                      // Create Event Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_circle_outline, 
                                         color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "Create Event",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImageUploadSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedImage != null 
                ? AppTheme.primaryColor 
                : Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tap to add image",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose from gallery",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
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