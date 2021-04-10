import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double radius;
  final Widget child;


  const CustomContainer(
      {Key key, this.radius, this.child,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.deepOrangeAccent,
              style: BorderStyle.solid,
              width: 0.5),

          borderRadius: BorderRadius.circular(radius),
        ),
        child: child);
  }
}

class CustomTextField extends StatelessWidget {
  final String initialValue;
  final lableText;
  final FormFieldSetter<String> onSaved;
  final int maxLength;


  const CustomTextField(
      {Key key,
      this.initialValue,
      this.lableText,
      @required this.onSaved,
      this.maxLength,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLength: maxLength ?? null,
        maxLines: null,
        decoration:
            InputDecoration(border: InputBorder.none, labelText: lableText),
        initialValue: initialValue,
        onSaved: onSaved //_benefits = value,
        );
  }
}

class CustomDropdownContainer extends Container {
  final String title;
  final String value;
  final Widget child;

  CustomDropdownContainer(
      {Key key, @required this.title, this.value, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radius: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            children: [
              Text(
                value,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
              ),
              child,
            ],
          )
        ],
      ),
    );
  }
}

typedef ValueChanged<T> = void Function(T value);

class CustomDropdown extends DropdownButton {
  final Colors iconColor;
  final List<DropdownMenuItem> items;
  final ValueChanged<dynamic> function;

  CustomDropdown({Key key, this.iconColor, this.items, this.function})
      // ignore: missing_required_param
      : super(key: key);

  Widget build(BuildContext context) {
    return DropdownButton(
        icon: Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Colors.deepOrangeAccent,
        ),
        underline: SizedBox(),
        style: TextStyle(color: Colors.green),
        //value: price,
        items: items,
        onChanged: function);
  }
}
