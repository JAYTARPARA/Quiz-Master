import 'dart:io';

import 'package:flutter/material.dart';

class Common {
  var admobAppId = 'ca-app-pub-4800441463353851~4106389795';
  var bannerUnitId = 'ca-app-pub-4800441463353851/9175077165';
  var interstitialUnitId = 'ca-app-pub-4800441463353851/8983505471';
  var onesignalId = 'fd09f359-78e9-436b-8238-b231cc07812e';

  double getSmartBannerHeight(MediaQueryData mediaQuery) {
    if (Platform.isAndroid) {
      if (mediaQuery.size.height > 720) return 90.0;
      if (mediaQuery.size.height > 400) return 50.0;
      return 0.0;
    }

    if (Platform.isIOS) {
      // if (iPad) return 90.0;
      if (mediaQuery.orientation == Orientation.portrait) return 50.0;
      return 32.0;
    }
    // No idea, just return a common value.
    return 0.0;
  }
}
