import 'package:flutter/material.dart';

import 'dismiss_keyboard.dart';
import 'raw_pip_view.dart';

class PIPView extends StatefulWidget {
  final PIPViewCorner initialCorner;
  final double? floatingWidth;
  final double? floatingHeight;
  final bool avoidKeyboard;
  final Curve releaseCurve;
  final double pipWindowBorderRadius;
  final double pipWindowEdgeSpacing;
  final bool isFreeFlowing;
  final Widget Function(
    BuildContext context,
    bool isFloating,
  ) builder;

  const PIPView({
    Key? key,
    required this.builder,
    this.initialCorner = PIPViewCorner.topRight,
    this.floatingWidth,
    this.floatingHeight,
    this.avoidKeyboard = true,
    this.releaseCurve = Curves.easeInOutQuad,
    this.pipWindowBorderRadius = 10,
    this.pipWindowEdgeSpacing = 16,
    this.isFreeFlowing = false,
  }) : super(key: key);

  @override
  PIPViewState createState() => PIPViewState();

  static PIPViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<PIPViewState>();
  }
}

class PIPViewState extends State<PIPView> with TickerProviderStateMixin {
  Widget? _bottomWidget;

  void presentBelow(Widget widget) {
    dismissKeyboard(context);
    setState(() => _bottomWidget = widget);
  }

  void stopFloating() {
    dismissKeyboard(context);
    setState(() => _bottomWidget = null);
  }

  @override
  Widget build(BuildContext context) {
    final isFloating = _bottomWidget != null;
    return RawPIPView(
      avoidKeyboard: widget.avoidKeyboard,
      bottomWidget: isFloating
          ? Navigator(
              onGenerateInitialRoutes: (navigator, initialRoute) => [
                MaterialPageRoute(builder: (context) => _bottomWidget!),
              ],
            )
          : null,
      onTapTopWidget: isFloating ? stopFloating : null,
      topWidget: IgnorePointer(
        ignoring: isFloating,
        child: Builder(
          builder: (context) => widget.builder(context, isFloating),
        ),
      ),
      floatingHeight: widget.floatingHeight,
      floatingWidth: widget.floatingWidth,
      initialCorner: widget.initialCorner,
      releaseCurve: widget.releaseCurve,
      pipWindowBorderRadius: widget.pipWindowBorderRadius,
      pipWindowEdgeSpacing: widget.pipWindowEdgeSpacing,
      isFreeFlowing: widget.isFreeFlowing,
    );
  }
}
