import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/src/replaced_element.dart';
import 'package:flutter_html/style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/dom.dart' as dom;

/// [IframeContentElement is a [ReplacedElement] with web content.
class IframeContentElement extends ReplacedElement {
  final String? src;
  final double? width;
  final double? height;
  final NavigationDelegate? navigationDelegate;
  final UniqueKey key = UniqueKey();

  IframeContentElement({
    required String name,
    required this.src,
    required this.width,
    required this.height,
    required dom.Element node,
    required this.navigationDelegate,
  }) : super(name: name, style: Style(), node: node);

  @override
  Widget toWidget(RenderContext context) {
    final sandboxMode = attributes["sandbox"];
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(sandboxMode == null || sandboxMode == "allow-scripts"
          ? JavaScriptMode.unrestricted
          : JavaScriptMode.disabled)
      ..setNavigationDelegate(navigationDelegate ?? NavigationDelegate());
    return Container(
      width: width ?? (height ?? 150) * 2,
      height: height ?? (width ?? 300) / 2,
      child: WebViewWidget(
        controller: controller..loadRequest(Uri.tryParse(src ?? '') ?? Uri()),
        key: key,
        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())
        },
      ),
    );
  }
}
