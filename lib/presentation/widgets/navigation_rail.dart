import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Author: Dashkevich Andrey
/// Data: 16.03.2020
/// Navigation rail  implementation from Material 2.0
/// Widget предоставляет способ навигации по категориям

typedef Widget _OnChangeCallback(BuildContext context, int index);
typedef void _OnTapCallback(int id);

class NavigationRail extends StatefulWidget {
  NavigationRail.destinations(
      {Key key, @required this.onChange, @required this.onTap,  @required this.destinations})
      : assert(destinations != null && onChange != null),
        super(key: key);
  final _OnChangeCallback onChange;
  final _OnTapCallback onTap;
  final List<RailDestination> destinations;

  @override
  _NavigationRailState createState() => _NavigationRailState();
}

class _NavigationRailState extends State<NavigationRail>{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 72,
            child: Card(
              elevation: 14,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  children: widget.destinations
                      .asMap()
                      .entries
                      .map<Widget>((MapEntry<int, RailDestination> item) {
                    return RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          widget.onTap(item.key);
                          _currentIndex = item.key;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: <Widget>[
                            Icon(item.value.icon, color: item.key == _currentIndex ? Colors.black : Colors.black26,),
                            AutoSizeText(item.value.caption, maxLines: 1, textScaleFactor: 0.85,)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.easeInCirc,
              transitionBuilder: (widget, animation){
                return FadeTransition(
                  opacity: animation,
                  child: widget,
                );
              },
              child: widget.onChange(context, _currentIndex),
            ),
          )
        ],
      ),
    );
  }
}

class RailDestination {
  const RailDestination(
      {@required this.icon, @required this.caption,})
      : assert(icon != null && caption != null);
  final IconData icon;
  final String caption;
}
