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
  int _selectedIndex = 1;

  static List<Widget> _routes = <Widget>[
    HomeScreen(),
    SkillsMasterScreen(),
    SchedulerScreen(),
  ];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
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

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _menuDrawer(),
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) {
            var showSideBySide = constraints.maxWidth > _sideBySideBreakpoint;
            return _routes[_selectedIndex];
          },
        ),
      ),
    );
  }

  void _menuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Container _menuDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Drawer(
        child: Container(
          color: Colors.grey[700],
          width: 60,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  child: Center(
                    child: Text("Header"),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _menuItemSelected(0);
                },
                icon: Icon(Icons.table_chart),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {
                  _menuItemSelected(1);
                },
                icon: Icon(Icons.list),
                iconSize: 36,
              ),
              IconButton(
                onPressed: () {
                  _menuItemSelected(2);
                },
                icon: Icon(Icons.schedule),
                iconSize: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }

//   Widget _buildMasterDetail(BoxConstraints constraints) {
//     List<Widget> elements;
//     if (constraints.maxWidth > _fixedMenuBreakpoint) {
//       // md with fixed menu
//       elements = [
//         _buildFixedMenu(constraints),
//         _buildMaster(constraints),
//         _buildDetail(constraints)
//       ];
//     } else {
//       // md with drawer menu
//       elements = [_buildMaster(constraints), _buildDetail(constraints)];
//     }
//     return Row(
//       children: elements,
//     );
//   }

//   Widget _buildFixedMenu(BoxConstraints constraints) {
//     return Container(
//       color: Colors.white24,
//       width: constraints.maxWidth / 10,
//       height: constraints.maxHeight,
//       child: Text('menu'),
//     );
//   }

//   Widget _buildPhoneLayout() {}

//   Widget _buildMaster(BoxConstraints constraints) {
//     return Expanded(child: SkillsMasterScreen());
//   }

//   Widget _buildDetail(BoxConstraints constraints) {
//     return Expanded(
//       child: Container(
//         color: Colors.white10,
//         child: Center(
//           child: Text('Detail'),
//         ),
//         width: constraints.maxWidth * .45,
//         height: constraints.maxHeight,
//       ),
//     );
//   }
// }

// class DetailPage extends StatefulWidget {
//   final int data;

//   DetailPage(this.data);

//   @override
//   _DetailPageState createState() => _DetailPageState();
// }

// class _DetailPageState extends State<DetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: DetailWidget(widget.data),
//     );
//   }
// }

// typedef Null ItemSelectedCallback(int value);

// class ListWidget extends StatefulWidget {
//   final int count;
//   final ItemSelectedCallback onItemSelected;

//   ListWidget(this.count, this.onItemSelected);

//   @override
//   _ListWidgetState createState() => _ListWidgetState();
// }

// class _ListWidgetState extends State<ListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.count,
//       itemBuilder: (context, position) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             child: InkWell(
//               onTap: () {
//                 widget.onItemSelected(position);
//               },
//               child: Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       position.toString(),
//                       style: TextStyle(fontSize: 22.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class DetailWidget extends StatefulWidget {
//   final int data;
//   DetailWidget(this.data);

//   @override
//   _DetailWidgetState createState() => _DetailWidgetState();
// }

// class _DetailWidgetState extends State<DetailWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               widget.data.toString(),
//               style: TextStyle(fontSize: 36.0, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}

class Hamburger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        });
  }
}
