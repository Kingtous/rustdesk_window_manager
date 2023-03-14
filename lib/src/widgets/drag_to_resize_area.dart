import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/src/resize_edge.dart';
import 'package:window_manager/src/window_manager.dart';

class DragToResizeEdge extends StatefulWidget {
  final ResizeEdge resizeEdge;
  final double? width;
  final double? height;
  final Color resizeEdgeColor;
  final MouseCursor resizeCursor;
  DragToResizeEdge({
    Key? key,
    this.width,
    this.height,
    required this.resizeEdge,
    required this.resizeEdgeColor,
    required this.resizeCursor,
  });

  @override
  State<DragToResizeEdge> createState() => _DragToResizeEdgeState();
}

class _DragToResizeEdgeState extends State<DragToResizeEdge> {
  MouseCursor cursor = MouseCursor.defer;

  @override
  void initState() {
    cursor = widget.resizeCursor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.resizeEdgeColor,
      child: Listener(
        onPointerDown: (_) => windowManager.startResizing(widget.resizeEdge),
        onPointerUp: (_) => setState(() {
          cursor = widget.resizeCursor;
        }),
        child: MouseRegion(
          cursor: cursor,
          onEnter: (evt) => setState(() {
            cursor = evt.buttons != 0 ? MouseCursor.defer : widget.resizeCursor;
          }),
          child: GestureDetector(
            onDoubleTap: () => (Platform.isWindows &&
                    (widget.resizeEdge == ResizeEdge.top ||
                        widget.resizeEdge == ResizeEdge.bottom))
                ? windowManager.maximize(vertically: true)
                : null,
          ),
        ),
      ),
    );
  }
}

/// A widget for drag to resize window.
///
/// Use the widget to simulate dragging the edges to resize the window.
///
/// {@tool snippet}
///
/// The sample creates a grey box, drag the box to resize the window.
///
/// ```dart
/// DragToResizeArea(
///   child: Container(
///     width: double.infinity,
///     height: double.infinity,
///     color: Colors.grey,
///   ),
///   resizeEdgeSize: 6,
///   resizeEdgeColor: Colors.red.withOpacity(0.2),
/// )
/// ```
/// {@end-tool}
class DragToResizeArea extends StatelessWidget {
  const DragToResizeArea({
    Key? key,
    required this.child,
    this.resizeEdgeColor = Colors.transparent,
    this.resizeEdgeSize = 8,
    this.resizeEdgeMargin = EdgeInsets.zero,
    this.enableResizeEdges,
  }) : super(key: key);

  final Widget child;
  final double resizeEdgeSize;
  final Color resizeEdgeColor;
  final EdgeInsets resizeEdgeMargin;
  final List<ResizeEdge>? enableResizeEdges;

  Widget _buildDragToResizeEdge(
    ResizeEdge resizeEdge, {
    MouseCursor cursor = SystemMouseCursors.basic,
    double? width,
    double? height,
  }) {
    if (enableResizeEdges != null && !enableResizeEdges!.contains(resizeEdge)) {
      return Container();
    }
    return Container(
      width: width,
      height: height,
      color: resizeEdgeColor,
      child: Listener(
        onPointerDown: (_) => windowManager.startResizing(resizeEdge),
        child: MouseRegion(
          cursor: cursor,
          child: GestureDetector(
            onDoubleTap: () => (Platform.isWindows &&
                    (resizeEdge == ResizeEdge.top ||
                        resizeEdge == ResizeEdge.bottom))
                ? windowManager.maximize(vertically: true)
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getOffstage(ResizeEdge resizeEdge) =>
        enableResizeEdges != null && !enableResizeEdges!.contains(resizeEdge);

    return Stack(
      children: <Widget>[
        child,
        Positioned(
          child: Container(
            margin: resizeEdgeMargin,
            child: Column(
              children: [
                Row(
                  children: [
                    Offstage(
                      offstage: getOffstage(ResizeEdge.topLeft),
                      child: DragToResizeEdge(
                        resizeEdge: ResizeEdge.topLeft,
                        width: resizeEdgeSize,
                        height: resizeEdgeSize,
                        resizeEdgeColor: resizeEdgeColor,
                        resizeCursor: SystemMouseCursors.resizeUpLeft,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Offstage(
                        offstage: getOffstage(ResizeEdge.top),
                        child: DragToResizeEdge(
                          resizeEdge: ResizeEdge.top,
                          height: resizeEdgeSize,
                          resizeEdgeColor: resizeEdgeColor,
                          resizeCursor: SystemMouseCursors.resizeUp,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: getOffstage(ResizeEdge.topRight),
                      child: DragToResizeEdge(
                        resizeEdge: ResizeEdge.topRight,
                        width: resizeEdgeSize,
                        height: resizeEdgeSize,
                        resizeEdgeColor: resizeEdgeColor,
                        resizeCursor: SystemMouseCursors.resizeUpRight,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Offstage(
                        offstage: getOffstage(ResizeEdge.left),
                        child: DragToResizeEdge(
                          resizeEdge: ResizeEdge.left,
                          width: resizeEdgeSize,
                          height: double.infinity,
                          resizeEdgeColor: resizeEdgeColor,
                          resizeCursor: SystemMouseCursors.resizeLeft,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Offstage(
                        offstage: getOffstage(ResizeEdge.right),
                        child: DragToResizeEdge(
                          resizeEdge: ResizeEdge.right,
                          width: resizeEdgeSize,
                          height: double.infinity,
                          resizeEdgeColor: resizeEdgeColor,
                          resizeCursor: SystemMouseCursors.resizeRight,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Offstage(
                      offstage: getOffstage(ResizeEdge.bottomLeft),
                      child: DragToResizeEdge(
                        resizeEdge: ResizeEdge.bottomLeft,
                        width: resizeEdgeSize,
                        height: resizeEdgeSize,
                        resizeEdgeColor: resizeEdgeColor,
                        resizeCursor: SystemMouseCursors.resizeDownLeft,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Offstage(
                        offstage: getOffstage(ResizeEdge.bottom),
                        child: DragToResizeEdge(
                          resizeEdge: ResizeEdge.bottom,
                          height: resizeEdgeSize,
                          resizeEdgeColor: resizeEdgeColor,
                          resizeCursor: SystemMouseCursors.resizeDown,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: getOffstage(ResizeEdge.bottomRight),
                      child: DragToResizeEdge(
                        resizeEdge: ResizeEdge.bottomRight,
                        width: resizeEdgeSize,
                        height: resizeEdgeSize,
                        resizeEdgeColor: resizeEdgeColor,
                        resizeCursor: SystemMouseCursors.resizeDownRight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
