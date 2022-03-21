import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';
import 'package:we_pei_yang_flutter/commons/util/text_util.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/commons/widgets/loading.dart';
import 'package:we_pei_yang_flutter/feedback/feedback_router.dart';
import 'package:we_pei_yang_flutter/feedback/model/feedback_notifier.dart';
import 'package:we_pei_yang_flutter/feedback/network/feedback_service.dart';
import 'package:we_pei_yang_flutter/feedback/network/post.dart';
import 'package:we_pei_yang_flutter/feedback/util/color_util.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/icon_widget.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/long_text_shower.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/round_taggings.dart';
import 'package:we_pei_yang_flutter/main.dart';
import 'package:we_pei_yang_flutter/message/feedback_banner_widget.dart';

enum PostCardType { simple, detail, outSide }

typedef HitLikeCallback = void Function(bool, int);
typedef HitDislikeCallback = void Function(bool);

typedef HitFavoriteCallback = void Function(bool, int);

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onContentPressed;
  final VoidCallback onContentLongPressed;
  final bool showBanner;
  final PostCardType type;

  PostCard.simple(
    this.post, {
    this.onContentPressed,
    this.onContentLongPressed,
    this.showBanner = false,
    Key key,
  })  : type = PostCardType.simple,
        super(key: key);

  /// Card for DetailPage.
  PostCard.detail(
    this.post, {
    this.onContentPressed,
    this.onContentLongPressed,
    this.showBanner = false,
  }) : type = PostCardType.detail;

  PostCard.outSide(
    this.post, {
    this.onContentPressed,
    this.onContentLongPressed,
    this.showBanner = false,
  }) : type = PostCardType.outSide;

  @override
  _PostCardState createState() => _PostCardState(this.post);
}

class _PostCardState extends State<PostCard> {
  bool _picFullView;
  Post post;
  final String picBaseUrl = 'https://qnhdpic.twt.edu.cn/download/';

  _PostCardState(this.post);

  @override
  Widget build(BuildContext context) {
    var singlePictureLoader;
    var longPicOutsideLook;

    if (post.imageUrls != null && post.imageUrls.length == 1) {
      Image image = new Image.network(
        widget.type == PostCardType.detail
            ? picBaseUrl + 'origin/' + post.imageUrls[0]
            : picBaseUrl + 'thumb/' + post.imageUrls[0],
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
      Completer<ui.Image> completer = new Completer<ui.Image>();
      image.image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }));

