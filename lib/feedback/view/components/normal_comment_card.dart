import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:we_pei_yang_flutter/commons/environment/config.dart';
import 'package:we_pei_yang_flutter/commons/extension/extensions.dart';
import 'package:we_pei_yang_flutter/commons/preferences/common_prefs.dart';
import 'package:we_pei_yang_flutter/commons/util/dialog_provider.dart';
import 'package:we_pei_yang_flutter/commons/util/text_util.dart';
import 'package:we_pei_yang_flutter/commons/util/toast_provider.dart';
import 'package:we_pei_yang_flutter/commons/widgets/loading.dart';
import 'package:we_pei_yang_flutter/feedback/feedback_router.dart';
import 'package:we_pei_yang_flutter/feedback/model/feedback_notifier.dart';
import 'package:we_pei_yang_flutter/feedback/network/post.dart';
import 'package:we_pei_yang_flutter/feedback/util/color_util.dart';
import 'package:we_pei_yang_flutter/feedback/network/feedback_service.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/pop_menu_shape.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/clip_copy.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/icon_widget.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/long_text_shower.dart';
import 'package:we_pei_yang_flutter/feedback/view/components/widget/round_taggings.dart';
import 'package:we_pei_yang_flutter/feedback/view/reply_detail_page.dart';
import 'package:we_pei_yang_flutter/feedback/view/report_question_page.dart';
import 'package:we_pei_yang_flutter/generated/l10n.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_pei_yang_flutter/main.dart';

typedef LikeCallback = void Function(bool, int);
typedef DislikeCallback = void Function(bool);

class NCommentCard extends StatefulWidget {
  final String ancestorName;
  final int ancestorUId;
  final Floor comment;
  final int uid;
  final int commentFloor;
  final LikeCallback likeSuccessCallback;
  final DislikeCallback dislikeSuccessCallback;
  final bool isSubFloor;
  final bool isFullView;

  @override
  _NCommentCardState createState() => _NCommentCardState();

  NCommentCard(
      {this.ancestorName,
      this.ancestorUId,
      this.comment,
      this.uid,
      this.commentFloor,
      this.likeSuccessCallback,
      this.dislikeSuccessCallback,
      this.isSubFloor,
      this.isFullView});
}

