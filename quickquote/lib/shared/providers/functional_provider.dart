import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/widgets/alert_template.dart';

class FunctionalProvider extends ChangeNotifier {
  List<Widget> alerts = [];
  List<Widget> pages = [];
  String? currentPage;
  ScrollController scrollController = ScrollController();
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    if (currentIndex == index) return; // si es el mismo, no hago nada
    currentIndex = index;
    notifyListeners();
  }

  void showAlert({
    required GlobalKey key,
    required Widget content,
    bool closeAlert = false,
    bool animation = true,
    double padding = 20,
  }) {
    final newAlert = Container(
      key: key,
      color: AppTheme.transparent,
      child: AlertTemplate(
        content: content,
        keyToClose: key,
        dismissAlert: closeAlert,
        animation: animation,
        padding: padding,
      ),
    );

    alerts.add(newAlert);

    notifyListeners();
  }

  void addPage({required GlobalKey key, required Widget content}) {
    // opcional: evitar duplicar por key
    if (pages.any((p) => p.key == key)) return;

    currentPage = content.runtimeType.toString();
    pages.add(content);
    notifyListeners();
  }

  void dismissPage({required GlobalKey key}) {
    pages.removeWhere((page) => key == page.key);
    // currentPage = '';
    notifyListeners();
  }

  void dismissAlert({required GlobalKey key}) {
    alerts.removeWhere((alert) => key == alert.key);
    notifyListeners();
  }

  void dismissLastPage() {
    pages.removeLast();
    notifyListeners();
  }

  void clearAllAlert() {
    alerts = [];
    notifyListeners();
  }

  void clearAllPages() {
    pages = [];
    notifyListeners();
  }

  bool isCurrentPage(String pageName) {
    return currentPage == pageName;
  }

  void moveToHome() {
    currentPage = '';
    pages.clear();
    notifyListeners();
  }
}
