import 'package:flutter/material.dart';
import '../util/dimensions.dart';
import '../util/styles.dart';

class RatingBar extends StatelessWidget {
  final double? rating;
  final double size;
  final int? ratingCount;
  final Color? starColor;
  final Color? unSeletedStar;

  const RatingBar({
    super.key,
    required this.rating,
    required this.ratingCount,
    this.size = 18,
    this.starColor = Colors.orange,
    this.unSeletedStar = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    int realNumber = rating!.floor();
    int partNumber = ((rating! - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        starList.add(Icon(Icons.star, color: starColor, size: size));
      } else if (i == realNumber) {
        starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(Icons.star, color: starColor, size: size),
              // ClipRect(
              //   clipper: _Clipper(part: partNumber),
              //   child: Icon(Icons.star_border_purple500_outlined, color: Colors.grey, size: size),
              // ),
            ],
          ),
        ));
      } else {
        starList.add(Icon(Icons.star_border, color: unSeletedStar, size: size,));
      }
    }

    if (ratingCount != null) {
      starList.add(Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
        child: Text(
          '($ratingCount)',
          style: robotoRegular.copyWith(fontSize: size * 0.8, color: starColor),
          textDirection: TextDirection.ltr,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: starList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;

  _Clipper({required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      (size.width / 10) * part,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
