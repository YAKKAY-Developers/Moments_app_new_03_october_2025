import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Update FCM token on every app launch
      await _updateFcmToken();

      final token = await NetworkService.getUserToken();
      if (token != null) {
        // Try to get user data - if successful, token is still valid
        final response = await NetworkService.getUser(token);
        _user = UserModel.fromMap(response['data']);

                // Ensure FCM token is updated on server for existing users
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? fcmToken = prefs.getString('fcmToken');
        if (fcmToken != null) {
          await NetworkService.updateFcmToken(token, fcmToken);
        }
      }
    } catch (e) {
      await _clearAuthData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token");

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', token);
        
        // Also update the token on server if user is logged in
        if (_user != null) {
          await NetworkService.updateFcmToken(_user!.userToken, token);
        }
      }
    } catch (e) {
      debugPrint("Error updating FCM token: $e");
    }
  }

  Future<void> _clearAuthData() async {
    _user = null;
    _errorMessage = null;
    await NetworkService.removeUserToken();
    // notifyListeners();
  }
  
  Future<void> signUp({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String fcmToken,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await NetworkService.signUp(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        fcmToken: fcmToken,
      );

      _user = UserModel.fromMap(response['data']);
      await NetworkService.saveUserToken(_user!.userToken);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

    // Add this new method to handle token refresh
  Future<void> refreshFcmToken() async {
    await _updateFcmToken();
  }


  Future<void> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await NetworkService.signIn(
        phoneNumber: phoneNumber,
        password: password,
      );

      _user = UserModel.fromMap(response['data']);
      await NetworkService.saveUserToken(_user!.userToken);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchUser() async {
    try {
      if (_user == null) return;

      _isLoading = true;
      notifyListeners();

      final response = await NetworkService.getUser(_user!.userToken);
      _user = UserModel.fromMap(response['data']);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    int? age,
    File? imageFile,
  }) async {
    try {
      if (_user == null) return;

      _isLoading = true;
      notifyListeners();

      final response = await NetworkService.updateUser(
        userToken: _user!.userToken,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        age: age,
        imageFile: imageFile,
      );

      _user = UserModel.fromMap(response['data']);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

Future<void> signOut() async {
  _isLoading = true;
  notifyListeners();

  try {
    final token = await NetworkService.getUserToken();
    if (token != null) {
      await NetworkService.signOut(token);
    }
  } catch (e) {
    debugPrint('Error during sign out: $e');
  } finally {
    await _clearAuthData();
    _isLoading = false;
    notifyListeners();
  }
}


// Future<void> signOut() async {
//   _isLoading = true;
//   notifyListeners();

//   try {
//     final token = await NetworkService.getUserToken();
//     if (token != null) {
//       await NetworkService.signOut(token);
//     }
//   } catch (e) {
//     debugPrint('Error during sign out: $e');
//   } finally {
//     // Ensure cleanup happens even if API fails
//     await _clearAuthData();
//     _isLoading = false;
//     notifyListeners();
//   }
// }

Future<void> deleteAccount() async {
  _isLoading = true;
  notifyListeners();

  try {
    if (_user != null) {
      await NetworkService.deleteUser(_user!.userToken);
    }
  } catch (e) {
    _errorMessage = e.toString().replaceAll('Exception: ', '');
    notifyListeners();
    rethrow;
  } finally {
    await _clearAuthData();
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> removeProfilePhoto() async {
  try {
    if (_user == null) {
      throw Exception('No user logged in');
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await NetworkService.removeProfilePhoto(_user!.userToken);
    
    // Update local user data with complete user information
    _user = UserModel.fromMap(response['data']);
    
    _isLoading = false;
    notifyListeners();
    
  } catch (e) {
    _isLoading = false;
    _errorMessage = e.toString().replaceAll('Exception: ', '');
    notifyListeners();
    rethrow;
  }
}
}