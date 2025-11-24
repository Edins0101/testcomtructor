import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    this.numberRequest,
    this.type,
    this.price,
    this.stock,
    this.icon,
    this.onTap,
  });

  final String? numberRequest;
  final String? type;
  final String? price;
  final String? stock;
  final IconData? icon;
  final Function()? onTap;

  bool _isOutOfStock() {
    if (stock == null) return false;

    final s = stock!.toLowerCase();
    return s.contains("agotado") || s == "0" || s.contains("stock: 0");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double cardHeight = size.height * 0.13;
    final double iconBoxWidth = size.width * 0.18;
    final double iconSize = size.width * 0.10;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 6,
      shadowColor: AppTheme.gray,
      color: AppTheme.white,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: cardHeight,
          child: Row(
            children: [
              Container(
                width: iconBoxWidth,
                decoration: BoxDecoration(
                  color: AppTheme.primaryDarkest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon ?? Icons.construction,
                    color: AppTheme.white,
                    size: iconSize,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TitleWidget(
                              title: numberRequest ?? '---',
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          if (stock != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: _isOutOfStock()
                                    ? Colors.red.shade50
                                    : Colors.yellow.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextWidget(
                                title: stock!,
                                fontSize: size.width * 0.03,
                                color: _isOutOfStock()
                                    ? Colors.red.shade700
                                    : Colors.orange.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      if (type != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.02,
                            vertical: size.height * 0.004,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.gray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextWidget(
                            title: type!,
                            fontSize: size.width * 0.03,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      if (price != null)
                        TextWidget(
                          title: price!,
                          fontSize: size.width * 0.045,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                    ],
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
