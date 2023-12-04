import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sifreolustur/banner.dart';
import 'package:sifreolustur/db.dart';

import 'main.dart';
import 'package:sifreolustur/constants.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({Key? key}) : super(key: key);

  @override
  _PasswordListScreenState createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  BannerAdWidget bannerAdWidget = BannerAdWidget();
  IconData noteicon = Icons.add;


  void _showPopupMenu(BuildContext context, Map<String, dynamic> password) async {
    final popupMenuItems = <PopupMenuEntry>[
      PopupMenuItem(
        value: 'copy',
        child: Text('Şifreyi kopyala'.tr().toString()),
      ),
      PopupMenuItem(
        value: 'delete',
        child: Text('Şifreyi Sil'.tr().toString()),
      ),
    ];

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0, 0),
      items: popupMenuItems,
    );

    if (result == 'copy') {
      _copyPasswordToClipboard(password['password']);
    } else if (result == 'delete') {
      _deletePassword(password['id']);
    }
  }

  void _copyPasswordToClipboard(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Şifre kopyalandı'.tr().toString()),
      ),
    );
  }

  void _deletePassword(int id) async {
    await PasswordDatabase.instance.deletePassword(id);
    setState(() {
      _passwords = PasswordDatabase.instance.getPasswords();
    });
  }

  late Future<List<Map<String, dynamic>>> _passwords;

  @override
  void initState() {
    super.initState();
    _passwords = PasswordDatabase.instance.getPasswords();
  }

  final _noteController = TextEditingController();
  String note = "";

  Map<int, bool> _isExpandedList = {}; // Expansion tile'ların açık/kapalı durumlarını saklayacak Map

  void _addNoteToPassword(Map<String, dynamic> password, String note) async {
    String originalPassword = password['password'];

    bool hasNote = originalPassword.contains(' - Not: ');

    String updatedNote = hasNote ? "${password['note']}\n$note" : note;

    String updatedPassword = hasNote
        ? originalPassword.replaceFirst(RegExp(r' - Not: .*$'), ' - Not: $updatedNote')
        : '$originalPassword - Not: $updatedNote';

    Map<String, dynamic> updatedPasswordData = {
      'id': password['id'],
      'password': updatedPassword,
      'created_at': password['created_at'],
      'note': updatedNote,
    };

    await PasswordDatabase.instance.updatePassword(updatedPasswordData);

    setState(() {
      _passwords = PasswordDatabase.instance.getPasswords();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Not eklendi: $note'),
      ),
    );
  }

  void _deleteNoteFromPassword(Map<String, dynamic> password, int noteIndex) async {
    String originalPassword = password['password'];
    String passwordNote = password['note'];

    if (passwordNote == null || passwordNote.isEmpty) {
      return;
    }

    List<String> noteList = passwordNote.split('\n');
    if (noteIndex >= 0 && noteIndex < noteList.length) {
      noteList.removeAt(noteIndex);
      String updatedNote = noteList.join('\n');

      String updatedPassword = originalPassword.contains(' - Not: ')
          ? originalPassword.replaceFirst(RegExp(r' - Not: .*$'), ' - Not: $updatedNote')
          : '$originalPassword - Not: $updatedNote';

      Map<String, dynamic> updatedPasswordData = {
        'id': password['id'],
        'password': updatedPassword,
        'created_at': password['created_at'],
        'note': updatedNote,
      };

      await PasswordDatabase.instance.updatePassword(updatedPasswordData);

      setState(() {
        _passwords = PasswordDatabase.instance.getPasswords();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not silindi'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text('Oluşturulmuş Şifreler'.tr().toString()),
        elevation: 8,
        shadowColor: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        backgroundColor: Colors.teal[400],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _passwords,
                builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final passwords = snapshot.data!;
                    return ListView.builder(

                      itemCount: passwords.length,
                      itemBuilder: (BuildContext context, int index) {
                        final originalPassword = passwords[index]['password'];
                        final createdAt = passwords[index]['created_at'];
                        final passwordNote = passwords[index]['note'];

                        String passwordToShow = originalPassword;
                        if (originalPassword.contains(' - Not: ')) {
                          int indexOfNote = originalPassword.lastIndexOf(' - Not: ');
                          passwordToShow = originalPassword.substring(0, indexOfNote);
                        }

                        List<String> noteList = passwordNote?.split('\n') ?? [];

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ExpansionTile(
                            onExpansionChanged: (isExpanded) {
                              setState(() {
                                _isExpandedList[index] = isExpanded;
                              });
                            },
                            title: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                _showPopupMenu(context, passwords[index]);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      color: Colors.blueGrey,
                                      elevation: 8,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(passwordToShow, style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                 // Null check yaptık, değer null ise false kabul edilecek
                                    Text(
                                      'Uygulamalar'.tr().toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                ],
                              ),
                            ),
                            children: [
                              if (_isExpandedList[index] == true && noteList.isNotEmpty)
                                for (int i = 0; i < noteList.length; i++)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left:18.0),
                                              child: Text(
                                                'Uygulama'.tr().toString()+" ${i + 1}: ${noteList[i]}",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _deleteNoteFromPassword(passwords[index], i);
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.white54, thickness: 1,indent: 20,endIndent: 20),

                                    ],
                                  ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              _noteController.text = ''; // Clear note field for adding a new note
                                              return AlertDialog(
                                                title: Text('Uygulama Adı Ekle'.tr().toString()),
                                                content: TextFormField(
                                                  controller: _noteController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Not'.tr().toString(),
                                                    hintText: 'Uygulama Adını Girin'.tr().toString(),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Vazgeç'.tr().toString()),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Ekle'.tr().toString()),
                                                    onPressed: () {
                                                      String note = _noteController.text;
                                                      _addNoteToPassword(passwords[index], note);
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 18.0,right: 18),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Uygulama Adı Ekle".tr().toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                                ),
                                                Icon(noteicon),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.center,
                                            ),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.lightGreen),

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Container(
              height: 50,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: bannerAdWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