      var limitedImage = _picFullView ?? false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                image,
                TextButton(
                    style: ButtonStyle(
                        alignment: Alignment.topRight,
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      setState(() {
                        _picFullView = false;
                      });
                    },
                    child: Text('收起',
                        style: TextUtil.base.textButtonBlue.w600.NotoSansSC
                            .sp(14))),
              ],
            )
          : SizedBox(
              height: WePeiYangApp.screenWidth * 1.2,
              child: Stack(children: [
                image,
                Positioned(top: 8, left: 8, child: TextPod('长图')),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _picFullView = true;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0, -0.7),
                          end: Alignment(0, 1),
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Text(
                            '点击展开\n',
                            style: TextUtil.base.w600.greyEB.sp(14).h(0.6),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16))),
                            padding: EdgeInsets.fromLTRB(12, 4, 10, 6),
                            child: Text(
                              '长图模式',
                              style: TextUtil.base.w300.white.sp(12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            );

      var longImageOuterLook = Stack(
        alignment: Alignment.topLeft,
        children: [image, Positioned(top: 4, left: 4, child: TextPod('长图'))],
      );

      longPicOutsideLook = new FutureBuilder<ui.Image>(
        //initialData: ,
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          return Container(
            width: 97,
            height: 76,
            child: snapshot.hasData
                ? snapshot.data.height / snapshot.data.width > 2.0
                    ? longImageOuterLook
                    : image
                : Icon(
                    Icons.refresh,
                    color: Colors.black54,
                  ),
            color: snapshot.hasData ? Colors.transparent : Colors.black12,
          );
        },
      );

      singlePictureLoader = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        child: new FutureBuilder<ui.Image>(
          future: completer.future,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.data.height / snapshot.data.width > 2.0
                    ? InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, FeedbackRouter.imageView,
                              arguments: {
                                "urlList": post.imageUrls,
                                "urlListLength": post.imageUrls.length,
                                "indexNow": 0,
                                "isLongPic": true
                              });
                        },
                        child: limitedImage)
                    : InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, FeedbackRouter.imageView,
                              arguments: {
                                "urlList": post.imageUrls,
                                "urlListLength": post.imageUrls.length,
                                "indexNow": 0,
                                "isLongPic": false
                              });
                        },
                        child: image)
                : Loading();
          },
        ),
      );
    }

    var title = Text(
      post.title,
      maxLines: widget.type == PostCardType.detail ? 3 : 1,
      overflow: TextOverflow.ellipsis,
      style: TextUtil.base.w500.NotoSansSC.sp(18).black2A,
    );

    var tag = post.type != 1
        ? post.tag != null
            ? '${post.tag.name}'
            : ''
        : post.department != null
            ? '${post.department.name}'
            : '';

    var id = post.type != 1
        ? post.tag != null && post.tag.id != null
            ? post.tag.id
            : -1
        : post.department != null
            ? post.department.id
            : -1;

    var campus = post.campus > 0
        ? Container(
            decoration: BoxDecoration(
                color: ColorUtil.backgroundColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorUtil.mainColor)),
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 1),
            child: Text(const ['', '卫津路', '北洋园'][post.campus],
                style: FontManager.YaHeiRegular.copyWith(
                    fontSize: 10, color: ColorUtil.mainColor)),
          )
        : SizedBox();

    var content = InkWell(
        onLongPress: () {
          Clipboard.setData(
              ClipboardData(text: '【' + post.title + '】 ' + post.content));
          ToastProvider.success('复制冒泡内容成功');
        },
        onTap: () async {
          if (widget.type == PostCardType.simple) {
            Navigator.pushNamed(
              context,
              FeedbackRouter.detail,
              arguments: post,
            ).then((p) {
              setState(() {
                post = p;
              });
            });
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: ExpandableText(
            text: post.content,
            maxLines: widget.type == PostCardType.detail ? 8 : 2,
            style: TextUtil.base.NotoSansSC.w400
                .sp(16)
                .black2A
                .h(widget.type == PostCardType.detail ? 1.2 : 1.4),
            expand: false,
            buttonIsShown: widget.type == PostCardType.detail,
          ),
        ));

    List<Widget> rowList = [];

    rowList.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            if (tag != '')
              TagShowWidget(
                  tag,
                  WePeiYangApp.screenWidth -
                      (post.campus > 0 ? 40 : 0) -
                      (widget.type == PostCardType.simple ? 240 : 120),
                  post.type,
                  id,
                  0),
            if (tag != '') SizedBox(width: 8),
            TagShowWidget(
                getTypeName(widget.post.type), 60, 0, 0, widget.post.type),
            SizedBox(width: 8),
            campus
          ]),
          SizedBox(height: 6),
          if (widget.type == PostCardType.detail)
            InkWell(
              onLongPress: () {
                Clipboard.setData(ClipboardData(
                    text: '【' + post.title + '】 ' + post.content));
                ToastProvider.success('复制提问成功');
              },
              onTap: () async {
                if (widget.type == PostCardType.simple) {
                  Navigator.pushNamed(
                    context,
                    FeedbackRouter.detail,
                    arguments: post,
                  ).then((p) {
                    setState(() {
                      post = p;
                    });
                  });
                }
              },
              child: title,
            ),
          if (widget.type == PostCardType.detail) SizedBox(height: 8),
          content,
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));

    if (widget.type == PostCardType.simple &&
        (post.imageUrls?.isNotEmpty ?? false)) {
      rowList.addAll([
        SizedBox(width: 10),
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: post.imageUrls.length == 1
                ? longPicOutsideLook
                : Image.network(
                    picBaseUrl + 'thumb/' + post.imageUrls[0],
                    width: 97,
                    height: 76,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                          width: 97,
                          height: 76,
                          padding: EdgeInsets.all(20),
                          child: Loading());
                    },
                  )),
      ]);
    }
    var createTime = Text(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(post.createAt.toLocal()),
      textAlign: TextAlign.right,
      style: TextUtil.base.black2A.bold.ProductSans.sp(12),
    );
    var createTimeDetail = Text(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(post.createAt.toLocal()),
      textAlign: TextAlign.right,
      style: TextUtil.base.grey6C.normal.ProductSans.sp(14),
    );
    var middleWidget =
        Row(children: rowList, crossAxisAlignment: CrossAxisAlignment.start);

    var mainWidget = (tap) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (widget.type == PostCardType.detail)
                  GestureDetector(
                    onLongPress: () {
                      return Clipboard.setData(ClipboardData(
                              text: '#MP' + post.id.toString().padLeft(6, '0')))
                          .whenComplete(
                              () => ToastProvider.success('复制帖子id成功，快去分享吧！'));
                    },
                    child: Text(
                      '#MP' + post.id.toString().padLeft(6, '0'),
                      style: TextUtil.base.w400.grey6C.ProductSans.sp(14),
                    ),
                  ),
                if (widget.type == PostCardType.simple)
                  SizedBox(width: WePeiYangApp.screenWidth - 164, child: title),
                Spacer(),
                SizedBox(width: 10),
                if (post.type != 1 && widget.type == PostCardType.simple)
                  MPWidget(post.id.toString().padLeft(6, '0')),
                if (post.solved == true &&
                    post.type == 1 &&
                    widget.type == PostCardType.simple)
                  SolvedWidget(),
                if (post.solved == false &&
                    post.type == 1 &&
                    widget.type == PostCardType.simple)
                  UnSolvedWidget(),
                if (widget.type == PostCardType.detail) createTimeDetail,
              ],
            ),
            SizedBox(height: 8),
            middleWidget,
          ],
        );

    var favoriteWidget = (widget.type == PostCardType.outSide)
        ? IconWidget(
            IconType.bottomFav,
            count: post.favCount,
            onLikePressed: (isFav, favCount, success, failure) async {
              await FeedbackService.postHitFavorite(
                id: post.id,
                isFavorite: post.isFav,
                onSuccess: () {
                  post.isFav = !isFav;
                  post.favCount = favCount;
                  success.call();
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                  failure.call();
                },
              );
            },
            isLike: post.isFav,
          )
        : IconWidget(
            IconType.fav,
            count: post.favCount,
            onLikePressed: (isFav, favCount, success, failure) async {
              await FeedbackService.postHitFavorite(
                id: post.id,
                isFavorite: post.isFav,
                onSuccess: () {
                  post.isFav = !isFav;
                  post.favCount = favCount;
                  success.call();
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                  failure.call();
                },
              );
            },
            isLike: post.isFav,
          );

    var commentWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SvgPicture.asset("assets/svg_pics/lake_butt_icons/comment.svg",
            width: 11.67.w),
        SizedBox(
          width: 5.17.w,
        ),
        Text(
          post.commentCount.toString() +
              (post.commentCount < 100 ? '   ' : ' '),
          style: TextUtil.base.ProductSans.black2A.normal.sp(12).w700,
        ),
      ],
    );
    var likeWidget = (widget.type == PostCardType.outSide)
        ? IconWidget(
            IconType.bottomLike,
            count: post.likeCount,
            onLikePressed: (isLike, likeCount, success, failure) async {
              await FeedbackService.postHitLike(
                id: post.id,
                isLike: post.isLike,
                onSuccess: () {
                  post.isLike = !post.isLike;
                  post.likeCount = likeCount;
                  if (post.isLike && post.isDis) {
                    post.isDis = !post.isDis;
                    setState(() {});
                  }
                  success.call();
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                  failure.call();
                },
              );
            },
            isLike: post.isLike,
          )
        : IconWidget(
            IconType.like,
            count: post.likeCount,
            onLikePressed: (isLike, likeCount, success, failure) async {
              await FeedbackService.postHitLike(
                id: post.id,
                isLike: post.isLike,
                onSuccess: () {
                  post.isLike = !post.isLike;
                  post.likeCount = likeCount;
                  if (post.isLike && post.isDis) {
                    post.isDis = !post.isDis;
                    setState(() {});
                  }
                  success.call();
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                  failure.call();
                },
              );
            },
            isLike: post.isLike,
          );

    var dislikeWidget = (widget.type == PostCardType.outSide)
        ? DislikeWidget(
            size: 22.w,
            isDislike: widget.post.isDis,
            onDislikePressed: (dislikeNotifier) async {
              await FeedbackService.postHitDislike(
                id: post.id,
                isDisliked: post.isDis,
                onSuccess: () {
                  post.isDis = !post.isDis;
                  if (post.isLike && post.isDis) {
                    post.isLike = !post.isLike;
                    post.likeCount--;
                    setState(() {});
                  }
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                },
              );
            },
          )
        : DislikeWidget(
            size: 15.w,
            isDislike: widget.post.isDis,
            onDislikePressed: (dislikeNotifier) async {
              await FeedbackService.postHitDislike(
                id: post.id,
                isDisliked: post.isDis,
                onSuccess: () {
                  post.isDis = !post.isDis;
                  if (post.isLike && post.isDis) {
                    post.isLike = !post.isLike;
                    post.likeCount--;
                    setState(() {});
                  }
                },
                onFailure: (e) {
                  ToastProvider.error(e.error.toString());
                },
              );
            },
          );

    var commentAndLike = [
      if (widget.type == PostCardType.simple) commentWidget,
      likeWidget,
      if (widget.type == PostCardType.outSide) favoriteWidget,
      dislikeWidget,
      SizedBox(width: 10)
    ];

    List<Widget> bottomList = [];
    List<Widget> imagesWidget = [];

    switch (widget.type) {
      case PostCardType.simple:
        bottomList.addAll([
          ...commentAndLike,
          Spacer(),
          createTime,
        ]);
        imagesWidget = [];
        break;
      case PostCardType.detail:
        bottomList.addAll([
          createTime,
          Spacer(),
          ...commentAndLike,
          favoriteWidget,
        ]);

        if (post.imageUrls.length > 1) {
          var imageList = Row(
            children: List.generate(
              post.imageUrls.length,
              (index) => _image(index, context),
            ),
          );
          imagesWidget.addAll([
            SizedBox(height: 10),
            imageList,
          ]);
        } else if (post.imageUrls.length == 1) {
          imagesWidget.add(singlePictureLoader);
        }

        imagesWidget.add(
          SizedBox(height: 10),
        );
        break;
      case PostCardType.outSide:
        bottomList.addAll([
          ...commentAndLike,
        ]);
        break;
    }

    var bottomWidget = Row(children: bottomList);

    var decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            blurRadius: 1.6,
            color: Colors.black12,
            offset: Offset(0, 0),
            spreadRadius: -1),
      ],
    );

    var body = GestureDetector(
        onTap: () async {
          if (widget.type == PostCardType.simple) {
            Navigator.pushNamed(
              context,
              FeedbackRouter.detail,
              arguments: post,
            ).then((p) {
              setState(() {
                post = p;
              });
            });
          }
        },
        child: FeedbackBannerWidget(
          showBanner: widget.showBanner,
          questionId: post.id,
          builder: (tap) => Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mainWidget(tap),
                SizedBox(height: 8.w),
                ...imagesWidget,
                if (widget.type != PostCardType.detail) bottomWidget,
              ],
            ),
            decoration: decoration,
          ),
        ));
    return widget.type != PostCardType.outSide
        ? Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.w, 16.w, 2.w),
            child: body,
          )
        : Row(
            children: [
              SizedBox(
                width: 10,
              ),
              ...commentAndLike,
            ],
          );
  }

  _image(index, context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, FeedbackRouter.imageView, arguments: {
          "urlList": post.imageUrls,
          "urlListLength": post.imageUrls.length,
          "indexNow": index
        });
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: Image.network(
              widget.type == PostCardType.detail
                  ? picBaseUrl + 'origin/' + post.imageUrls[index]
                  : picBaseUrl + 'thumb/' + post.imageUrls[index],
              fit: BoxFit.cover,
              width: (WePeiYangApp.screenWidth - 64.w) / post.imageUrls.length -
                  8.w,
              height: (WePeiYangApp.screenWidth - 64.w) /
                  post.imageUrls.length *
                  0.8,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: (WePeiYangApp.screenWidth - 64.w) / post.imageUrls.length -
                  8.w,
              height: (WePeiYangApp.screenWidth - 64.w) /
                  post.imageUrls.length *
                  0.8,
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(4),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.black12,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
              ),
            );
          }, errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
            return Text(
              '💔[图片加载失败]',
              style: TextUtil.base.grey6C.w400.sp(12),
            );
          }),
        ),
      ),
    );
  }

  String getTypeName(int type) {
    Map<int, String> typeName = {};
    context.read<LakeModel>().newPostTabList.forEach((e) {
      typeName.addAll({e.id: e.shortname});
    });
    return typeName[type];
  }
}
