import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class GlobalHelper {
  static void navigateToPageRemove(BuildContext context, String routeName) {
    final route = AppRoutes.routes[routeName];
    final page = route!.call(context);
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation, _) =>
            FadeTransition(opacity: animation, child: page),
      ),
      (route) => false,
    );
  }

  static Route navigationFadeIn(BuildContext context, Widget page) {
    return PageRouteBuilder(
      fullscreenDialog: true,
      reverseTransitionDuration: const Duration(milliseconds: 100),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: page);
      },
    );
  }

  static GlobalKey genKey() {
    GlobalKey key = GlobalKey();
    return key;
  }

  static String device = (Platform.isAndroid) ? "android" : "ios";

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String regexForNames() {
    return r'[A-Za-zÁÉÍÓÚáéíóúÜüÑñ ]';
  }

  static String? validateTextForm(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo no puede estar vacio';
    }
    return null;
  }

  String firstWord(String text) {
    if (text.trim().isEmpty) return '';
    final words = text.trim().split(RegExp(r'\s+'));
    return words.isNotEmpty ? words.first : '';
  }
}
