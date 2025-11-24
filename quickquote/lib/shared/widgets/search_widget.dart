import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.onFilter,
  });

  final Function(String) onFilter;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onFilter,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                size: 35,
              ),
              onPressed: () {
                widget.onFilter;
              },
            ),
            enabledBorder: InputBorder.none,
            hintText: 'Buscar...',
          ),
        ),
      ),
    );
  }
}
