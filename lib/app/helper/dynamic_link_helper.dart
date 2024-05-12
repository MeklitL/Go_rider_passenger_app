// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_rider/app/resouces/app_logger.dart';
import 'package:go_rider/app/resouces/navigation_services.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('DynamicLinkHelper');

//www.gorider.com
class DynamicLinkHelper {
  void initDynamicLink() async {
    log.w('initDynamicLink');

    if (!kIsWeb) {
      PendingDynamicLinkData? link =
          await FirebaseDynamicLinks.instance.getInitialLink();

      handleLinkData(link);

      FirebaseDynamicLinks.instance.onLink.listen(
          (PendingDynamicLinkData event) async => handleLinkData(event));
    }
  }

  Future<String> generateDynamicLink({
    required String pathName,
    String? title,
    String? description,
    String? imageUrl,
  }) async {
    final FirebaseDynamicLinks instance = FirebaseDynamicLinks.instance;

    try {
      final DynamicLinkParameters param = DynamicLinkParameters(
          link: Uri.parse("https://www.google.com/"),
          uriPrefix: 'https://gorider.page.link',
          androidParameters: const AndroidParameters(
              packageName: 'com.example.go_rider', minimumVersion: 21),
          iosParameters: const IOSParameters(
              bundleId: 'com.example.go_rider',
              minimumVersion: '1',
              appStoreId: ''),
          socialMetaTagParameters: SocialMetaTagParameters(
            title: title ?? 'GoRider',
            description: description ?? '',
            imageUrl: Uri.parse(
              imageUrl ??
                  "https://scontent.flos5-1.fna.fbcdn.net/v/t39.30808-6/314632351_422187896781207_932432855965978936_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=EDxzXL1U5WIAX_pGGPY&_nc_oc=AQmjIHu6YuqBmHX1nPjTFpDz6IpEXpzYovMzKqGLgfTUbhr6irSh3VaB36gBqwno6I4&_nc_zt=23&_nc_ht=scontent.flos5-1.fna&oh=00_AfA5Alf9Wd66pHSV4qgIcNzeop4TBHroStBDfIRFX42FKw&oe=64566AC5",
            ),
          ));
      final dynamicShortLink = await instance.buildLink(param);

      return dynamicShortLink.toString();
    } catch (e) {
      log.d('error generating dynamic link $e');
      return e.toString();
    }
  }

  handleLinkData(PendingDynamicLinkData? data) {
    final Uri? uri = data!.link;

    if (uri != null) {
      String path = uri.path;

      log.wtf('Path is: $path');

      final queryParams = uri.queryParameters;

      if (queryParams.isNotEmpty) {
        String? id = queryParams['id'];

        log.wtf('Id: $id');

        if (path == 'invite-friend') {
          NavigationService.navigatorKey.currentContext?.go('/homePage');
        } else {
          log.w('not invite link');
          NavigationService.navigatorKey.currentContext?.go('/homePage');
        }
      }
    } else {}
  }
}
