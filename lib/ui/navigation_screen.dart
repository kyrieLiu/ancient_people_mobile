import 'package:ancientpeoplemobile/common/common.dart';
import 'package:ancientpeoplemobile/data/api/apis_service.dart';
import 'package:ancientpeoplemobile/data/model/navigation_model.dart';
import 'package:ancientpeoplemobile/ui/base_widget.dart';
import 'package:ancientpeoplemobile/utils/common_util.dart';
import 'package:ancientpeoplemobile/utils/route_util.dart';
import 'package:ancientpeoplemobile/utils/toast_util.dart';
import 'package:ancientpeoplemobile/widgets/refresh_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// author Liu Yin
/// date 2020/6/20
/// Description:

class NavigationScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new NavigationScreenState();
  }
}

class NavigationScreenState extends BaseWidgetState<NavigationScreen> {
  List<NavigationBean> _navigationList = new List();

  ScrollController _scrollController = new ScrollController();

  bool _isShowFAB = false;

  RefreshController _refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((value) {
      getNavigationList();
    });
    _scrollController.addListener(() {
      if (_scrollController.offset < 200 && _isShowFAB) {
        setState(() {
          _isShowFAB = false;
        });
      } else if (_scrollController.offset >= 200 && !_isShowFAB) {
        setState(() {
          _isShowFAB = true;
        });
      }
    });
  }

  Future getNavigationList() async {
    apiService.getNavigationList((NavigationModel navigationModel) {
      if (navigationModel.errorCode == Constants.STATUS_SUCCESS) {
        if (navigationModel.data.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted();
            setState(() {
              _navigationList.clear();
              _navigationList.addAll(navigationModel.data);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show(msg: navigationModel.errorMsg);
      }
    }, (DioError error) {
      showError();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getNavigationList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _navigationList.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "navigation",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              _navigationList[index].name,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: itemChildView(_navigationList[index].articles),
          )
        ],
      ),
    );
  }

  Widget itemChildView(List<NavigationArticleBean> children) {
    List<Widget> titles = [];
    Widget content;
    for (var item in children) {
      titles.add(new InkWell(
        onTap: () {
          print(item.link);
          RouteUtil.toWebView(context, item.title, item.link);
        },
        child: Chip(
          label: Text(
            item.title,
            style: TextStyle(
              fontSize: 12,
              color: CommonUtil.randomColor(),
            ),
          ),
          labelPadding: EdgeInsets.only(left: 3, right: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ));
    }
    content =
        Wrap(spacing: 2, alignment: WrapAlignment.start, children: titles);
    return content;
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getNavigationList();
    });
  }
}
