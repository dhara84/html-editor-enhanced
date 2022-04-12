import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HtmlEditorExampleApp(),
    );
  }
}


class HtmlEditorExampleApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      darkTheme: ThemeData.light(),
      home: HtmlEditorExample(title: 'Flutter HTML Editor Example'),
    );
  }
}

class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}

class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
    bool onTapChange = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
               
                height: 200,
                decoration: BoxDecoration( color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border:  Border.all(color: onTapChange ? Colors.indigo : Colors.black26)
                ),
                child: HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: 'Your text here...',
                    shouldEnsureVisible: true,
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    // onButtonPressed: (ButtonType type, bool? status,
                    //     Function()? updateStatus) {
                    //   print(
                    //       "button '${describeEnum(type)}' pressed, the current selected status is $status");
                    //   return true;
                    // },

                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      print(
                          "dropdown '${describeEnum(type)}' changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },
                    mediaUploadInterceptor:
                        (file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                 // otherOptions:  OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    print('html before change is $currentHtml');
                  }, onChangeContent: (String? changed) {
                    print('content changed to $changed');
                  }, onChangeCodeview: (String? changed) {
                    print('code changed to $changed');
                  }, onChangeSelection: (EditorSettings settings) {
                    print('parent element is ${settings.parentElement}');
                    print('font name is ${settings.fontName}');
                  }, onDialogShown: () {
                    print('dialog shown');
                  }, onEnter: () {
                    print('enter/return pressed');
                  }, onFocus: () {
                    setState(() {
                      onTapChange = true;
                    });
                    print('editor focused');
                  }, onBlur: () {
                    print('editor unfocused');
                  }, onBlurCodeview: () {
                    print('codeview either focused or unfocused');
                  }, onInit: () {
                    print('init');
                  },
                      onImageUploadError: (FileUpload? file, String? base64Str,
                          UploadError error) {
                        print(describeEnum(error));
                        print(base64Str ?? '');
                        if (file != null) {
                          print(file.name);
                          print(file.size);
                          print(file.type);
                        }
                      }, onKeyDown: (int? keyCode) {
                        print('$keyCode key downed');
                        print(
                            'current character count: ${controller.characterCount}');
                      }, onKeyUp: (int? keyCode) {
                        print('$keyCode key released');
                      }, onMouseDown: () {
                        print('mouse downed');
                      }, onMouseUp: () {
                        print('mouse released');
                      }, onNavigationRequestMobile: (String url) {
                        print(url);
                        return NavigationActionPolicy.ALLOW;
                      }, onPaste: () {
                        print('pasted into editor');
                      }, onScroll: () {
                        print('editor scrolled');
                      }),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          print(value);
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).accentColor),
                    onPressed: () async {
                      var txt = await controller.getText();
                      if (txt.contains('src=\"data:')) {
                        txt =
                        '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                      }
                      setState(() {
                        result = txt;
                      });
                      print(result);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(result),
            )
          ],
        ),
      ),
    );
  }
}