import 'package:ancientpeoplemobile/ui/home_screen.dart';
import 'package:ancientpeoplemobile/ui/splash_screen.dart';
import 'package:ancientpeoplemobile/utils/utils.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController = PageController();

  int _selectedIndex = 0;

  final bottomBarTitles = ["首页", "广场", "公众号", "体系", "项目"];

  var pages = <Widget>[
    HomeScreen(),
    SplashScreen(),
    SplashScreen(),
    SplashScreen(),
    SplashScreen(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(bottomBarTitles[_selectedIndex]),
            bottom: null,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon:
                    _selectedIndex == 1 ? Icon(Icons.add) : Icon(Icons.search),
                onPressed: () {
                  if (_selectedIndex == 1) {}
                },
              )
            ],
          ),
          body: PageView.builder(
            itemBuilder: (context, index) => pages[index],
            itemCount: pages.length,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: buildImage(0, "ic_home"),
                  title: Text(bottomBarTitles[0])),
              BottomNavigationBarItem(
                  icon: buildImage(1, "ic_square_line"),
                  title: Text(bottomBarTitles[1])),
              BottomNavigationBarItem(
                  icon: buildImage(2, "ic_wechat"),
                  title: Text(bottomBarTitles[2])),
              BottomNavigationBarItem(
                  icon: buildImage(3, "ic_system"),
                  title: Text(bottomBarTitles[3])),
              BottomNavigationBarItem(
                  icon: buildImage(4, "ic_project"),
                  title: Text(bottomBarTitles[4]))
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
        onWillPop: _onWillPop);
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text("提示"),
                  content: new Text("确定退出应用吗"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text(
                        '再看一会',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                    FlatButton(
                      child: new Text(
                        "退出",
                        style: TextStyle(color: Colors.cyan),
                      ),
                      onPressed: () => {
                        Navigator.of(context).pop(true),
                      },
                    )
                  ],
                )) ??
        false;
  }

  Widget buildImage(index, iconPath) {
    return Image.asset(
      Utils.getImgPath(iconPath),
      width: 22,
      height: 22,
      color: _selectedIndex == index
          ? Theme.of(context).primaryColor
          : Colors.grey[600],
    );
  }
}
