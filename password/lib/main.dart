import 'package:countries_flag/countries_flag.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sifreolustur/constants.dart';
import 'package:sifreolustur/db.dart';
import 'intersistal.dart';
import 'kayit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sifreolustur/banner.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(

    EasyLocalization(
      child: MyApp(),
      supportedLocales: [LocaleConstants.enLocale, LocaleConstants.trLocale],
      path: LocaleConstants.localePath,
      saveLocale: true,
      fallbackLocale: LocaleConstants.enLocale,
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedFlag = Flags.turkey;
  bool includeSpecialChars = false;

  void toggleIncludeSpecialChars(bool? value) {
    setState(() {
      includeSpecialChars = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Icon iconArrow = Icon(Icons.play_arrow_outlined);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: context.supportedLocales,

      home: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          title: selectedFlag == Flags.turkey
              ? Text("Güçlü Şifre Oluşturucu "): Text("Strong Password Generator"),
          actions: [
            Row(
              children: [
                iconArrow,
                Container(
                  width: 45,
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: PopupMenuButton(
                    key: Key('menuButtonKey'),
                    padding: EdgeInsets.all(15),
                    child: CountriesFlag(selectedFlag),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              CountriesFlag(
                                Flags.unitedStatesOfAmerica,
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text('English (US)'),
                            ],
                          ),
                          key: Key('unitedStatesMenuItemKey'),
                          value: Flags.unitedStatesOfAmerica,
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              CountriesFlag(
                                Flags.turkey,
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text('Türkçe (TR)'),
                            ],
                          ),
                          value: Flags.turkey,
                        ),
                      ];
                    },
                    onSelected: (value) async {
                      setState(() {
                        selectedFlag = value;
                      });
                      await selectedFlag == Flags.unitedStatesOfAmerica
                          ? context.setLocale(LocaleConstants.enLocale)
                          : context.setLocale(LocaleConstants.trLocale);
                    },
                  ),
                ),
              ],
            ),
          ],
          elevation: 8,
          shadowColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.teal[400],
        ),
        body:  PasswordGenerator(
          includeSpecialChars: includeSpecialChars,
          toggleIncludeSpecialChars: toggleIncludeSpecialChars,
        ),

      ),
    );
  }
}

class PasswordGenerator extends StatefulWidget {

  final bool includeSpecialChars;
  final Function(bool?) toggleIncludeSpecialChars;

  const PasswordGenerator({
    required this.includeSpecialChars,
    required this.toggleIncludeSpecialChars,
  });

  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  BannerAdWidget bannerAdWidget = BannerAdWidget();

  final _formKey = GlobalKey<FormState>();
  final _lengthController = TextEditingController();
  final _includeWordController = TextEditingController();
  String _password = '';
  bool containsEmoji(String text) {
    final regex = RegExp(
        r'[^\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u0180-\u024F\u0250-\u02AF\u02B0-\u02FF\u0300-\u036F\u0370-\u03FF\u0400-\u04FF\u0500-\u052F\u0530-\u058F\u0590-\u05FF\u0600-\u06FF\u0700-\u074F\u0750-\u077F\u0780-\u07BF\u07C0-\u07FF\u0800-\u083F\u0840-\u085F\u0860-\u087F\u0880-\u08AF\u08B0-\u08FF\u0900-\u097F\u0980-\u09FF\u0A00-\u0A7F\u0A80-\u0AFF\u0B00-\u0B7F\u0B80-\u0BFF\u0C00-\u0C7F\u0C80-\u0CFF\u0D00-\u0D7F\u0D80-\u0DFF\u0E00-\u0E7F\u0E80-\u0EFF\u0F00-\u0FFF\u1000-\u109F\u10A0-\u10FF\u1100-\u11FF\u1200-\u137F\u1380-\u139F\u13A0-\u13FF\u1400-\u167F\u1680-\u169F\u16A0-\u16FF\u1700-\u171F\u1720-\u173F\u1740-\u175F\u1760-\u177F\u1780-\u17FF\u1800-\u18AF\u1E00-\u1EFF\u1F00-\u1FFF\u2000-\u206F\u2070-\u209F\u20A0-\u20CF\u20D0-\u20FF\u2100-\u214F\u2150-\u218F\u2190-\u21FF\u2200-\u22FF\u2300-\u23FF\u2400-\u243F\u2440-\u245F\u2460-\u24FF\u2500-\u257F\u2580-\u259F\u25A0-\u25FF\u2600-\u26FF\u2700-\u27BF\u27C0-\u27EF\u27F0-\u27FF\u2800-\u28FF\u2900-\u297F\u2980-\u29FF\u2A00-\u2AFF\u2B00-\u2BFF\u2C00-\u2C5F\u2C60-\u2C7F\u2C80-\u2CFF\u2D00-\u2D2F\u2D30-\u2D7F\u2D80-\u2DDF\u2DE0-\u2DFF\u2E00-\u2E7F\u2E80-\u2EFF\u2F00-\u2FDF\u2FF0-\u2FFF\u3000-\u303F\u3040-\u309F\u30A0-\u30FF\u3100-\u312F\u3130-\u318F\u3190-\u319F\u31A0-\u31BF\u31C0-\u31EF\u31F0-\u31FF\u3200-\u32FF\u3300-\u33FF\u3400-\u4DBF\u4DC0-\u4DFF\u4E00-\u9FFF\uA000-\uA48F\uA490-\uA4CF\uA4D0-\uA4FF\uA500-\uA63F\uA640-\uA69F\uA6A0-\uA6FF\uA700-\uA71F\uA720-\uA7FF\uA800-\uA82F\uA830-\uA83F\uA840-\uA87F\uA880-\uA8DF\uA8E0-\uA8FF\uA900-\uA92F\uA930-\uA95F\uA960-\uA97F\uA980-\uA9DF\uA9E0-\uA9FF\uAA00-\uAA5F\uAA60-\uAA7F\uAA80-\uAADF\uAAE0-\uAAFF\uAB00-\uAB2F\uAB30-\uAB6F\uAB70-\uABBF\uABC0-\uABFF\uAC00-\uD7AF\uD7B0-\uD7FF\uDC00-\uDFFF\uE000-\uF8FF\uF900-\uFAFF\uFB00-\uFB4F\uFB50-\uFDFF\uFE00-\uFE0F\uFE10-\uFE1F\uFE20-\uFE2F\uFE30-\uFE4F\uFE50-\uFE6F\uFE70-\uFEFF\uFF00-\uFFEF\uFFF0-\uFFFF]');
    return regex.hasMatch(text);
  }
  final InterstitialAdHelper interstitialAdHelper = InterstitialAdHelper();
  @override
  void initState() {
    super.initState();
    interstitialAdHelper.initialize();
  }

