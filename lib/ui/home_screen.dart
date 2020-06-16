import 'package:ancientpeoplemobile/common/common.dart';
import 'package:ancientpeoplemobile/data/api/apis_service.dart';
import 'package:ancientpeoplemobile/data/model/article_model.dart';
import 'package:ancientpeoplemobile/data/model/banner_model.dart';
import 'package:ancientpeoplemobile/ui/base_widget.dart';
import 'package:ancientpeoplemobile/utils/route_util.dart';
import 'package:ancientpeoplemobile/utils/toast_util.dart';
import 'package:ancientpeoplemobile/widgets/ItemArticleList.dart';
import 'package:ancientpeoplemobile/widgets/custom_cache_image.dart';
import 'package:ancientpeoplemobile/widgets/refresh_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends BaseWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return super.createState();
  }

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends BaseWidgetState<HomeScreen> {
  //首页轮播图
  List<BannerBean> _bannerList = new List();

  //首页文章列表数据
  List<ArticleBean> _articles = new List();

  //listView控制器
  ScrollController _scrollController = new ScrollController();

  //是否显示悬浮按钮
  bool _isShowFAB = false;

  //页码
  int _page = 0;

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
    _bannerList.add(null);
    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
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

  Future getBannerList() async {
    apiService.getBannerList((BannerModel bannerModel) {
      if (bannerModel.data.length > 0) {
        showContent().then((value) => {
              setState(() {
                _bannerList = bannerModel.data;
              })
            });
      }
    });
  }

  ///获取指定文章
  Future getTopArticleList() async {
    apiService.getTopArticleList((TopArticleModel topArticleModel) {
      if (topArticleModel.errorCode == Constants.STATUS_SUCCESS) {
        topArticleModel.data.forEach((element) {
          element.top = 1;
        });
        _articles.clear();
        _articles.addAll(topArticleModel.data);
      }
      getArticleList();
    }, (DioError error) {
      showError();
    });
  }

  Future getArticleList() async {
    _page = 0;
    apiService.getArticleList(
        (ArticleModel model) => {
              if (model.errorCode == Constants.STATUS_SUCCESS)
                {
                  if (model.data.datas.length > 0)
                    {
                      showContent().then((value) {
                        _refreshController.refreshCompleted(
                            resetFooterState: true);
                        setState(() {
                          _articles.addAll(model.data.datas);
                        });
                      })
                    }
                  else
                    {showEmpty()}
                }
            }, (DioError error) {
      showError();
    }, _page);
  }

  /// 获取更多文章列表数据
  Future getMoreArticleList() async {
    _page++;
    apiService.getArticleList((ArticleModel model) {
      if (model.errorCode == Constants.STATUS_SUCCESS) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _articles.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _page);
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      // body: Container(child: Text("aaaaa")),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: RefreshFooter(),
        controller: _refreshController,
        onRefresh: getTopArticleList,
        onLoading: getMoreArticleList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: new AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _articles.length + 1,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: "home",
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 1000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
          height: 200, color: Colors.transparent, child: _buildBannerWidget());
    }
    ArticleBean item = _articles[index - 1];
    //return Item
    return ItemArticleList(
      item: item,
    );
  }

  Widget _buildBannerWidget() {
    return Offstage(
      offstage: _bannerList.length == 0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          if (index >= _bannerList.length ||
              _bannerList[index] == null ||
              _bannerList[index].imagePath == null) {
            return new Container(height: 0);
          } else {
            return InkWell(
              child: Container(
                child: CustomCachedImage(
                  imageUrl: _bannerList[index].imagePath,
                ),
              ),
              onTap: () {
                RouteUtil.toWebView(
                    context, _bannerList[index].title, _bannerList[index].url);
              },
            );
          }
        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

//  @override
//  AppBar attachAppBar() {
//    return  Container();
//  }
  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) => {getBannerList()});
  }
}
