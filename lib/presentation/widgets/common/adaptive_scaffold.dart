import 'package:flutter/material.dart';
import 'package:native_tavern/presentation/widgets/common/app_viewport.dart';

/// Moves custom full-screen page actions to UIKit's preferred physical edge.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({super.key, required this.appBar, required this.body});

  final AppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final layout = WindowLayoutScope.maybeOf(context);
    final edge = layout?.verticalBarEdge;
    final sharedBar = layout != null && layout.barWidth > 0;
    final barWidth = sharedBar ? layout.barWidth : 56.0;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final leading = appBar.leading ??
        (appBar.automaticallyImplyLeading && canPop
            ? const BackButton()
            : null);

    Widget controls() => ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: sharedBar ? layout.barPadding : EdgeInsets.zero,
            child: SafeArea(
              top: !sharedBar,
              bottom: !sharedBar,
              left: !sharedBar,
              right: !sharedBar,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (leading != null) leading,
                    ...?appBar.actions,
                  ],
                ),
              ),
            ),
          ),
        );

    return Scaffold(
      appBar: edge == null ? appBar : null,
      // Fixed element slots preserve the draft, focus, and message scroll
      // position as the native toolbar changes between horizontal/vertical.
      body: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: edge == VerticalBarEdge.left ? barWidth : 0,
            child: edge == VerticalBarEdge.left ? controls() : null,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: edge == null
                      ? 0
                      : kToolbarHeight + MediaQuery.paddingOf(context).top,
                  child: edge == null
                      ? null
                      : AppBar(
                          title: appBar.title,
                          automaticallyImplyLeading: false,
                          backgroundColor: appBar.backgroundColor,
                          foregroundColor: appBar.foregroundColor,
                        ),
                ),
                Expanded(child: body),
              ],
            ),
          ),
          SizedBox(
            width: edge == VerticalBarEdge.right ? barWidth : 0,
            child: edge == VerticalBarEdge.right ? controls() : null,
          ),
        ],
      ),
    );
  }
}
