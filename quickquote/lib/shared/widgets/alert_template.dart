import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';

class AlertTemplate extends StatefulWidget {
  final Widget content;
  final GlobalKey keyToClose;
  final bool? dismissAlert;
  final bool? animation;
  final double? padding;

  const AlertTemplate(
      {super.key,
      required this.content,
      required this.keyToClose,
      this.dismissAlert = false,
      this.animation = true,
      this.padding = 20});

  @override
  State<AlertTemplate> createState() => _AlertTemplateState();
}

class _AlertTemplateState extends State<AlertTemplate> {
  late GlobalKey keySummoner;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomOut(
        animate: false,
        duration: const Duration(milliseconds: 200),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(148, 0, 0, 0),
          body: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  final fp =
                      Provider.of<FunctionalProvider>(context, listen: false);
                  widget.dismissAlert == true
                      ? fp.dismissAlert(key: widget.keyToClose)
                      : null;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              Container(
                padding: EdgeInsets.all(widget.padding ?? 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.animation == true
                            ? FadeInUpBig(
                                animate: true,
                                controller: (controller) {},
                                duration: const Duration(milliseconds: 300),
                                child: widget.content)
                            : widget.content,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}