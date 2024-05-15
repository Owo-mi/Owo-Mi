import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/common_libs.dart';
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
    return switch (googleUrl) {
      AsyncData(:final value) => InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(value)),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            userAgent: 'Owomi',
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
                String temp =
                    uri.toString().replaceAll(Constant.replaceUrl, '');
                print(temp);
                temp = temp.substring(0, temp.indexOf('&'));
                print(temp);
                ref.read(jwtProvider.notifier).state = temp;
                ref.read(googleSignInCompleteProvider.notifier).state = true;
                context.go('/');
              } else {
                context.go('/');
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
        ),
      AsyncError() => throw UnimplementedError(),
      _ => const CircularProgressIndicator(),
    };
  }
}
