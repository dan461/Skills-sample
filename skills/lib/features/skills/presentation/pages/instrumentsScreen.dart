import 'package:flutter/material.dart';
import 'package:skills/core/constants.dart';

class InstrumentsScreen extends StatelessWidget {
  final List instruments = INSTRUMENTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Instrument'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: instruments.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(instruments[index],
                        style: Theme.of(context).textTheme.headline6),
                    onTap: () {
                      Navigator.pop(context, instruments[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
