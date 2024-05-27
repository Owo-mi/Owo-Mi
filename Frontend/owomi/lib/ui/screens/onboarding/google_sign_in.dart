import 'dart:io';

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
  bool hasInternetAccess = false;
  bool finishedInternetAccessCheck = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('jobaadewumi.vercel.app');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasInternetAccess = true;
          finishedInternetAccessCheck = true;
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        hasInternetAccess = false;
        finishedInternetAccessCheck = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Write an error check to make sure page does not load when there is no internet
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
      AsyncError() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                      child: Text(
                        'Click to retry',
                        style: TextStyle(
                          color: Colors.blueAccent[400],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          hasInternetAccess = false;
                          finishedInternetAccessCheck = false;
                          isLoading = true;
                        });
                        checkInternetConnection();
                      },
                    ),
            ],
          ),
        ),
      _ => const Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}
