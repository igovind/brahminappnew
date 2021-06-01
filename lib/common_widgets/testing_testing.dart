import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CustomSearchableDropdown.dart';


class ExampleNumber {
  int number;

  static final Map<int, String> map = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
  };

  String get numberString {
    return ((map.containsKey(number) ? map[number] : "unknown") ?? "unknown");
  }

  ExampleNumber(this.number);

  String toString() {
    return ("$number $numberString");
  }

  static List<ExampleNumber> get list {
    return (map.keys.map((num) {
      return (ExampleNumber(num));
    })).toList();
  }
}



class TestingTesting extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();
  const TestingTesting({Key? navKey}) : super(key: navKey);
  @override
  _TestingTestingState createState() => _TestingTestingState();
}

class _TestingTestingState extends State<TestingTesting> {
  bool asTabs = false;
  String? selectedValueSingleDialog;
  String? selectedValueSingleDoneButtonDialog;
  String? selectedValueSingleMenu;
  String? selectedValueSingleDialogCustomKeyboard;
  String? selectedValueSingleDialogOverflow;
  String? selectedValueSingleDialogEditableItems;
  String? selectedValueSingleDialogDarkMode;
  String? selectedValueSingleDialogEllipsis;
  String? selectedValueSingleDialogRightToLeft;
  String? selectedValueUpdateFromOutsideThePlugin;
  ExampleNumber? selectedNumber;
  List<int> selectedItemsMultiDialog = [];
  List<int> selectedItemsMultiCustomDisplayDialog = [];
  List<int> selectedItemsMultiSelect3Dialog = [];
  List<int> selectedItemsMultiMenu = [];
  List<int> selectedItemsMultiMenuSelectAllNone = [];
  List<int> selectedItemsMultiDialogSelectAllNoneWoClear = [];
  List<int> editableSelectedItems = [];
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> editableItems = [];
  final _formKey = GlobalKey<FormState>();
  String inputString = "";
  TextFormField? input;
  List<DropdownMenuItem<ExampleNumber>> numberItems =
  ExampleNumber.list.map((exNum) {
    return (DropdownMenuItem(child: Text(exNum.numberString), value: exNum));
  }).toList();
  List<int> selectedItemsMultiSelect3Menu = [];
  List<int> selectedItemsMultiDialogWithCountAndWrap = [];

  static const String appTitle = "Search Choices demo";
  final String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Function? openDialog;

  @override
  void initState() {
    String wordPair = "";
    loremIpsum
        .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .split(" ")
        .forEach((word) {
      if (wordPair.isEmpty) {
        wordPair = word + " ";
      } else {
        wordPair += word;
        if (items.indexWhere((item) {
          return (item.value == wordPair);
        }) ==
            -1) {
          items.add(DropdownMenuItem(
            child: Text(wordPair),
            value: wordPair,
          ));
        }
        wordPair = "";
      }
    });
    input = TextFormField(
      validator: (value) {
        return ((value?.length ?? 0) < 6
            ? "must be at least 6 characters long"
            : null);
      },
      initialValue: inputString,
      onChanged: (value) {
        inputString = value;
      },
      autofocus: true,
    );
    super.initState();
  }

  List<Widget> get appBarActions {
    return ([
      Center(child: Text("Tabs:")),
      Switch(
        activeColor: Colors.white,
        value: asTabs,
        onChanged: (value) {
          setState(() {
            asTabs = value;
          });
        },
      )
    ]);
  }

