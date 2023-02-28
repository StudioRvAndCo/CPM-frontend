import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewSequenceDialog extends StatefulWidget {
  const NewSequenceDialog({super.key, required this.locations});

  final List<String> locations;

  @override
  State<StatefulWidget> createState() => _NewSequenceDialogState(locations: locations);
}

class _NewSequenceDialogState extends State<NewSequenceDialog> {
  _NewSequenceDialogState({required this.locations});

  String? title;
  String? description;
  DateTimeRange? dates;
  final List<String> locations;
  String? selectedLocation;
  String dateText = '';

  @override
  void initState() {
    updateDateText();
    selectedLocation = locations.first;
    return super.initState();
  }

  void updateDateText() {
    String res;
    if (dates != null) {
      final String firstText = DateFormat.yMd(Intl.systemLocale).format(dates!.start);
      final String lastText = DateFormat.yMd(Intl.systemLocale).format(dates!.end);
      res = '$firstText - $lastText';
    } else {
      res = 'Enter production dates';
    }
    setState(() {
      dateText = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(6.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Text>[
                  Text('New Sequence'),
                  Text(
                    'Create a new sequence.',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: SizedBox(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    child: TextFormField(
                      maxLength: 64,
                      decoration:
                          const InputDecoration(labelText: 'Title', border: OutlineInputBorder(), isDense: true),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    child: TextFormField(
                      maxLength: 280,
                      maxLines: 4,
                      decoration:
                          const InputDecoration(labelText: 'Description', border: OutlineInputBorder(), isDense: true),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1970),
                            lastDate: DateTime(3000),
                            initialDateRange: dates);
                        if (picked != null) {
                          dates = DateTimeRange(start: picked.start, end: picked.end);
                          updateDateText();
                        }
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(dateText),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Value'),
                    items: locations.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: selectedLocation,
                    onChanged: (String? value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                )
              ]),
            ),
          ),
        )
      ],
    );
  }
}