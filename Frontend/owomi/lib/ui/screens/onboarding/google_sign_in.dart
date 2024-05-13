import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/data/constants.dart';
import 'package:owomi/provider/zk_login_provider.dart';

class GoogleSignInPage extends ConsumerStatefulWidget {
  const GoogleSignInPage({
    super.key,
  });

  @override
  ConsumerState<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends ConsumerState<GoogleSignInPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final googleUrl = ref.watch(googleUrlProvider);
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(googleUrl)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        userAgent: 'Mofa Web3',
        allowsInlineMediaPlayback: true,
        allowsBackForwardNavigationGestures: true,
        automaticallyAdjustsScrollIndicatorInsets: true,
        contentInsetAdjustmentBehavior:
            ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url;
        print(uri);
        if (uri.toString().startsWith(Constant.website)) {
          if (uri.toString().startsWith(Constant.replaceUrl)) {
            String temp = uri.toString().replaceAll(Constant.replaceUrl, '');
            print(temp);
            temp = temp.substring(0, temp.indexOf('&'));
            print(temp);
            Navigator.pop(context, temp);
          } else {
            Navigator.pop(context);
          }
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
    );
  }
}
