import 'package:flutter/material.dart';
import 'package:skills/features/skills/presentation/pages/skillsMasterScreen.dart';
// import 'SkillsMasterScreen.dart';
import 'schedulerScreen.dart';
import 'homeScreen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static List<Widget> _routes = <Widget>[
    HomeScreen(),
    SkillsMasterScreen(),
    SchedulerScreen(),
  ];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _sideBySideBreakpoint = 600;
  int _fixedMenuBreakpoint = 850;

  var selectedValue = 0;

// @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.primaryVariant,
  //     body: SafeArea(child: _routes[_selectedIndex]),
  //     bottomNavigationBar:
  //         BottomNavigationBar(items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: 'Home',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.list),
  //         label: 'Skills',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.schedule),
  //         label: 'Sched',
  //       ),
  //     ], currentIndex: _selectedIndex, onTap: _itemTapped),
  //   );
  // }

// ******* rework *************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) {
            var showSideBySide = constraints.maxWidth > _sideBySideBreakpoint;
            return SkillsMasterScreen();
            // return Row(
            //   children: [
            //     Expanded(
            //       child: ListWidget(10, (value) {
            //         if (showSideBySide) {
            //           selectedValue = value;
            //           setState(() {});
            //         } else {
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context) {
            //               return DetailPage(value);
            //             },
            //           ));
            //         }
            //       }),
            //     ),
            //     showSideBySide
            //         ? Expanded(child: DetailWidget(selectedValue))
            //         : Container(),
            //   ],
            // );
            // if (useMasterDetail) {
            //   // return _buildMasterDetail(constraints);
            // } else {
            //   return Row(
            //     children: [_buildMaster(constraints)],
            //   );
            // }
          },
        ),
      ),
    );
  }

  Widget _buildMasterDetail(BoxConstraints constraints) {
    List<Widget> elements;
    if (constraints.maxWidth > _fixedMenuBreakpoint) {
      // md with fixed menu
      elements = [
        _buildFixedMenu(constraints),
        _buildMaster(constraints),
        _buildDetail(constraints)
      ];
    } else {
      // md with drawer menu
      elements = [_buildMaster(constraints), _buildDetail(constraints)];
    }
    return Row(
      children: elements,
    );
  }

  Widget _buildFixedMenu(BoxConstraints constraints) {
    return Container(
      color: Colors.white24,
      width: constraints.maxWidth / 10,
      height: constraints.maxHeight,
      child: Text('menu'),
    );
  }

  Widget _buildPhoneLayout() {}

  Widget _buildMaster(BoxConstraints constraints) {
    return Expanded(child: SkillsMasterScreen());
  }

  Widget _buildDetail(BoxConstraints constraints) {
    return Expanded(
      child: Container(
        color: Colors.white10,
        child: Center(
          child: Text('Detail'),
        ),
        width: constraints.maxWidth * .45,
        height: constraints.maxHeight,
      ),
    );
  }
  
}

class DetailPage extends StatefulWidget {
  final int data;

  DetailPage(this.data);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DetailWidget(widget.data),
    );
  }
}

typedef Null ItemSelectedCallback(int value);

class ListWidget extends StatefulWidget {
  final int count;
  final ItemSelectedCallback onItemSelected;

  ListWidget(this.count, this.onItemSelected);

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.count,
      itemBuilder: (context, position) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: InkWell(
              onTap: () {
                widget.onItemSelected(position);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      position.toString(),
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailWidget extends StatefulWidget {
  final int data;
  DetailWidget(this.data);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.data.toString(),
              style: TextStyle(fontSize: 36.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
