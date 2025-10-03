// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/screens/events/my_events_screen.dart';

// class EditEventPage extends StatefulWidget {
//   final EventModel event;

//   const EditEventPage({super.key, required this.event});

//   @override
//   // ignore: library_private_types_in_public_api
//   _EditEventPageState createState() => _EditEventPageState();
// }

// class _EditEventPageState extends State<EditEventPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _dateController;
//   late TextEditingController _timeController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   late String _category;
//   late String _visibility;
//   File? _imageFile;
//   bool _isLoading = false;

//   final List<String> _categories = ['Birthday', 'Wedding', 'Anniversary', 'Party', 'Other'];
//   final List<String> _visibilities = ['Public', 'Private', 'Friends Only'];

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.event.title);
//     _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.event.date));
//     _timeController = TextEditingController(text: widget.event.time);
//     _locationController = TextEditingController(text: widget.event.location ?? '');
//     _descriptionController = TextEditingController(text: widget.event.description);
//     _category = widget.event.category;
//     _visibility = widget.event.visibilityName ?? 'Public';
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _dateController.dispose();
//     _timeController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() { 
//       _isLoading = true;
//     });

//     try {
//       final updatedEvent = await NetworkService.editEvent(
//         eventToken: widget.event.eventToken,
//         title: _titleController.text,
//         date: DateTime.parse(_dateController.text),
//         time: _timeController.text,
//         description: _descriptionController.text,
//         categoryCode: _category.toUpperCase().replaceAll(' ', '_'),
//         visibilityCode: _visibility.toUpperCase().replaceAll(' ', '_'),
//         location: _locationController.text,
//         imageFile: _imageFile,
//       );

//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update event: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.parse(_dateController.text),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(
//         DateFormat('HH:mm').parse(_timeController.text),
//       ),
//     );
//     if (picked != null) {
//       setState(() {
//         _timeController.text = picked.format(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Event'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _isLoading ? null : _submitForm,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const LoadingIndicator()
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: Container(
//                         height: 200,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                           image: _imageFile != null
//                               ? DecorationImage(
//                                   image: FileImage(_imageFile!),
//                                   fit: BoxFit.cover,
//                                 )
//                               : widget.event.imageUrl != null &&
//                                       widget.event.imageUrl!.isNotEmpty
//                                   ? DecorationImage(
//                                       image: NetworkImage(widget.event.fullImageUrl),
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                         ),
//                         child: _imageFile == null &&
//                                 (widget.event.imageUrl == null ||
//                                     widget.event.imageUrl!.isEmpty)
//                             ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add_a_photo, size: 48),
//                                   Text('Add Event Image'),
//                                 ],
//                               )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(
//                         labelText: 'Event Title',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a title';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _dateController,
//                       decoration: InputDecoration(
//                         labelText: 'Date',
//                         border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.calendar_today),
//                           onPressed: () => _selectDate(context),
//                         ),
//                       ),
//                       readOnly: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a date';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _timeController,
//                       decoration: InputDecoration(
//                         labelText: 'Time',
//                         border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.access_time),
//                           onPressed: () => _selectTime(context),
//                         ),
//                       ),
//                       readOnly: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a time';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _category,
//                       decoration: const InputDecoration(
//                         labelText: 'Category',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: _categories.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _category = value!;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a category';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _visibility,
//                       decoration: const InputDecoration(
//                         labelText: 'Visibility',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: _visibilities.map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _visibility = value!;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select visibility';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _locationController,
//                       decoration: const InputDecoration(
//                         labelText: 'Location (Optional)',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         labelText: 'Description (Optional)',
//                         border: OutlineInputBorder(),
//                       ),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitForm,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text('Save Changes'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
















// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';

// class EditEventPage extends StatefulWidget {
//   final EventModel event;

//   const EditEventPage({super.key, required this.event});

//   @override
//   _EditEventPageState createState() => _EditEventPageState();
// }

// class _EditEventPageState extends State<EditEventPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _dateController;
//   late TextEditingController _timeController;
//   late TextEditingController _locationController;
//   late TextEditingController _descriptionController;
//   String? _category;
//   String? _visibility;
//   File? _imageFile;
//   bool _isLoading = false;
//   bool _isFetchingMaster = true;

