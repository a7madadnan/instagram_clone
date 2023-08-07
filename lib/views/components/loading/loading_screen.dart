import 'dart:async';

import 'package:flutter/material.dart';

import 'package:instant_gram/views/components/loading/loading_screen_controller.dart';
import 'package:instant_gram/views/components/constants/strings.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;
  LoadingScreenController? _controller;
  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);
    // if (state == null) {
    //   return null;
    // }
    final texrController = StreamController<String>();
    texrController.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;
    final size = renderBox.size;
    size.log();
    
    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.8,
              maxWidth: size.width * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<String>(
                          stream: texrController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.requireData,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black),
                              );
                            } else {
                              return Container();
                            }
                          })
                    ]),
              ),
            ),
          ),
        ),
      );
    });
    state.insert(overlay);
    return LoadingScreenController(close: () {
      texrController.close();
      overlay.remove();
      return true;
    }, update: (text) {
      texrController.add(text);
      return true;
    });
  }
}
