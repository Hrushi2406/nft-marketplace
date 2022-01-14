import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumToString(v),
      orElse: () => throw NullThrownError(),
    );

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String? validator(String? e) => e == null
    ? 'Field can\'t be empty'
    : e.isEmpty
        ? 'FIELD CAN\'T BE EMPTY'
        : null;

String? urlValidator(String? e) {
  if (validator(e) == null) {
    final isUrl = e!.contains('https://') || e.contains('http://');

    if (!isUrl) {
      return 'URL SHOULD START WITH https:// or http://';
    }
    return null;
  } else {
    return validator(e);
  }
}

String formatBalance(EtherAmount? balance, [int precision = 4]) =>
    balance == null
        ? '0'
        : balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(precision);

String formatAddress(String address) =>
    address.substring(0, 4) + '...' + address.substring(38, 42);

enum ListingType {
  fixedPriceSale,
  fixedPriceNotSale,
  bidding,
}

copy(String data) async {
  await Clipboard.setData(ClipboardData(text: data));

  Fluttertoast.showToast(msg: 'Copied to Clipboard');
}

share(
  String title,
  String image,
  String description,
) async {
  try {
    Fluttertoast.showToast(msg: 'Please wait');
    final imageUrl = 'https://ipfs.io/ipfs/$image';

    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';

    File(path).writeAsBytesSync(bytes);

    const link = ' ';

    await Share.shareFiles(
      [path],
      text: 'Have a look at ' +
          title +
          ' on Mintit. Download here https://drive.google.com/drive/folders/1C5y4Tv5_5WRmpK1faeO1tOliHs31J_w1?usp=sharing',
      subject: description + link,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error at share: $e');
  }
}

openUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