  addItemDialog() async {
    return await showDialog(
      context: TestingTesting.navKey.currentState?.overlay?.context ?? context,
      builder: (BuildContext alertContext) {
        return (AlertDialog(
          title: Text("Add an item"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                input ?? SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        editableItems.add(DropdownMenuItem(
                          child: Text(inputString),
                          value: inputString,
                        ));
                      });
                      Navigator.pop(alertContext, inputString);
                    }
                  },
                  child: Text("Ok"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(alertContext, null);
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Single dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
      ),
      "Multi dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialog,
        hint: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Select any"),
        ),
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialog = value;
          });
        },
        closeButton: (selectedItems) {
          return (selectedItems.isNotEmpty
              ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
              : "Save without selection");
        },
        isExpanded: true,
      ),
      "Single done button dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDoneButtonDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDoneButtonDialog = value;
          });
        },
        doneButton: "Done",
        displayItem: (item, selected) {
          return (Row(children: [
            selected
                ? Icon(
              Icons.radio_button_checked,
              color: Colors.grey,
            )
                : Icon(
              Icons.radio_button_unchecked,
              color: Colors.grey,
            ),
            SizedBox(width: 7),
            Expanded(
              child: item,
            ),
          ]));
        },
        isExpanded: true,
      ),
      "Multi custom display dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiCustomDisplayDialog,
        hint: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Select any"),
        ),
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiCustomDisplayDialog = value;
          });
        },
        displayItem: (item, selected) {
          return (Row(children: [
            selected
                ? Icon(
              Icons.check,
              color: Colors.green,
            )
                : Icon(
              Icons.check_box_outline_blank,
              color: Colors.grey,
            ),
            SizedBox(width: 7),
            Expanded(
              child: item,
            ),
          ]));
        },
        selectedValueWidgetFn: (item) {
          return (Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.brown,
                      width: 0.5,
                    ),
                  ),
                  margin: EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(item.toString()),
                  ))));
        },
        doneButton: (selectedItemsDone, doneContext) {
          return (TextButton(
              onPressed: () {
                Navigator.pop(doneContext);
                setState(() {});
              },
              child: Text("Save")));
        },
        closeButton: null,
        style: TextStyle(fontStyle: FontStyle.italic),
        searchFn: (String keyword, items) {
          List<int> ret = [];
          if (items != null && keyword.isNotEmpty) {
            keyword.split(" ").forEach((k) {
              int i = 0;
              items.forEach((item) {
                if (k.isNotEmpty &&
                    (item.value
                        .toString()
                        .toLowerCase()
                        .contains(k.toLowerCase()))) {
                  ret.add(i);
                }
                i++;
              });
            });
          }
          if (keyword.isEmpty) {
            ret = Iterable<int>.generate(items.length).toList();
          }
          return (ret);
        },
        clearIcon: Icon(Icons.clear_all),
        icon: Icon(Icons.arrow_drop_down_circle),
        label: "Label for multi",
        underline: Container(
          height: 1.0,
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(color: Colors.teal, width: 3.0))),
        ),
        iconDisabledColor: Colors.brown,
        iconEnabledColor: Colors.indigo,
        isExpanded: true,
      ),
      "Multi select 3 dialog": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiSelect3Dialog,
        hint: "Select 3 items",
        searchHint: "Select 3",
        validator: (selectedItemsForValidator) {
          if (selectedItemsForValidator.length != 3) {
            return ("Must select 3");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItemsMultiSelect3Dialog = value;
          });
        },
        doneButton: (selectedItemsDone, doneContext) {
          return (TextButton(
              onPressed: selectedItemsDone.length != 3
                  ? null
                  : () {
                Navigator.pop(doneContext);
                setState(() {});
              },
              child: Text("Save")));
        },
        closeButton: (selectedItemsClose) {
          return (selectedItemsClose.length == 3 ? "Ok" : null);
        },
        isExpanded: true,
      ),
      "Single menu": SearchChoices.single(
        items: items,
        value: selectedValueSingleMenu,
        hint: "Select one",
        searchHint: null,
        onChanged: (value) {
          setState(() {
            selectedValueSingleMenu = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
      "Multi menu": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiMenu,
        hint: "Select any",
        searchHint: "",
        doneButton: "Close",
        closeButton: SizedBox.shrink(),
        onChanged: (value) {
          setState(() {
            selectedItemsMultiMenu = value;
          });
        },
        dialogBox: false,
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
      "Multi menu select all/none": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiMenuSelectAllNone,
        hint: "Select any",
        searchHint: "Select any",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiMenuSelectAllNone = value;
          });
        },
        dialogBox: false,
        closeButton: (selectedItemsClose, closeContext, Function updateParent) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                      selectedItemsClose.addAll(
                          Iterable<int>.generate(items.length).toList());
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: Text("Select all")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: Text("Select none")),
            ],
          );
        },
        isExpanded: true,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
      ),
      "Multi dialog select all/none without clear": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialogSelectAllNoneWoClear,
        hint: "Select any",
        searchHint: "Select any",
        displayClearIcon: false,
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialogSelectAllNoneWoClear = value;
          });
        },
        dialogBox: true,
        closeButton: (selectedItemsClose, closeContext, Function updateParent) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                      selectedItemsClose.addAll(
                          Iterable<int>.generate(items.length).toList());
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: Text("Select all")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItemsClose.clear();
                    });
                    updateParent(selectedItemsClose);
                  },
                  child: Text("Select none")),
            ],
          );
        },
        isExpanded: true,
      ),
      "Single dialog custom keyboard": SearchChoices.single(
        items: Iterable<int>.generate(20).toList().map((i) {
          return (DropdownMenuItem(
            child: Text(i.toString()),
            value: i.toString(),
          ));
        }).toList(),
        value: selectedValueSingleDialogCustomKeyboard,
        hint: "Select one number",
        searchHint: "Select one number",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogCustomKeyboard = value;
          });
        },
        dialogBox: true,
        keyboardType: TextInputType.number,
        isExpanded: true,
      ),
      "Single dialog object": SearchChoices.single(
        items: numberItems,
        value: selectedNumber,
        hint: "Select one number",
        searchHint: "Select one number",
        onChanged: (value) {
          setState(() {
            selectedNumber = value;
          });
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog overflow": SearchChoices.single(
        items: [
          DropdownMenuItem(
            child: Text(
                "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now"),
            value:
            "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
          )
        ],
        value: selectedValueSingleDialogOverflow,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogOverflow = value;
          });
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog readOnly": SearchChoices.single(
        items: [
          DropdownMenuItem(
            child: Text("one item"),
            value: "one item",
          )
        ],
        value: "one item",
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: "Disabled",
        onChanged: (value) {
          setState(() {});
        },
        dialogBox: true,
        isExpanded: true,
        readOnly: true,
      ),
      "Single dialog disabled": SearchChoices.single(
        items: [
          DropdownMenuItem(
            child: Text("one item"),
            value: "one item",
          )
        ],
        value: "one item",
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: "Disabled",
        onChanged: null,
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog editable items": SearchChoices.single(
        items: editableItems,
        value: selectedValueSingleDialogEditableItems,
        hint: "Select one",
        searchHint: "Select one",
        disabledHint: (Function updateParent) {
          return (TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                updateParent(value);
              });
            },
            child: Text("No choice, click to add one"),
          ));
        },
        closeButton:
            (String? value, BuildContext closeContext, Function updateParent) {
          return (editableItems.length >= 100
              ? "Close"
              : TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                if (value != null &&
                    editableItems.indexWhere(
                            (element) => element.value == value) !=
                        -1) {
                  Navigator.pop(
                      TestingTesting.navKey.currentState?.overlay?.context ??
                          context);
                  updateParent(value);
                }
              });
            },
            child: Text("Add and select item"),
          ));
        },
        onChanged: (String? value) {
          setState(() {
            if (!(value is NotGiven)) {
              selectedValueSingleDialogEditableItems = value;
            }
          });
        },
        displayItem: (item, selected, Function updateParent) {
          return (Row(children: [
            selected
                ? Icon(
              Icons.check,
              color: Colors.green,
            )
                : Icon(
              Icons.check_box_outline_blank,
              color: Colors.transparent,
            ),
            SizedBox(width: 7),
            Expanded(
              child: item,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                editableItems.removeWhere((element) => item == element);
                updateParent(null);
                setState(() {});
              },
            ),
          ]));
        },
        dialogBox: true,
        isExpanded: true,
        doneButton: "Done",
      ),
      "Multi dialog editable items": SearchChoices.multiple(
        items: editableItems,
        selectedItems: editableSelectedItems,
        hint: "Select any",
        searchHint: "Select any",
        disabledHint: (Function updateParent) {
          return (TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                if (value != null) {
                  editableSelectedItems = [0];
                  updateParent(editableSelectedItems);
                }
              });
            },
            child: Text("No choice, click to add one"),
          ));
        },
        closeButton: (List<int> values, BuildContext closeContext,
            Function updateParent) {
          return (editableItems.length >= 100
              ? "Close"
              : TextButton(
            onPressed: () {
              addItemDialog().then((value) async {
                if (value != null) {
                  int itemIndex = editableItems
                      .indexWhere((element) => element.value == value);
                  if (itemIndex != -1) {
                    editableSelectedItems.add(itemIndex);
                    Navigator.pop(
                        TestingTesting.navKey.currentState?.overlay?.context ??
                            context);
                    updateParent(editableSelectedItems);
                  }
                }
              });
            },
            child: Text("Add and select item"),
          ));
        },
        onChanged: (values) {
          setState(() {
            if (!(values is NotGiven)) {
              editableSelectedItems = values;
            }
          });
        },
        displayItem: (item, selected, Function updateParent) {
          return (Row(children: [
            selected
                ? Icon(
              Icons.check_box,
              color: Colors.black,
            )
                : Icon(
              Icons.check_box_outline_blank,
              color: Colors.black,
            ),
            SizedBox(width: 7),
            Expanded(
              child: item,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                int indexOfItem = editableItems.indexOf(item);
                editableItems.removeWhere((element) => item == element);
                editableSelectedItems
                    .removeWhere((element) => element == indexOfItem);
                for (int i = 0; i < editableSelectedItems.length; i++) {
                  if (editableSelectedItems[i] > indexOfItem) {
                    editableSelectedItems[i]--;
                  }
                }
                updateParent(editableSelectedItems);
                setState(() {});
              },
            ),
          ]));
        },
        dialogBox: true,
        isExpanded: true,
        doneButton: "Done",
      ),
      "Single dialog dark mode": Card(
        color: Colors.black,
        child: SearchChoices.single(
          items: items.map((item) {
            return (DropdownMenuItem(
              child: Text(
                item.value,
                style: TextStyle(color: Colors.white),
              ),
              value: item.value,
            ));
          }).toList(),
          value: selectedValueSingleDialogDarkMode,
          hint: Text(
            "Select one",
            style: TextStyle(color: Colors.white),
          ),
          searchHint: Text(
            "Select one",
            style: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white, backgroundColor: Colors.black),
          closeButton: TextButton(
            onPressed: () {
              Navigator.pop(
                  TestingTesting.navKey.currentState?.overlay?.context ?? context);
            },
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ),
          ),
          menuBackgroundColor: Colors.black,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
          onChanged: (value) {
            setState(() {
              selectedValueSingleDialogDarkMode = value;
            });
          },
          isExpanded: true,
        ),
      ),
      "Single dialog ellipsis": SearchChoices.single(
        items: [
          DropdownMenuItem(
            child: Text(
              "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
              overflow: TextOverflow.ellipsis,
            ),
            value:
            "way too long text for a smartphone at least one that goes in a normal sized pair of trousers but maybe not for a gigantic screen like there is one at my cousin's home in a very remote country where I wouldn't want to go right now",
          )
        ],
        value: selectedValueSingleDialogEllipsis,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogEllipsis = value;
          });
        },
        selectedValueWidgetFn: (item) {
          return (Text(
            item,
            overflow: TextOverflow.ellipsis,
          ));
        },
        dialogBox: true,
        isExpanded: true,
      ),
      "Single dialog right to left": SearchChoices.single(
        items: ["طنجة", "فاس‎", "أكادير‎", "تزنيت‎", "آكــلــو", "سيدي بيبي"]
            .map<DropdownMenuItem<String>>((string) {
          return (DropdownMenuItem<String>(
            child: Text(
              string,
              textDirection: TextDirection.rtl,
            ),
            value: string,
          ));
        }).toList(),
        value: selectedValueSingleDialogRightToLeft,
        hint: Text(
          "ختار",
          textDirection: TextDirection.rtl,
        ),
        searchHint: Text(
          "ختار",
          textDirection: TextDirection.rtl,
        ),
        closeButton: TextButton(
          onPressed: () {
            Navigator.pop(
                TestingTesting.navKey.currentState?.overlay?.context ?? context);
          },
          child: Text(
            "سدّ",
            textDirection: TextDirection.rtl,
          ),
        ),
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialogRightToLeft = value;
          });
        },
        isExpanded: true,
        rightToLeft: true,
        displayItem: (item, selected) {
          return (Row(textDirection: TextDirection.rtl, children: [
            selected
                ? Icon(
              Icons.radio_button_checked,
              color: Colors.grey,
            )
                : Icon(
              Icons.radio_button_unchecked,
              color: Colors.grey,
            ),
            SizedBox(width: 7),
            item,
            Expanded(
              child: SizedBox.shrink(),
            ),
          ]));
        },
        selectedValueWidgetFn: (item) {
          return Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              (Text(
                item,
                textDirection: TextDirection.rtl,
              )),
            ],
          );
        },
      ),
      "Update value from outside the plugin": Column(
        children: [
          SearchChoices.single(
            items: items,
            value: selectedValueUpdateFromOutsideThePlugin,
            hint: Text('Select One'),
            searchHint: new Text(
              'Select One',
              style: new TextStyle(fontSize: 20),
            ),
            onChanged: (value) {
              setState(() {
                selectedValueUpdateFromOutsideThePlugin = value;
              });
            },
            isExpanded: true,
          ),
          TextButton(
            child: Text("Select dolor sit"),
            onPressed: () {
              setState(() {
                selectedValueUpdateFromOutsideThePlugin = "dolor sit";
              });
            },
          ),
        ],
      ),
      "Multi select 3 menu no-autofocus": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiSelect3Menu,
        hint: "Select 3 items",
        searchHint: "Select 3",
        validator: (selectedItemsForValidatorWithMenu) {
          if (selectedItemsForValidatorWithMenu.length != 3) {
            return ("Must select 3");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItemsMultiSelect3Menu = value;
          });
        },
        isExpanded: true,
        dialogBox: false,
        menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
        autofocus: false,
      ),
      "Multi dialog with count and wrap": SearchChoices.multiple(
        items: items,
        selectedItems: selectedItemsMultiDialogWithCountAndWrap,
        hint: "Select items",
        searchHint: "Select items",
        onChanged: (value) {
          setState(() {
            selectedItemsMultiDialogWithCountAndWrap = value;
          });
        },
        isExpanded: true,
        selectedValueWidgetFn: (item) {
          return (Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
            BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ),
          ));
        },
        selectedAggregateWidgetFn: (List<Widget> list) {
          return (Column(children: [
            Text("${list.length} items selected"),
            Wrap(children: list),
          ]));
        },
      ),
      "Single dialog open and set search terms": SearchChoices.single(
        label: Column(
          children: items.map((item) {
            return TextButton(
              child: item.child,
              onPressed: () {
                openDialog!(item.value.toString());
              },
            );
          }).toList(),
        ),
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        setOpenDialog: (externalOpenDialog) {
          openDialog = externalOpenDialog;
        },
      ),
      "Single dialog custom dialog": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        buildDropDownDialog: (
            Widget titleBar,
            Widget searchBar,
            Widget list,
            Widget closeButton,
            BuildContext dropDownContext,
            ) {
          return (AnimatedContainer(
            padding: MediaQuery.of(dropDownContext).viewInsets,
            duration: const Duration(milliseconds: 300),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 35, horizontal: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    titleBar,
                    searchBar,
                    list,
                    closeButton,
                  ],
                ),
              ),
            ),
          ));
        },
      ),
      "Single dialog custom searchInputDecoration": SearchChoices.single(
        items: items,
        value: selectedValueSingleDialog,
        hint: "Select one",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValueSingleDialog = value;
          });
        },
        isExpanded: true,
        searchInputDecoration: InputDecoration(
            icon: Icon(Icons.airline_seat_flat), border: OutlineInputBorder()),
      ),
    };

    return MaterialApp(
      navigatorKey: TestingTesting.navKey,
      home: asTabs
          ? DefaultTabController(
        length: widgets.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            actions: appBarActions,
            bottom: TabBar(
              isScrollable: true,
              tabs: Iterable<int>.generate(widgets.length)
                  .toList()
                  .map((i) {
                return (Tab(
                  text: (i + 1).toString(),
                ));
              }).toList(), //widgets.keys.toList().map((k){return(Tab(text: k));}).toList(),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: TabBarView(
              children: widgets
                  .map((k, v) {
                return (MapEntry(
                    k,
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Text(k),
                        SizedBox(
                          height: 20,
                        ),
                        v,
                      ]),
                    )));
              })
                  .values
                  .toList(),
            ),
          ),
        ),
      )
          : Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          actions: appBarActions,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: widgets
                .map((k, v) {
              return (MapEntry(
                  k,
                  Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Text("$k:"),
                                v,
                              ],
                            ),
                          )))));
            })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}