import 'package:flutter/material.dart';
import 'bs_date.dart';
import 'data/events/events.dart';
import 'data/translations.dart';
import 'date_utils.dart';


final _radius = 15.0;
final _circularRadius = Radius.circular(_radius);

class DayDialog extends StatelessWidget {
  final BSDate date;

  const DayDialog({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dialogBackgroundColor: Colors.transparent,
    );
    return Theme(
      data: theme,
      child: Dialog(
        child: Column(
          children: <Widget>[
            _DayBadge(date: date),
            Flexible(child: _Events(date: date)),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final BSDate date;

  const _DayBadge({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greg = date.toGregorian();
    final _isToday = DateUtils.isToday(greg);
    final _isSaturday = DateUtils.isSaturday(greg);
    final _events = events(date);
    final _isHoliday = _events != null ? _events['isHoliday'] == true : false;

    final textTheme = Theme.of(context).textTheme;
    // ignore: deprecated_member_use
    final largeText = textTheme.display4.apply(
      color: _isToday || _isSaturday || _isHoliday
          ? Colors.grey[50]
          : Colors.grey[800],
    );
    // ignore: deprecated_member_use
    final mediumText = textTheme.display1.apply(
      color: _isToday || _isSaturday || _isHoliday
          ? Colors.grey[200]
          : Colors.grey[800],
    );
    // ignore: deprecated_member_use
    final smallText = textTheme.title.apply(
      color: _isSaturday || _isHoliday
          ? Colors.red[200]
          : _isToday ? Colors.blue[200] : Colors.grey[400],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: _isSaturday || _isHoliday
              ? Colors.red
              : _isToday ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: _circularRadius,
            topRight: _circularRadius,
          )),
      child: Column(
        children: <Widget>[
          Text(
            intoDevnagariNumeral(date.day),
            style: largeText,
          ),
          Text(date.monthText(), style: mediumText),
          Text(
            '${intoDevnagariNumeral(greg.day)} '
                '${gregorianMonths(greg.month)} '
                '${intoDevnagariNumeral(greg.year)}',
            style: smallText,
          ),
        ],
      ),
    );
  }
}

class _Events extends StatelessWidget {
  final BSDate date;

  const _Events({Key key, @required this.date})
      : assert(date != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _events = events(date);
    final hasEvents = _events != null
        ? (_events['eventsNp'] as List<String>).length != 0
        : false;
    final eventsList = _events != null
        ? _events['eventsNp'] as List<String>
        : ['कुनै कार्यक्रम छैन'];

    return Container(
      padding: EdgeInsets.only(bottom: _radius),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: _circularRadius,
          bottomRight: _circularRadius,
        ),
      ),
      child: ListView.separated(
        itemCount: eventsList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final text = Text(
            eventsList[index],
            style: TextStyle(color: !hasEvents ? Colors.grey : null),
          );

          return ListTile(
            title: hasEvents ? text : Container(child: Center(child: text)),
          );
        },
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
    );
  }
}
