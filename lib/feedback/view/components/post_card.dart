import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:like_button/like_button.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';
import 'package:we_pei_yang_flutter/commons/util/text_util.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/feedback/network/post.dart';
import 'package:we_pei_yang_flutter/feedback/util/color_util.dart';
import 'package:we_pei_yang_flutter/feedback/feedback_router.dart';
import 'package:we_pei_yang_flutter/feedback/network/feedback_service.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/clip_copy.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/collect_widget.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/like_widget.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/round_taggings.dart';
import 'package:we_pei_yang_flutter/message/feedback_banner_widget.dart';

enum PostCardType { simple, detail }

typedef HitLikeCallback = void Function(bool, int);
typedef HitDislikeCallback = void Function(bool, int);

typedef HitCollectCallback = void Function(bool);

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onContentPressed;
  final HitLikeCallback onLikePressed;
  final HitDislikeCallback onDislikePressed;
  final HitCollectCallback onFavoritePressed;
  final VoidCallback onContentLongPressed;
  final bool showBanner;
  final PostCardType type;

  PostCard.simple(
    this.post, {
    this.onContentPressed,
    this.onLikePressed,
    this.onDislikePressed,
    this.onFavoritePressed,
    this.onContentLongPressed,
    this.showBanner = false,
    Key key,
  })  : type = PostCardType.simple,
        super(key: key);

  /// Card for DetailPage.
  PostCard.detail(
    this.post, {
    this.onContentPressed,
    this.onLikePressed,
    this.onDislikePressed,
    this.onFavoritePressed,
    this.onContentLongPressed,
    this.showBanner = false,
  }) : type = PostCardType.detail;

  @override
  _PostCardState createState() => _PostCardState(this.post);
}

class _PostCardState extends State<PostCard> {
  Post post;
  final String baseUrl = 'https://www.zrzz.site:7013/';

  _PostCardState(this.post);

  @override
  Widget build(BuildContext context) {
    var title = Expanded(
      child: Text(
        post.title,
        maxLines: widget.type == PostCardType.detail ? 3 : 1,
        overflow: TextOverflow.ellipsis,
        style: TextUtil.base.w500.normal.NotoSansSC.sp(18).black2A,
      ),
    );

    var tag =
        post.type == 0 ?
          post.tag != null ? '${post.tag.name}' : '无标签'
         :
          post.department != null ? '${post.department.name}' : '无部门';

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
        : Container();

    var content = Text(
      post.content,
      maxLines: widget.type == PostCardType.detail ? null : 2,
      overflow:
          widget.type == PostCardType.detail ? null : TextOverflow.ellipsis,
      style: FontManager.NotoSansSCRegular.copyWith(
        color: ColorUtil.bold42TextColor,
      ),
    );

    List<Widget> rowList = [];

    rowList.add(Expanded(
      child: Column(
        children: [
          Row(children: [
            TagShowWidget(tag),
            SizedBox(width: 8),
            campus
          ]),
          SizedBox(height: 8),
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
          child: Image.network(
            baseUrl + post.imageUrls[0],
            width: 80,
            height: 76,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ]);
    }

    var middleWidget = Row(children: rowList);

    var mainWidget = (tap) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  title,
                  SizedBox(width: 10),
                  if (post.solved== 1 && post.type == 1) SolvedWidget(),
                  if (post.solved == 0 && post.type == 1) UnSolvedWidget(),
                ],
              ),
              SizedBox(height: 5),
              middleWidget,
            ],
          ),
          onTap: () async {
            if (widget.type == PostCardType.simple) {
              widget.onContentPressed?.call();
              await tap?.call();
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
          onLongPress: widget.onContentLongPressed,
        );

    var collectButton = CollectWidget(
      onCollectPressed: (boolNotifier) async {
        FeedbackService.postHitFavorite(
          id: post.id,
          isFavorite: post.isFav,
          onSuccess: () {
            widget.onFavoritePressed?.call(boolNotifier.value);
            post.isFav = !post.isFav;
          },
          onFailure: (e) {
            boolNotifier.value = boolNotifier.value;
            ToastProvider.error(e.error.toString());
          },
        );
      },
      isCollect: post.isFav,
    );

    var createTime = Text(
      DateFormat('yyyy-MM-dd HH:mm:ss').format(post.createAt),
      textAlign: TextAlign.right,
      style: TextUtil.base.black2A.bold.ProductSans.sp(12),
    );

    List<Widget> commentCount = [
      ClipOval(
        child: Icon(
          Icons.message_outlined,
          size: ScreenUtil().setSp(11.67),
          color: ColorUtil.bold42TextColor,
        ),
      ),
      SizedBox(width: 6),
      Text(
        post.commentCount.toString(),
        style: TextUtil.base.black2A.bold.ProductSans.sp(12),
      )
    ];

    var likeWidget = LikeWidget(
      count: post.likeCount,
      onLikePressed: (isLike, likeCount, success, failure) async {
        await FeedbackService.postHitLike(
          id: post.id,
          isLike: post.isLike,
          onSuccess: () {
            widget.onLikePressed?.call(!isLike, likeCount);
            post.isLike = !isLike;
            post.likeCount = likeCount;
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

    var dislikeWidget = LikeButton(
      likeBuilder: (bool isDisliked) {
        if (isDisliked) {
          return Icon(
            Icons.thumb_down,
            size: 16,
            color: Colors.blueGrey[900],
          );
        } else {
          return Icon(
            Icons.thumb_down_outlined,
            size: ScreenUtil().setSp(11.67),
            color: ColorUtil.boldTextColor,
          );
        }
      },
      circleColor: CircleColor(start: Colors.black12, end: Colors.blue[200]),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Colors.blueGrey,
        dotSecondaryColor: Colors.black26,
      ),
      animationDuration: Duration(milliseconds: 600),
      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
    );

    var commentAndLike = [
      ...commentCount,
      SizedBox(width: 5),
      // Like count.
      likeWidget,
      SizedBox(width: 5),
      dislikeWidget
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
          collectButton,
        ]);

        if (post.imageUrls.isNotEmpty) {
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
          imagesWidget.add(InkWell(
              onTap: () {
                Navigator.pushNamed(context, FeedbackRouter.imageView,
                    arguments: {
                      "urlList": post.imageUrls,
                      "urlListLength": post.imageUrls.length,
                      "indexNow": 0
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: post.imageUrls[0]),
              )));
        }

        imagesWidget.add(
          SizedBox(height: 10),
        );
        break;
    }

    var bottomWidget = Row(children: bottomList);

    var decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            blurRadius: 5,
            color: Color.fromARGB(64, 236, 237, 239),
            offset: Offset(0, 0),
            spreadRadius: 3),
      ],
    );

    var body = FeedbackBannerWidget(
      showBanner: widget.showBanner,
      questionId: post.id,
      builder: (tap) => Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mainWidget(tap),
            SizedBox(height: 8),
            ...imagesWidget,
            bottomWidget,
          ],
        ),
        decoration: decoration,
      ),
    );

    return DefaultTextStyle(
      style: FontManager.YaHeiRegular,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: ClipCopy(
          toast: '复制提问成功',
          copy: post.content,
          child: body,
        ),
      ),
    );
  }

  _image(index, context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, FeedbackRouter.imageView, arguments: {
            "urlList": post.imageUrls,
            "urlListLength": post.imageUrls.length,
            "indexNow": index
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                height: 200 - (post.imageUrls.length) * 30.0,
                placeholder: kTransparentImage,
                image: baseUrl + post.imageUrls[index]),
          ),
        ),
      ),
    );
  }
}
