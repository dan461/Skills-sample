import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/widgets/sessionEventCell.dart';

typedef ActivitiesSectionAddTappedCallback();
typedef ActivitiesSectionEventTappedCallback(Map<String, dynamic> map);

class ActivitiesListSection extends StatefulWidget {
  final List<Map> activityMaps;
  final int completedActivitiesCount;
  final int availableTime;
  final ActivitiesSectionAddTappedCallback addTappedCallback;
  final ActivitiesSectionEventTappedCallback eventTappedCallback;

  const ActivitiesListSection(
      {Key key,
      @required this.activityMaps,
      @required this.completedActivitiesCount,
      @required this.addTappedCallback,
      @required this.eventTappedCallback,
      @required this.availableTime})
      : super(key: key);
  @override
  _ActivitiesListSectionState createState() => _ActivitiesListSectionState(
      activityMaps,
      completedActivitiesCount,
      addTappedCallback,
      eventTappedCallback,
      availableTime);
}

class _ActivitiesListSectionState extends State<ActivitiesListSection> {
  final List<Map> activityMaps;
  final int completedActivitiesCount;
  final int availableTime;
  final ActivitiesSectionAddTappedCallback addTappedCallback;
  final ActivitiesSectionEventTappedCallback eventTappedCallback;

  _ActivitiesListSectionState(this.activityMaps, this.completedActivitiesCount,
      this.addTappedCallback, this.eventTappedCallback, this.availableTime);

  bool get _plusButtonEnabled {
    return availableTime > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_activitiesHeaderBuilder(), _activitiesListBuilder()],
    );
  }

  Widget _activitiesHeaderBuilder() {
    int count = activityMaps.isEmpty ? 0 : completedActivitiesCount;
    String suffix = activityMaps.isEmpty ? 'scheduled' : 'completed';
    String countString = count.toString() + ' $suffix';

    return Container(
        height: 40,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Activities', style: Theme.of(context).textTheme.subhead),
              Text('$countString', style: Theme.of(context).textTheme.subhead),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _plusButtonEnabled
                    ? () {
                        addTappedCallback();
                      }
                    : null,
              )
            ],
          ),
        ));
  }

  ListView _activitiesListBuilder() {
    List sourceList = activityMaps;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SessionEventCell(
          map: sourceList[index],
          callback: eventTappedCallback,
        );
      },
      itemCount: sourceList.length,
    );
  }
}