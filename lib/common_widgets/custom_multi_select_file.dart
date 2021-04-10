import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown/multiple_select.dart';

typedef OnConfirm(List selectedValues);

class CustomMultipleDropDown extends StatefulWidget {
  final List values;
  final List<MultipleSelectItem> elements;
  final String placeholder;
  final bool disabled;
  final Icon icon;

  CustomMultipleDropDown({
    Key key,
    @required this.values,
    @required this.elements,
    this.placeholder,
    this.disabled = false,
    this.icon,
  })  : assert(values != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => CustomMultipleDropDownState();
}

class CustomMultipleDropDownState extends State<CustomMultipleDropDown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Opacity(
              opacity: this.widget.disabled ? 0.4 : 1,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: this._getContent(),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 5.5),
                      child: widget.icon,
                    ),
                  ],
                ),

              ),
            ),
          ),
        ],
      ),
      onTap: () {
        if (!this.widget.disabled)
          MultipleSelect.showMultipleSelector(
            context,
            elements: this.widget.elements,
            values: this.widget.values,
            title: this.widget.placeholder,
          ).then((values) {
            this.setState(() {});
          });
      },
    );
  }

  Widget _getContent() {
    if (this.widget.values.length <= 0 && this.widget.placeholder != null) {
      return Padding(
        child: Text(
          this.widget.placeholder,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            decoration: TextDecoration.none,
          ),
        ),
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 10),
      );
    } else {
      return Wrap(
        children: this
            .widget
            .elements
            .where((element) => this.widget.values.contains(element.value))
            .map(
              (element) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: RawChip(
                  isEnabled: !this.widget.disabled,
                  label: Text(element.display),
                  onDeleted: () {
                    if (!this.widget.disabled) {
                      this.widget.values.remove(element.value);
                      this.setState(() {});
                    }
                  },
                ),
              ),
            )
            .toList(),
      );
    }
  }
}
