import 'package:ancientpeoplemobile/common/common.dart';
import 'package:ancientpeoplemobile/data/api/apis_service.dart';
import 'package:ancientpeoplemobile/data/model/knowledge_tree_model.dart';
import 'package:ancientpeoplemobile/ui/base_widget.dart';
import 'package:ancientpeoplemobile/ui/knowledge_detail_screen.dart';
import 'package:ancientpeoplemobile/utils/route_util.dart';
import 'package:ancientpeoplemobile/widgets/refresh_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// author Liu Yin
/// date 2020/6/20
/// Description:

class KnowledgeTreeScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return new KnowledgeTreeState();
  }
}

class KnowledgeTreeState extends BaseWidgetState<KnowledgeTreeScreen> {
  List<KnowledgeTreeBean> _list = new List();

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
      getKnowledgeTreeList();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
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

  Future getKnowledgeTreeList() async {
    apiService.getKnowledgeTreeList((KnowledgeTreeModel knowledgeTreeModel) {
      if (knowledgeTreeModel.errorCode == Constants.STATUS_SUCCESS) {
        if (knowledgeTreeModel.data.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted();
            setState(() {
              _list.clear();
              _list.addAll(knowledgeTreeModel.data);
            });
          });
        } else {
          showEmpty();
        }
      }
    }, (DioError error) {
      print(error.response);
      showError();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        onRefresh: getKnowledgeTreeList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _list.length,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "knowledge",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    KnowledgeTreeBean item = _list[index];
    return InkWell(
      onTap: (){
        print('点击');
        RouteUtil.push(context, KnowledgeDetailScreen(new ValueKey(item)));
      },
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          item.name,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: itemChildrenView(item.children),
                      )
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }

  Widget itemChildrenView(List<KnowledgeTreeChildBean> children) {
    List<Widget> titles = [];
    for (var item in children) {
      titles.add(new Text(
        item.name,
        style: TextStyle(color: Color(0xFF757575)),
      ));
    }
    return Wrap(
      spacing: 10,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      children: titles,
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
  }
}
