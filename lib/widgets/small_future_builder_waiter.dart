import 'package:flutter/cupertino.dart';

class SmallFutureBuilderWaiter<T> extends StatelessWidget {
  const SmallFutureBuilderWaiter({
    super.key,
    required this.snapshot,
    required this.child,
  });
  final AsyncSnapshot<T> snapshot;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    while (snapshot.connectionState == ConnectionState.active ||
        snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (snapshot.hasData) {
      return child;
    }
    return const SizedBox();
  }
}
