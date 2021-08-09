import 'package:brahminapp/common_widgets/CustomSearchableDropdown.dart';
import 'package:flutter/material.dart';

class SamagriPage extends StatefulWidget {
  final mainSamagriList;

  const SamagriPage({Key? key, this.mainSamagriList}) : super(key: key);

  @override
  _SamagriPageState createState() => _SamagriPageState();
}

class _SamagriPageState extends State<SamagriPage> {
  List<DropdownMenuItem> samagriItems = [];
  List<int> selectedSamagriIndex = [];

  @override
  void initState() {
    print("hello ");
    for (int i = 0; i < widget.mainSamagriList!.length; i++) {
      // print("${widget.mainSamagriList[i]}");
      samagriItems.add(DropdownMenuItem(
          value: "${widget.mainSamagriList[i]["name"][0]}",
          child: Text("${widget.mainSamagriList[i]["name"][0]}")));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          // height: MagicScreen(height: 50, context: context).getHeight,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.deepOrange,
                  width: 1,
                  style: BorderStyle.solid)),
          child: SearchChoices.multiple(
            isExpanded: true,
            displayClearIcon: false,
            underline: SizedBox(),
            onChanged: (value) {
              setState(() {
                selectedSamagriIndex = value;
              });
            },
            selectedItems: selectedSamagriIndex,
            closeButton: (selectedItems) {
              return (selectedItems.isNotEmpty
                  ? "Save ${selectedItems.length == 1 ? '"' + samagriItems[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                  : "Save without selection");
            },
            items: samagriItems,
            icon: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