//   List<String> _categories = [];
//   List<String> _visibilities = [];

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.event.title);
//     _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.event.date));
//     _timeController = TextEditingController(text: widget.event.time);
//     _locationController = TextEditingController(text: widget.event.location ?? '');
//     _descriptionController = TextEditingController(text: widget.event.description);
//     _category = widget.event.category;
//     _visibility = widget.event.visibilityName?.toLowerCase().replaceAll(' ', '_') ?? 'public';

//     _loadMasterData();
//   }

//   Future<void> _loadMasterData() async {
//     try {
//       final categoriesData = await NetworkService.getCategories();
//       final visibilitiesData = await NetworkService.getEventVisibilityOptions();

//       final fetchedCategories = categoriesData.map<String>((e) => e['category_name'] as String).toList();
//       final fetchedVisibilities = visibilitiesData.map<String>((e) => e['visibility_code'] as String).toList();

//       setState(() {
//         _categories = fetchedCategories;
//         _visibilities = fetchedVisibilities;

//         if (!_categories.contains(_category)) {
//           _category = _categories.isNotEmpty ? _categories.first : null;
//         }
//         if (!_visibilities.contains(_visibility)) {
//           _visibility = _visibilities.isNotEmpty ? _visibilities.first : 'public';
//         }
//         _isFetchingMaster = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading master data: $e");
//       if (mounted) {
//         setState(() {
//           _isFetchingMaster = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _dateController.dispose();
//     _timeController.dispose();
//     _locationController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await NetworkService.editEvent(
//         eventToken: widget.event.eventToken,
//         title: _titleController.text,
//         date: DateTime.parse(_dateController.text),
//         time: _timeController.text,
//         description: _descriptionController.text,
//         categoryCode: _category!.toUpperCase().replaceAll(' ', '_'),
//         visibilityCode: _visibility!.toUpperCase().replaceAll(' ', '_'),
//         location: _locationController.text,
//         imageFile: _imageFile,
//       );
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update event: $e')),
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.parse(_dateController.text),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(
//         DateFormat('HH:mm').parse(_timeController.text),
//       ),
//     );
//     if (picked != null) {
//       setState(() {
//         _timeController.text = picked.format(context);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isFetchingMaster) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Event'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _isLoading ? null : _submitForm,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: Container(
//                         height: 200,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                           image: _imageFile != null
//                               ? DecorationImage(
//                                   image: FileImage(_imageFile!),
//                                   fit: BoxFit.cover,
//                                 )
//                               : widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty
//                                   ? DecorationImage(
//                                       image: NetworkImage(widget.event.fullImageUrl),
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                         ),
//                         child: _imageFile == null &&
//                                 (widget.event.imageUrl == null || widget.event.imageUrl!.isEmpty)
//                             ? const Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add_a_photo, size: 48),
//                                   Text('Add Event Image'),
//                                 ],
//                               )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _titleController,
//                       decoration: const InputDecoration(
//                         labelText: 'Event Title',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _dateController,
//                       decoration: InputDecoration(
//                         labelText: 'Date',
//                         border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.calendar_today),
//                           onPressed: () => _selectDate(context),
//                         ),
//                       ),
//                       readOnly: true,
//                       validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _timeController,
//                       decoration: InputDecoration(
//                         labelText: 'Time',
//                         border: const OutlineInputBorder(),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.access_time),
//                           onPressed: () => _selectTime(context),
//                         ),
//                       ),
//                       readOnly: true,
//                       validator: (value) => value == null || value.isEmpty ? 'Please select a time' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _category,
//                       decoration: const InputDecoration(
//                         labelText: 'Category',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
//                       onChanged: (val) => setState(() => _category = val),
//                       validator: (value) => value == null || value.isEmpty ? 'Please select a category' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _visibility,
//                       decoration: const InputDecoration(
//                         labelText: 'Visibility',
//                         border: OutlineInputBorder(),
//                       ),
//                       items: _visibilities
//                           .map((v) => DropdownMenuItem(value: v, child: Text(v.replaceAll('_', ' ').toUpperCase())))
//                           .toList(),
//                       onChanged: (val) => setState(() => _visibility = val),
//                       validator: (value) => value == null || value.isEmpty ? 'Please select visibility' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _locationController,
//                       decoration: const InputDecoration(
//                         labelText: 'Location (Optional)',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration: const InputDecoration(
//                         labelText: 'Description (Optional)',
//                         border: OutlineInputBorder(),
//                       ),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitForm,
//                         style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
//                         child: const Text('Save Changes'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }












