import 'dart:async';

import 'package:allevia_one/extensions/model_ext.dart';
import 'package:allevia_one/providers/px_speciality.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:provider/provider.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

  @override
  Widget build(BuildContext context) {
    //todo: show specialities icons spinning
    return ChangeNotifierProvider.value(
      value: PxSpec(),
      builder: (context, child) {
        return Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Colors.blue.shade500,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CoreCentralLoading(),
                const SizedBox(height: 10),
                Text(context.loc.loading)
              ],
            ),
          ),
        );
      },
    );
  }
}

class CoreCentralLoading extends StatefulWidget {
  const CoreCentralLoading({super.key});

  @override
  State<CoreCentralLoading> createState() => _CoreCentralLoadingState();
}

class _CoreCentralLoadingState extends State<CoreCentralLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Timer _timer;
  int _index = 0;
  final _duration = Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      upperBound: 1,
      lowerBound: 0,
    )..repeat();
    _timer = Timer.periodic(_duration, (ti) {
      setState(() {
        if (_index >= 37) {
          _index = 0;
        } else {
          _index++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PxSpec>(
      builder: (context, s, _) {
        while (s.specialities == null) {
          return CircularProgressIndicator();
        }
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY(_animationController.value * 6.3),
              child: child,
            );
          },
          child: CachedNetworkImage(
            imageUrl: s.specialities![_index].imageUrl,
            height: 50,
            width: 50,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
          ),
        );
      },
    );
  }
}
