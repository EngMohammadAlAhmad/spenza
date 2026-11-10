import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spenza/core/translations/locale_keys.g.dart';

abstract class ShareService {
  Future<void> shareProduct({
    required int productId,
    required String title,
    String? description,
  });

  Future<void> shareText({
    required String text,
    String? subject,
  });
}

class ShareServiceImpl implements ShareService {
  static const String _baseProductUrl = 'https://spenzastore.com/products';

  @override
  Future<void> shareProduct({
    required int productId,
    required String title,
    String? description,
  }) async {
    final productUrl = '$_baseProductUrl/$productId';
    final shareContent = LocaleKeys.share_product_text.tr(args: [title, productUrl]);
    final shareSubject = LocaleKeys.share_product_subject.tr(args: [title]);

    // ignore: deprecated_member_use
    await Share.share(
      shareContent,
      subject: shareSubject,
    );
  }

  @override
  Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    // ignore: deprecated_member_use
    await Share.share(
      text,
      subject: subject,
    );
  }
}