import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import '../../utils/theme.dart';

class EditEventPage extends StatefulWidget {
  final EventModel event;

  const EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  String? _selectedCategoryName;
  String? _selectedCategoryCode;
  String? _selectedVisibilityCode;
  File? _imageFile;

  bool _isLoading = false;
  bool _isFetchingMaster = true;

  List<dynamic> _categories = [];
  List<dynamic> _visibilityOptions = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.event.date));
    _timeController = TextEditingController(text: widget.event.time);
    _locationController = TextEditingController(text: widget.event.location ?? '');
    _descriptionController = TextEditingController(text: widget.event.description);

    _loadMasterData();
  }

  Future<void> _loadMasterData() async {
    try {
      final categoriesData = await NetworkService.getCategories();
      final visibilityData = await NetworkService.getEventVisibilityOptions();

      setState(() {
        _categories = categoriesData;
        _visibilityOptions = visibilityData;

        final matchedCategory = _categories.firstWhere(
          (c) => c['category_name'] == widget.event.category,
          orElse: () => _categories.isNotEmpty ? _categories.first : null,
        );
        _selectedCategoryName = matchedCategory != null ? matchedCategory['category_name'] : null;
        _selectedCategoryCode = matchedCategory != null ? matchedCategory['category_code'] : null;

        final matchedVisibility = _visibilityOptions.firstWhere(
          (v) => v['event_visibility_name'].toLowerCase() == (widget.event.visibilityName ?? '').toLowerCase(),
          orElse: () => _visibilityOptions.isNotEmpty ? _visibilityOptions.first : null,
        );
        _selectedVisibilityCode = matchedVisibility != null ? matchedVisibility['event_visibility_code'] : null;

        _isFetchingMaster = false;
      });
    } catch (e) {
      debugPrint("Error loading master data: $e");
      setState(() => _isFetchingMaster = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await NetworkService.editEvent(
        eventToken: widget.event.eventToken,
        title: _titleController.text.trim(),
        date: DateTime.parse(_dateController.text),
        time: _timeController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryCode: _selectedCategoryCode ?? '',
        visibilityCode: _selectedVisibilityCode ?? '',
        location: _locationController.text.trim(),
        imageFile: _imageFile,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // ignore: use_build_context_synchronously
      final formattedTime = picked.format(context);
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryName,
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
      items: _categories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category['category_name'],
          child: Text(category['category_name']),
          onTap: () {
            _selectedCategoryCode = category['category_code'];
          },
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategoryName = value;
        });
      },
      validator: (value) => value == null || value.isEmpty ? 'Please select a category' : null,
    );
  }

  Widget _buildVisibilitySelector() {
    if (_visibilityOptions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _visibilityOptions.map((option) {
        final isPublic = option['event_visibility_code'] == 'EVS001';
        final icon = isPublic ? Icons.public : Icons.lock;
        final label = isPublic ? "PUBLIC" : "PRIVATE";

        return RadioListTile<String>(
          value: option['event_visibility_code'],
          groupValue: _selectedVisibilityCode,
          onChanged: (value) {
            setState(() {
              _selectedVisibilityCode = value;
            });
          },
          title: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          subtitle: option['description'] != null && option['description'].isNotEmpty
              ? Text(option['description'])
              : null,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetchingMaster) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: _imageFile != null
                              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                              : (widget.event.imageUrl != null && widget.event.imageUrl!.isNotEmpty)
                                  ? DecorationImage(image: NetworkImage(widget.event.fullImageUrl), fit: BoxFit.cover)
                                  : null,
                        ),
                        child: _imageFile == null && (widget.event.imageUrl == null || widget.event.imageUrl!.isEmpty)
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo, size: 48),
                                    Text('Add Event Image'),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Event Title', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: _selectDate),
                      ),
                      readOnly: true,
                      validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(icon: const Icon(Icons.access_time), onPressed: _selectTime),
                      ),
                      readOnly: true,
                      validator: (value) => value == null || value.isEmpty ? 'Please select a time' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildCategorySelector(),
                    const SizedBox(height: 16),
                    _buildVisibilitySelector(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location (Optional)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