class _NCommentCardState extends State<NCommentCard>
    with SingleTickerProviderStateMixin {
  ScrollController _sc;

  //final String picBaseUrl = 'https://qnhdpic.twt.edu.cn/download/';
  final String picBaseUrl = '${EnvConfig.QNHDPIC}download/';
  bool _picFullView = false, _isDeleted = false;
  static WidgetBuilder defaultPlaceholderBuilder =
      (BuildContext ctx) => SizedBox(
            width: 24,
            height: 24,
            child: FittedBox(fit: BoxFit.fitWidth, child: Loading()),
          );

  Future<bool> _showDeleteConfirmDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return LakeDialogWidget(
              title: '删除评论',
              content: Text('您确定要删除这条评论吗？'),
              cancelText: "取消",
              confirmTextStyle:
                  TextUtil.base.normal.black2A.NotoSansSC.sp(16).w400,
              cancelTextStyle:
                  TextUtil.base.normal.black2A.NotoSansSC.sp(16).w400,
              confirmText: "确认",
              cancelFun: () {
                Navigator.of(context).pop();
              },
              confirmFun: () {
                Navigator.of(context).pop(true);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    var topWidget = Row(
      children: [
        Container(
          decoration: DateTime.now().month == 4 && DateTime.now().day == 1
              ? BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/lake_butt_icons/jokers.png'),
                      fit: BoxFit.contain),
                )
              : BoxDecoration(),
          child: Padding(
            padding: DateTime.now().month == 4 && DateTime.now().day == 1
                ? const EdgeInsets.all(10)
                : const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child:
                  // Image.asset(
                  //   'assets/images/lake_butt_icons/monkie.png',
                  //   //'${EnvConfig.QNHD}avatar/beam/20/${widget.comment.postId}+${widget.comment.nickname}',
                  //   width: 30,
                  //   height: 24,
                  //   fit: BoxFit.fitHeight,
                  //   //placeholderBuilder: defaultPlaceholderBuilder,
                  // ),
                  SvgPicture.network(
                //'https://qnhd.twt.edu.cn/avatar/beam/20/${widget.comment.postId}+${widget.comment.nickname}',
                '${EnvConfig.QNHD}avatar/beam/20/${widget.comment.postId}+${widget.comment.nickname}',
                width: DateTime.now().month == 4 && DateTime.now().day == 1
                    ? 18
                    : 24,
                height: DateTime.now().month == 4 && DateTime.now().day == 1
                    ? 18
                    : 24,
                fit: BoxFit.contain,
                placeholderBuilder: defaultPlaceholderBuilder,
              ),
            ),
          ),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    widget.comment.nickname ?? "匿名用户",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextUtil.base.black2A.w400.NotoSansSC.sp(14),
                  ),
                  CommentIdentificationContainer(
                      widget.comment.isOwner
                          ? '我的评论'
                          : widget.comment.uid == widget.uid
                              ? widget.isSubFloor &&
                                      widget.comment.nickname ==
                                          widget.ancestorName
                                  ? '楼主 层主'
                                  : '楼主'
                              : widget.isSubFloor &&
                                      widget.comment.nickname ==
                                          widget.ancestorName
                                  ? '层主'
                                  : '',
                      true),
                  //回复自己那条时出现
                  if (widget.comment.replyToName != '' &&
                      widget.comment.replyTo != widget.ancestorUId)
                    widget.comment.isOwner &&
                            widget.comment.replyToName ==
                                widget.comment.nickname
                        ? CommentIdentificationContainer('回复我', true)
                        : SizedBox(),
                  //后面有东西时出现
                  if (widget.comment.replyToName != '' &&
                      widget.comment.replyTo != widget.ancestorUId)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 2),
                        Icon(Icons.play_arrow, size: 8),
                        SizedBox(width: 2),
                        Text(
                          widget.comment.replyToName ?? "",
                          style: TextUtil.base.grey6C.w400.NotoSansSC.sp(12),
                        ),
                        SizedBox(width: 2)
                      ],
                    ),
                  //回的是楼主并且楼主不是层主或者楼主是层主的时候回复的不是这条评论
                  //回的是层主但回复的不是这条评论
                  if (!widget.comment.isOwner &&
                      widget.comment.replyToName != widget.comment.nickname)
                    CommentIdentificationContainer(
                        widget.isSubFloor
                            ? widget.comment.replyToName == 'Owner' &&
                                    (widget.ancestorName != 'Owner' ||
                                        (widget.ancestorName == 'Owner' &&
                                            widget.comment.replyTo !=
                                                widget.ancestorUId))
                                ? widget.comment.replyToName ==
                                            widget.ancestorName &&
                                        widget.comment.replyTo !=
                                            widget.ancestorUId
                                    ? '楼主 层主'
                                    : '楼主'
                                : widget.comment.replyToName ==
                                            widget.ancestorName &&
                                        widget.comment.replyTo !=
                                            widget.ancestorUId
                                    ? '层主'
                                    : ''
                            : '',
                        false),
                  if (widget.isSubFloor &&
                      widget.comment.replyTo != widget.ancestorUId)
                    CommentIdentificationContainer(
                        '回复ID：' + widget.comment.replyTo.toString(), false),
                ],
              ),
              Text(
                DateTime.now().difference(widget.comment.createAt).inHours >= 11
                    ? widget.comment.createAt
                        .toLocal()
                        .toIso8601String()
                        .replaceRange(10, 11, ' ')
                        .substring(0, 19)
                    : DateTime.now()
                        .difference(widget.comment.createAt)
                        .dayHourMinuteSecondFormatted(),
                style: TextUtil.base.ProductSans.grey97.regular.sp(10),
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          shape: RacTangle(),
          offset: Offset(0, 0),
          child: SvgPicture.asset(
            'assets/svg_pics/lake_butt_icons/more_horizontal.svg',
            width: 16,
          ),
          onSelected: (value) async {
            if (value == '分享') {
              String weCo =
                  '我在微北洋发现了个有趣的问题评论，你也来看看吧~\n将本条微口令复制到微北洋求实论坛打开问题 wpy://school_project/${widget.comment.postId}\n【${widget.comment.content}】';
              ClipboardData data = ClipboardData(text: weCo);
              Clipboard.setData(data);
              CommonPreferences.feedbackLastWeCo.value =
                  widget.ancestorUId.toString();
              ToastProvider.success('微口令复制成功，快去给小伙伴分享吧！');
            }
            if (value == '举报') {
              Navigator.pushNamed(context, FeedbackRouter.report,
                  arguments: ReportPageArgs(widget.ancestorUId, false,
                      floorId: widget.comment.id));
            } else if (value == '删除') {
              bool confirm = await _showDeleteConfirmDialog();
              if (confirm) {
                FeedbackService.deleteFloor(
                  id: widget.comment.id,
                  onSuccess: () {
                    ToastProvider.success(S.current.feedback_delete_success);
                    setState(() {
                      _isDeleted = true;
                    });
                  },
                  onFailure: (e) {
                    ToastProvider.error(e.error.toString());
                  },
                );
              }
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: '分享',
                child: Center(
                  child: Text(
                    '分享',
                    style: TextUtil.base.black2A.regular.NotoSansSC.sp(12),
                  ),
                ),
              ),
              widget.comment.isOwner
                  ? PopupMenuItem<String>(
                      value: '删除',
                      child: Center(
                        child: Text(
                          '删除',
                          style:
                              TextUtil.base.black2A.regular.NotoSansSC.sp(12),
                        ),
                      ),
                    )
                  : PopupMenuItem<String>(
                      value: '举报',
                      child: Center(
                        child: Text(
                          '举报',
                          style:
                              TextUtil.base.black2A.regular.NotoSansSC.sp(12),
                        ),
                      ),
                    ),
            ];
          },
        ),
      ],
    );

    var commentContent = widget.comment.content == ''
        ? SizedBox()
        : ExpandableText(
            text: widget.comment.content,
            maxLines: !widget.isFullView && widget.isSubFloor ? 3 : 8,
            style: TextUtil.base.w400.NotoSansSC.black2A.h(1.2).sp(16),
            expand: false,
            buttonIsShown: true,
            isHTML: false,
          );

    var commentImage = Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 150),
          curve: Curves.decelerate,
          child: InkWell(
              onTap: () {
                setState(() {
                  print(picBaseUrl + 'origin/' + widget.comment.imageUrl);
                  _picFullView = true;
                });
              },
              child: _picFullView
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, FeedbackRouter.imageView,
                            arguments: {
                              "urlList": [widget.comment.imageUrl],
                              "urlListLength": 1,
                              "indexNow": 0
                            });
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: WePeiYangApp.screenWidth * 2),
                        child: Image.network(
                          picBaseUrl + 'origin/' + widget.comment.imageUrl,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 40,
                              width: double.infinity,
                              padding: EdgeInsets.all(4),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return Text(
                              '💔[图片加载失败]' +
                                  widget.comment.imageUrl.replaceRange(
                                      10,
                                      widget.comment.imageUrl.length - 6,
                                      '...'),
                              style: TextUtil.base.grey6C.w400.sp(12),
                            );
                          },
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Image.network(
                                picBaseUrl + 'thumb/' + widget.comment.imageUrl,
                                width: 70,
                                height: 64,
                                fit: BoxFit.cover, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            }, errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                              return Text(
                                '💔[加载失败，可尝试点击继续加载原图]\n    ' +
                                    widget.comment.imageUrl.replaceRange(
                                        10,
                                        widget.comment.imageUrl.length - 6,
                                        '...'),
                                style: TextUtil.base.grey6C.w400.sp(12),
                              );
                            })),
                        Spacer()
                      ],
                    )),
        ));

    var replyButton = IconButton(
      icon: SvgPicture.asset('assets/svg_pics/lake_butt_icons/reply.svg'),
      iconSize: 16,
      constraints: BoxConstraints(),
      onPressed: () {
        Provider.of<NewFloorProvider>(context, listen: false)
            .inputFieldOpenAndReplyTo(widget.comment.id);
        FocusScope.of(context).requestFocus(
            Provider.of<NewFloorProvider>(context, listen: false).focusNode);
      },
      padding: EdgeInsets.zero,
      color: ColorUtil.boldLakeTextColor,
    );

    var subFloor;
    if (widget.comment.subFloors != null && !widget.isSubFloor) {
      subFloor = ListView.custom(
        key: Key('nCommentCardView'),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _sc,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            return NCommentCard(
              uid: widget.uid,
              ancestorName: widget.comment.nickname,
              ancestorUId: widget.comment.id,
              comment: widget.comment.subFloors[index],
              commentFloor: index + 1,
              isSubFloor: true,
              isFullView: widget.isFullView,
            );
          },
          childCount: widget.isFullView
              ? widget.comment.subFloorCnt
              : widget.comment.subFloorCnt > 4
                  ? 4
                  : min(widget.comment.subFloorCnt,
                      widget.comment.subFloors.length),
          findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key;
            return widget.comment.subFloors
                .indexWhere((m) => 'ncm-${m.id}' == valueKey.value);
          },
        ),
      );
    }

    var likeWidget = IconWidget(IconType.like, count: widget.comment.likeCount,
        onLikePressed: (isLiked, count, success, failure) async {
      await FeedbackService.commentHitLike(
        id: widget.comment.id,
        isLike: widget.comment.isLike,
        onSuccess: () {
          widget.comment.isLike = !widget.comment.isLike;
          widget.comment.likeCount = count;
          if (widget.comment.isLike && widget.comment.isDis) {
            widget.comment.isDis = !widget.comment.isDis;
            setState(() {});
          }
          success.call();
        },
        onFailure: (e) {
          ToastProvider.error(e.error.toString());
          failure.call();
        },
      );
    }, isLike: widget.comment.isLike);

    var dislikeWidget = DislikeWidget(
      size: 15.w,
      isDislike: widget.comment.isDis,
      onDislikePressed: (dislikeNotifier) async {
        await FeedbackService.commentHitDislike(
          id: widget.comment.id,
          isDis: widget.comment.isDis,
          onSuccess: () {
            widget.comment.isDis = !widget.comment.isDis;
            if (widget.comment.isDis && widget.comment.isLike) {
              widget.comment.isLike = !widget.comment.isLike;
              widget.comment.likeCount--;
              setState(() {});
            }
          },
          onFailure: (e) {
            ToastProvider.error(e.error.toString());
          },
        );
      },
    );

    var likeAndDislikeWidget = [likeWidget, dislikeWidget];

    var bottomWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...likeAndDislikeWidget,
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 1.0),
          child: Text('ID: ' + widget.comment.id.toString(),
              style: TextUtil.base.NotoSansSC.w500.grey6C.sp(9)),
        ),
        replyButton,
      ],
    );

    var mainBody = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        topWidget,
        SizedBox(height: 6),
        commentContent,
        if (widget.comment.imageUrl != '') commentImage,
        _picFullView == true
            ? TextButton(
                style: ButtonStyle(
                    alignment: Alignment.topRight,
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    _picFullView = false;
                  });
                },
                child: Row(
                  children: [
                    Spacer(),
                    Text('收起',
                        style: TextUtil.base.greyA8.w800.NotoSansSC.sp(12)),
                  ],
                ))
            : SizedBox(height: 8),
        bottomWidget,
        SizedBox(height: 4)
      ],
    );

    return _isDeleted
        ? SizedBox(height: 1)
        : Column(
            children: [
              ClipCopy(
                copy: widget.comment.content,
                toast: '复制评论成功',
                // 这个padding其实起到的是margin的效果，因为Ink没有margin属性
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  // 这个Ink是为了确保body -> bottomWidget -> reportWidget的波纹效果正常显示
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: CommonPreferences.isSkinUsed.value
                          ? Color(CommonPreferences.skinColorE.value)
                          : widget.isFullView && widget.isSubFloor
                              ? Colors.transparent
                              : Colors.white,
                      boxShadow: [
                        widget.isFullView && widget.isSubFloor
                            ? BoxShadow(color: Colors.transparent)
                            : BoxShadow(
                                blurRadius: 1.6,
                                color: Colors.black12,
                                offset: Offset(0, 0),
                                spreadRadius: -1),
                      ],
                    ),
                    child: mainBody,
                  ),
                ),
              ),
              if (!widget.isSubFloor && !widget.isFullView && subFloor != null)
                Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subFloor,
                        if (widget.comment.subFloorCnt > 0)
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                FeedbackRouter.commentDetail,
                                arguments: ReplyDetailPageArgs(
                                    widget.comment, widget.uid),
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, top: 4, bottom: 6),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Color(0xffebebeb),
                                  ),
                                  child: Text(
                                      widget.comment.subFloorCnt > 2
                                          ? '查看全部 ' +
                                              widget.comment.subFloorCnt
                                                  .toString() +
                                              ' 条回复 >'
                                          : '查看回复详情 >',
                                      style: TextUtil.base.ProductSans.w400
                                          .sp(14)
                                          .grey6C),
                                ),
                                Spacer()
                              ],
                            ),
                          )
                      ],
                    )),
            ],
          );
  }
}
