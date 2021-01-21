import 'package:flutter/material.dart';
import 'package:skills/features/skills/domain/entities/activity.dart';
import 'package:skills/features/skills/presentation/widgets/sessionEventCell.dart';

typedef ActivitiesSectionAddTappedCallback();
typedef ActivitiesSectionActivityTappedCallback(Activity activity);

class ActivitiesListSection extends StatefulWidget {
  final List<Activity> activities;
  final int completedActivitiesCount;
  final int availableTime;
  final ActivitiesSectionAddTappedCallback addTappedCallback;
  final ActivitiesSectionActivityTappedCallback eventTappedCallback;

  const ActivitiesListSection(
      {Key key,
      @required this.activities,
      @required this.completedActivitiesCount,
      @required this.addTappedCallback,
      @required this.eventTappedCallback,
      @required this.availableTime})
      : super(key: key);
  @override
  _ActivitiesListSectionState createState() => _ActivitiesListSectionState(
      activities,
      completedActivitiesCount,
      addTappedCallback,
      eventTappedCallback,
      availableTime);
}

class _ActivitiesListSectionState extends State<ActivitiesListSection> {
  final List<Activity> activities;
  final int completedActivitiesCount;
  final int availableTime;
  final ActivitiesSectionAddTappedCallback addTappedCallback;
  final ActivitiesSectionActivityTappedCallback eventTappedCallback;

  _ActivitiesListSectionState(this.activities, this.completedActivitiesCount,
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
    int count = activities.isEmpty ? 0 : completedActivitiesCount;
    String suffix = activities.isEmpty ? 'scheduled' : 'completed';
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
              Text('Activities', style: Theme.of(context).textTheme.subtitle1),
              Text('$countString',
                  style: Theme.of(context).textTheme.subtitle1),
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
    List sourceList = activities;
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SessionEventCell(
          activity: sourceList[index],
          callback: eventTappedCallback,
        );
      },
      itemCount: sourceList.length,
    );
  }
}
