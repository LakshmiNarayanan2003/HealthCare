import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:health/src/theme/light_color.dart';
import 'package:health/src/theme/theme.dart';

class ProgressWidget extends StatefulWidget {
  ProgressWidget(
      {Key key,
      this.value,
      this.totalValue = 100,
      this.activeColor,
      this.backgroundColor,
      this.title,
      this.durationTime,
      this.rating})
      : super(key: key);
  final double totalValue;
  final double rating;
  final double value;
  final Color activeColor;
  final Color backgroundColor;
  final String title;
  final durationTime;
  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with TickerProviderStateMixin {
  double progress;
  Color activeColor;
  Color backgroundColor;
  @override
  void initState() {
    progress = (widget.value * 100) / widget.totalValue;
    progress = (progress / 100) * 360;
    activeColor = widget.activeColor;
    backgroundColor = widget.backgroundColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dimenstion = (AppTheme.fullWidth(context) - 10) * .3;
    if (activeColor == null) {
      activeColor = Theme.of(context).primaryColor;
    }
    if (backgroundColor == null) {
      backgroundColor = Theme.of(context).disabledColor;
    }
    final inCurve = ElasticOutCurve(0.38);
    Widget _start(int index) {
      bool halfStar = false;
      if ((widget.rating * 2) % 2 != 0) {
        if (index < widget.rating && index == widget.rating - .5) {
          halfStar = true;
        }
      }

      return Icon(halfStar ? Icons.star_half : Icons.star,
          color: index < widget.rating ? LightColor.orange : LightColor.grey);
    }

    return Container(
      height: dimenstion,
      width: dimenstion,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 5),
            duration: Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Wrap(
                  children:
                      Iterable.generate(value.toInt(), (index) => _start(index))
                          .toList());
            },
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double value;
  final Color activeColor;
  final Color backgroundColor;

  ProgressPainter(this.value, this.activeColor, this.backgroundColor);
  @override
  void paint(Canvas canvas, Size size) async {
    var center1 = Offset(size.width / 2, size.height / 2);
    Paint active = new Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;

    Paint inActive = new Paint()
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawArc(
        Rect.fromCircle(center: center1, radius: 40), 0, 180, false, inActive);

    canvas.drawArc(Rect.fromCircle(center: center1, radius: 40), -90 * pi / 180,
        value * pi / 180, false, active);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LinearPointCurve extends Curve {
  final double pIn;
  final double pOut;

  LinearPointCurve(this.pIn, this.pOut);

  @override
  double transform(double x) {
    // Just a simple bit of linear interpolation math
    final lowerScale = pOut / pIn;
    final upperScale = (1.0 - pOut) / (1.0 - pIn);
    final upperOffset = 1.0 - upperScale;
    return x < pIn ? x * lowerScale : x * upperScale + upperOffset;
  }
}
