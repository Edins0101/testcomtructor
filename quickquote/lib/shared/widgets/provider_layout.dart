import 'package:animate_do/animate_do.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/helpers/global_helper.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/widgets/alert_modal.dart';
import 'package:quickquote/shared/widgets/page_modal.dart';
import 'package:quickquote/shared/widgets/text.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final IconData? icon;
  final String? nameInterceptor;
  final bool? backPageView;
  final bool requiredStack;
  final bool haveLogoCenter;
  final GlobalKey<State<StatefulWidget>>? keyDismiss;
  final String? title;
  final String? subtitle;
  final bool? isMessageWelcome;
  final bool isHomePage;
  final bool? isVerificationModule;
  final bool? isMenuPage;
  final bool? haveFooterLogo;
  final bool? isRegister;
  final bool showBottomNavBar;
  final void Function()? actionToBack;
  final Future<void> Function()? onRefresh;
  final bool? isSosPage;

  const MainLayout({
    super.key,
    required this.child,
    this.nameInterceptor,
    this.keyDismiss,
    this.requiredStack = true,
    this.haveLogoCenter = false,
    this.backPageView = false,
    this.title = '',
    this.subtitle,
    this.haveFooterLogo = true,
    this.actionToBack,
    this.isHomePage = false,
    this.isMenuPage = false,
    this.isMessageWelcome = true,
    this.isVerificationModule = false,
    this.isRegister = false,
    this.onRefresh,
    this.showBottomNavBar = false,
    this.icon,
    this.isSosPage = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  ScrollController _scrollController = ScrollController();
  bool alertModalBool = true;
  final keyModalProfile = GlobalHelper.genKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController = ScrollController();
      BackButtonInterceptor.add(
        _backButton,
        name: widget.nameInterceptor,
        context: context,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_backButton);
    alertModalBool = false;
    super.dispose();
  }

  Future<bool> _backButton(bool button, RouteInfo info) async {
    if (mounted) {
      final fp = Provider.of<FunctionalProvider>(context, listen: false);
      if (widget.nameInterceptor == null) {
        if (widget.keyDismiss == null) return false;
        if (fp.pages.isNotEmpty || (fp.pages.last.key != widget.keyDismiss)) {
          return false;
        }
        null;
        return true;
      } else {
        if (widget.requiredStack) {
          if (button) return false;
          if (fp.pages.isNotEmpty) {
            if (widget.keyDismiss != null) {
              fp.dismissPage(key: widget.keyDismiss!);
              return true;
            }
          }
        }

        if (!button) {
          if (widget.keyDismiss != null) {
            fp.dismissPage(key: widget.keyDismiss!);
          }
        }

        if (button) return false;

        setState(() {});
      }
      return true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fp = Provider.of<FunctionalProvider>(context, listen: false);
    // final nvp = Provider.of<NavegationVerifyProvider>(context, listen: true);

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Container(
        decoration: widget.isSosPage!
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFED4C5C), Color(0xFF1F41BB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              )
            : null,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: widget.isSosPage!
              ? AppTheme.transparent
              : AppTheme.white,
          body: Stack(
            children: [
              RefreshIndicator(
                displacement: 50,
                backgroundColor: AppTheme.white,
                color: AppTheme.primaryDarkest,
                notificationPredicate: widget.onRefresh != null
                    ? (_) => true
                    : (_) => false,
                onRefresh: widget.onRefresh ?? () async {},
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: widget.onRefresh != null
                      ? const AlwaysScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  slivers: [
                    SliverVisibility(
                      visible: !widget.isHomePage,
                      sliver: SliverAppBar(
                        surfaceTintColor: AppTheme.white,
                        leading:
                            // !widget.isHomePage
                            //     ?
                            Visibility(
                              visible: widget.backPageView!,
                              child: InkWell(
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppTheme.black,
                                ),
                                onTap: () {
                                  widget.actionToBack != null
                                      ? widget.actionToBack!()
                                      : widget.keyDismiss != null
                                      ? fp.dismissPage(key: widget.keyDismiss!)
                                      : Navigator.pop(context);

                                  setState(() {});
                                },
                              ),
                            ),
                        // : InkWell(
                        //     child: const Icon(
                        //       Icons.logout,
                        //       color: AppTheme.white,
                        //       // size: responsive.dp(2.5),
                        //     ),
                        //     onTap: () => _modalSessionClose(),
                        //   ),
                        toolbarHeight: widget.haveLogoCenter
                            ? size.height * 0.25
                            : widget.isHomePage || widget.isMenuPage!
                            ? widget.subtitle != null
                                  ? size.height * 0.1
                                  : size.height * 0.08
                            : size.height * 0.08,
                        snap: false,
                        pinned: true,
                        forceElevated: true,
                        automaticallyImplyLeading: false,
                        floating: false,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(0),
                          ),
                        ),
                        backgroundColor: AppTheme.primaryDarkest,
                        centerTitle: false,
                        title: Padding(
                          padding: EdgeInsets.only(
                            bottom: widget.haveLogoCenter ? 50 : 0,
                          ),
                          child: Row(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .start,
                            children: [
                              // Visibility(
                              //   visible: widget.icon != null,
                              //   child: Icon(widget.icon, size: 35),
                              // ),
                              // const SizedBox(width: 10),
                              TextWidget(
                                title: widget.title!,
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: PopScope(canPop: false, child: widget.child),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showBottomNavBar)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomNavigationBar(
                    currentIndex: 0,
                    onTap: (index) {
                      switch (index) {
                        case 0:
                          fp.clearAllPages();
                          break;
                        // case 1:
                        //   final MyRequestsPageKey = GlobalHelper.genKey();
                        //   fp.addPage(
                        //     key: MyRequestsPageKey,
                        //     content: MyRequestsPage(
                        //       globalKey: MyRequestsPageKey,
                        //     ),
                        //   );
                        //   break;
                      }
                    },
                    backgroundColor: AppTheme.white,
                    selectedItemColor: AppTheme.primaryDarkest,
                    unselectedItemColor: Colors.grey,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_cart_outlined),
                        label: 'Inicio',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.inventory_rounded),
                        label: 'Mis cotizaciones',
                      ),
                    ],
                  ),
                ),
              if (widget.requiredStack) const PageModal(),
              if (widget.requiredStack) const AlertModal(),
            ],
          ),
        ),
      ),
    );
  }
}