  void _savePassword(String password) async {
    await PasswordDatabase.instance.createPassword(password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Şifre Kaydedildi'.tr().toString()),
      ),
    );
  }


  String generatePassword(int length, {String? includeWord}) {
    final random = Random.secure();
    final chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final specialChars = '!@#\$%^&*()_+-={}[]:;"<>?/';

    final availableChars = widget.includeSpecialChars ? chars + specialChars : chars;

    final passwordChars = List.generate(length, (index) {
      if (includeWord != null && index < includeWord.length) {
        return includeWord.codeUnitAt(index);
      }
      return availableChars.codeUnitAt(random.nextInt(availableChars.length));
    });

    return String.fromCharCodes(passwordChars);
  }

  String randomlyPlaceWord(String password, String? includeWord) {
    if (includeWord == null || includeWord.isEmpty) {
      return password;
    }

    final random = Random.secure();
    final index = random.nextInt(password.length + 1);
    final randomizedPassword = password.substring(0, index) + includeWord + password.substring(index);

    // Remove the initial occurrence of the includeWord from the beginning of the password
    if (randomizedPassword.startsWith(includeWord)) {
      return randomizedPassword.substring(includeWord.length);
    }

    return randomizedPassword;
  }


  @override
  void dispose() {
    _lengthController.dispose();
    _includeWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _lengthController,
                decoration: InputDecoration(
                  labelText: 'Şifre Uzunluğu'.tr().toString(),
                  hintText: 'Şifre Uzunluğunu Giriniz'.tr().toString(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen karakter uzunluğu için bir sayı girin'.tr().toString();
                  }
                  if (int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                    return 'Lütfen pozitif bir sayı girin'.tr().toString();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _includeWordController,
                decoration: InputDecoration(
                  labelText: 'Şifrenin içereceği kelime (Opsiyonel)'.tr().toString(),
                  hintText: 'Kelimeyi girin'.tr().toString(),
                ),
              ),
              CheckboxListTile(
                title: Text('Özel Karakter İçersin'.tr().toString()),
                value: widget.includeSpecialChars,
                onChanged: (bool? value) {
                  if (value != null) {
                    widget.toggleIncludeSpecialChars(value);
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent[700],
                  onPrimary: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 18,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final includeWord = _includeWordController.text;
                    final hasEmoji = containsEmoji(includeWord);
                    if (hasEmoji) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Uyarı'.tr().toString()),
                            content: Text('Şifre içinde emoji kullanılamaz'.tr().toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Tamam'.tr().toString()),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final length = int.parse(_lengthController.text);
                      final password = generatePassword(length, includeWord: includeWord);
                      final randomizedPassword = randomlyPlaceWord(password, includeWord);
                      setState(() {
                        _password = randomizedPassword;
                      });
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Güçlü Şifreyi Oluştur'.tr().toString()),
                    SizedBox(width: 8.0),
                  ],
                ),
              ),

              if (_password.isNotEmpty)
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Password: $_password',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              if (_password.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                           // Clipboard.setData(ClipboardData(text: _password));
                          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Şifre kopyalandı'.tr().toString())));
                            _savePassword(_password);
                         //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Şifre Kaydedildi'.tr().toString())));
                          },
                          icon: Icon(Icons.save_rounded),
                          color: Colors.deepPurple,
                        ),
                        Text(
                          "Şifreyi Kopyala ve Kaydet".tr().toString(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent[700],
                  onPrimary: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 18,
                ),
                onPressed: () {
                  // Show the interstitial ad when the button is clicked
                  interstitialAdHelper.showInterstitialAd();

                  // Navigate to the Oluşturulmuş Şifreler screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordListScreen()),
                  );
                },
                child: Text("Oluşturulmuş Şifreler".tr().toString()),

              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: bannerAdWidget,
                ),
              ),
            ],
          ),
        ),

      ),
    );

  }
}
