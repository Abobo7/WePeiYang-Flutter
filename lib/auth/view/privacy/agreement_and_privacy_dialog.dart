import 'package:flutter/material.dart';
import 'package:we_pei_yang_flutter/main.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';

class AgreementAndPrivacyDialog extends Dialog {
  final ValueNotifier check;

  AgreementAndPrivacyDialog({this.check});

  @override
  Widget build(BuildContext context) {
    var textColor = Color.fromRGBO(98, 103, 124, 1);
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: 30, vertical: WePeiYangApp.screenHeight / 10),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(251, 251, 251, 1)),
      child: Column(
        children: [
          Expanded(
            child: DefaultTextStyle(
              textAlign: TextAlign.start,
              style: FontManager.YaHeiRegular.copyWith(
                  color: textColor, fontSize: 13),
              child: ListView(physics: BouncingScrollPhysics(), children: [
                Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 20, bottom: 18),
                    child: Text('微北洋用户协议及隐私政策',
                        style: FontManager.YaHeiRegular.copyWith(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                Text("更新日期：2022年03月19日\n" + "生效日期：2021年08月13日\n"),
                BoldText("一．引言"),
                Text("微北洋产品和服务的提供者为天津大学（以下简称“我们”）。"
                    "微北洋自推出以来连接全校师生，带来学习与生活的便捷。"
                    "微北洋致力于为用户提供一个绿色、安全、健康、便捷的校园平台，"
                    "为了实现这一目标，我们基于以下原则制定了《微北洋用户须知及隐私政策》（以下简称“本协议”），"
                    "声明用户的权利与义务，对违规行为进行处理，维护用户及其他主体的合法权益。\n"),
                BoldText("为共同营造绿色、安全、健康、清朗的网络环境，请仔细阅读并遵守相关规定。\n"),
                Text("我们一向尊重并会严格保护用户在使用微北洋时的合法权益（包括用户隐私、用户数据等）不受到任何侵犯。"
                    "本协议（包括本文最后部分的隐私政策）是用户（包括通过各种合法途径获取到本产品的自然人、法人或其他组织机构，"
                    "以下简称“用户”或“您”）与我们之间针对本产品相关事项最终的、完整的且排他的协议，"
                    "并取代、合并之前的当事人之间关于上述事项的讨论和协议。\n"),
                Text(
                    "本协议将对用户使用本产品的行为产生法律约束力，您已承诺和保证有权利和能力订立本协议。用户开始使用本产品将视为已经接受本协议，"
                    "请认真阅读并理解本协议中各种条款，包括免除和限制我们的免责条款和对用户的权利限制"
                    "（未成年人审阅时应由法定监护人陪同），如果您不能接受本协议中的全部条款，请勿开始使用本产品。\n"),
                Text("如果你发现任何违规行为或内容，可以通过天外天微信公众号、用户社群、"
                    "开发者邮箱等渠道发起投诉。我们收到投诉后，将对相关投诉进行审核。"
                    "如违反规则，我们可能对帐号或内容停止提供服务。对于违反规则的用户，"
                    "微北洋将视违规程度，可能停止提供违规内容在微北洋继续展示、传播的服务，"
                    "予以警告，并可能停止对你的帐号提供服务。\n"),
                BoldText("二．微北洋软件使用规范"),
                Text("用户在使用微北洋软件的过程中必须承诺：\n"),
                BoldText("您使用本产品的行为必须合法。\n"),
                Text("本产品将会依据本协议“修改和终止”的规定保留或终止您的账户。您必须承诺对您的登录信息保密、"
                    "不被其他人获取与使用，并且对您在本账户下的所有行为负责。您必须将任何有可能触犯法律的、"
                    "未授权使用或怀疑为未授权使用的行为在第一时间通知本产品。本产品不对您因未能遵守上述要求而造成的损失承担法律责任。\n"),
                BoldText("1. 合理、善意注册使用微北洋"),
                Text("你应当合理、善意注册并使用微北洋帐号，"
                    "不得恶意注册或将天外天帐号用于非法或不正当用途。\n"
                    "1.1 官方渠道注册。\n用户须通过i.twt.edu.cn注册天外天帐号登录微北洋。\n"
                    "1.2 不得恶意注册、使用天外天帐号。\n用户不得实施恶意注册、使用天外天帐号的行为，"
                    "您不得对账号进行任何形式的许可、出售、租赁、转让、发行或其他商业用途；"
                    "您不得删除或破坏包含在本产品中的任何版权声明或其他所有权标记。"
                    "用户不得冒充他人；不得利用他人的名义发布任何信息。\n"),
                BoldText("2.用户内容"),
                Text("2.1 用户内容\n"
                    "2.1.1 用户内容是指该用户下载、发布或以其他方式使用本产品时产生的所有内容（例如：您的信息、图片、音乐或其他内容）。\n"
                    "2.1.2 您是您的用户内容唯一的责任人，您将承担因您的用户内容披露而导致的您或任何第三方被识别的风险。\n"
                    "2.1.3 您已同意您的用户内容受到权利限制（详见“权利限制”）。\n"
                    "2.2 权利限制\n"
                    "您已同意通过分享或其他方式使用本产品中的相关服务，"
                    "在使用过程中，您将承担因下述行为所造成的风险而产生的全部法律责任："
                    "2.2.1 违反或反对宪法确定的基本原则、社会主义制度的；\n"
                    "2.2.2 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一、主权和领土完整的；\n"
                    "2.2.3 损害国家荣誉和利益的；\n"
                    "2.2.4 煽动民族仇恨、民族歧视，破坏民族团结的；\n"
                    "2.2.5 破坏国家宗教政策，宣扬邪教和封建迷信的；\n"
                    "2.2.6 散布谣言，扰乱社会秩序，破坏社会稳定的；\n"
                    "2.2.7 散布淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的；\n"
                    "2.2.8 侮辱或者诽谤他人，侵害他人合法权益的；\n"
                    "2.2.9 煽动非法集会、结社、游行、示威、聚众扰乱社会秩序；\n"
                    "2.2.10 以非法民间组织名义活动的；\n"
                    "2.2.11 不符合《即时通信工具公众信息服务发展管理暂行规定》及其他相关法律法规要求的。\n"
                    "2.2.12 含有法律、行政法规禁止的其他内容的。"),
                BoldText("您已经同意不在本产品从事下列行为："),
                Text("发布或分享电脑病毒、蠕虫、恶意代码、故意破坏或改变计算机系统或数据的软件；\n"
                    "未授权的情况下，收集其他用户的信息或数据，例如电子邮箱地址等；\n"
                    "用自动化的方式恶意使用本产品，给服务器造成过度的负担或以其他方式干扰或损害网站服务器和网络链接；\n"
                    "在未授权的情况下，尝试访问本产品的服务器数据或通信数据；\n"
                    "干扰、破坏本产品其他用户的使用。\n"),
                BoldText("3. 终端用户协议"),
                Text("3.1 许可\n"
                    "依据本协议规定，本产品将授予您以下不可转让的、非排他的许可：\n"
                    "3.1.1 使用本产品的权利；\n"
                    "3.1.2 在您所有的网络通信设备、计算机设备和移动通信设备上下载、安装、使用本产品的权利。\n"
                    "3.1.3 注销您的账号的权利。您可以在应用内个人中心->个人信息更改->注销账号处，"
                    "或者前往天外天个人中心(https://i.twt.edu.cn/#/)的账户设置->注销账户处进行注销操作。\n"
                    "当您决定注销账号后，您将无法再以该账号登录和使用我们的产品与服务，"
                    "该账号下的内容、信息、数据、记录等会将被删除或匿名化处理；账号注销完成后，将无法恢复。\n"
                    "3.2 限制性条款\n"
                    "本协议对您的授权将受到以下限制：\n"
                    "3.2.1 您不得对本产品进行任何形式的许可、出售、租赁、转让、发行或其他商业用途；\n"
                    "3.2.2 除非法律禁止此类限制，否则您不得对本产品的任何部分或衍生产品进行修改、翻译、改编、合并、利用、分解、改造或反向编译、反向工程等；\n"
                    "3.2.3 您不得以创建相同或竞争服务为目的使用本产品；\n"
                    "3.2.4 除非法律明文规定，否则您不得对本产品的任何部分以任何形式或方法进行生产、复制、发行、出售、下载或显示等；\n"
                    "3.2.5 您不得删除或破坏包含在本产品中的任何版权声明或其他所有权标记。\n"
                    "3.3 版本\n"
                    "任何本产品的更新版本或未来版本、更新或者其他变更将受到本协议约束。\n"),
                BoldText("4. 遵守法律"),
                Text(
                    "您同意遵守《中华人民共和国合同法》、《中华人民共和国著作权法》及其实施条例、《全国人民代表大会常务委员会关于维护互联网安全的决定》（“人大安全决定”）、"
                    "《中华人民共和国保守国家秘密法》、《中华人民共和国电信条例》（“电信条例“）、《中华人民共和国计算机信息系统安全保护条例》、"
                    "《中华人民共和国计算机信息网络国际联网管理暂行规定》及其实施办法、《计算机信息系统国际联网保密管理规定》、《互联网信息服务管理办法》、"
                    "《计算机信息网络国际联网安全保护管理办法》、《互联网电子公告服务管理规定》（“电子公告规定”）、《中华人民共和国网络安全法》、"
                    "、《中华人民共和国密码法》等相关中国法律法规的任何及所有的规定，并对以任何方式使用您的密码和您的账号使用本服务的任何行为及其结果承担全部责任。"
                    "如违反《人大安全决定》有可能构成犯罪，被追究刑事责任。《电子公告规定》则有明文规定，上网用户使用电子公告服务系统对所发布的信息负责。"
                    "《电信条例》也强调，使用电信网络传输信息的内容及其后果由电信用户负责。在任何情况下，如果本产品有理由认为您的任何行为，"
                    "包括但不限于您的任何言论和其它行为违反或可能违反上述法律和法规的任何规定，本产品可在任何时候不经任何事先通知终止向您提供服务。\n"),
                BoldText("三、隐私政策"),
                Text("请您在开始使用我们的产品微北洋（以下简称“本产品”）之前请务必仔细阅读并理解《隐私政策》（以下简称“本政策”）。"
                    " 您可以通过多种不同的方式使用我们的服务。基于此目的，我们将向您解释我们对信息的收集和使用方式，"
                    "以及您可采用什么方式来保护自己的隐私权。 我们的隐私政策包括了以下几个方面的问题：\n"
                    "1. 我们收集哪些信息\n"
                    "2. 我们如何收集和使用信息\n"
                    "3. 您如何访问和控制自己的个人信息\n"
                    "4. 信息的分享、安全以及隐私政策的使用范围和变更\n"
                    "5. 密码均以密文形式存储在数据库中，即使是相关人员也无法直接查看您的密码，且不会导致您的密码等重要信息泄露\n"
                    "6. 身份认证采用token加时间戳签名验证，以保证接口调用的安全性\n"
                    "7. 为了保证您的个人账号安全，我们不会请求除学号，身份证号以外的其它信息；且会与学校的录取信息进行对比认证来确定您本人的身份\n"),
                BoldText("1. 个人隐私"),
                Text("1.1 当您登录办公网使用微北洋服务时，我们会收集您的姓名、学院信息、"
                    "入学年份、专业、班级，以及办公网的账号密码信息。收集这些信息是为了给您提供相应的服务。"
                    "若您不提供这类信息，您无法正常使用我们提供的所有服务。\n"
                    "1.2 在您使用微北洋求实论坛服务期间，您可能会在发布页面中发布照片：\n"
                    "在已知的需要上传照片的模块中，当您选择上传照片时，"
                    "我们会收集您通过相册主动上传的照片信息，即需要您授权我们读取您的相册权限。\n"
                    "当您选择拍摄照片时，我们会申请访问您的相机，因此需要您授权相机和录音权限。\n"
                    "如果您拒绝授权仅会使您无法使用该功能，但不影响您正常使用微北洋其他功能。\n"
                    "1.3 当您使用求实论坛功能时，我们会收集您上传的动图、照片、帖子、评论、点赞信息。您也可以随时删除这些信息。"
                    "当您使用自定义课程、蹭课功能时，我们会收集您编辑的信息。您也可以随时删除这些信息。\n"
                    "1.4 当您使用自习室功能时，若您需要收藏自习室，我们会请求您的手机存储权限"
                    "并将此信息存储在您的手机本地；若您退出天外天账号，则该信息会自动删除；"
                    "若您拒绝授权则会影响收藏自习室这一功能的正常使用，但不影响您正常使用自习室查询的功能。\n"
                    "1.5 当您使用本应用并同意本隐私政策后，我们会采集您的唯一设备识别码（IMEI）以及设备的Mac地址，"
                    "对用户进行唯一标识，以便提供统计分析服务（详见：2.3 第三方SDK信息）。\n"),
                BoldText("2. 数据使用规范"),
                Text("2.1 微北洋保证不对外公开或向第三方透露用户个人隐私信息，或用户在使用服务时存储的非公开内容。\n"
                    "2.2 请您注意，我们不会主动从第三方获取您的个人信息。\n"
                    "2.3 在涉及国家安全与利益、社会公共利益、与犯罪侦查有关的相关活动、"
                    "您或他人生命财产安全但在特殊情况下无法获得您的及时授权、能够从其他合法公开的渠道、"
                    "法律法规规定的其他情形下，微北洋可能在不经过您的同意或授权的前提下，向相关部门提供您的个人信息。\n"),
                BoldText("3. 第三方SDK信息"),
                Text("3.1 微北洋使用了友盟+(Umeng)SDK，通过采集唯一设备识别码（IMEI）对用户进行唯一标识，"
                    "以便进行用户新增等统计分析服务。在特殊情况下（如用户使用平板设备或电视盒子时），"
                    "无法通过唯一设备识别码标识设备，我们会将设备Mac地址作为用户的唯一标识，以便正常提供统计分析服务。"
                    "详细内容请访问《【友盟+】隐私政策》(https://www.umeng.com/page/policy)。\n"
                    "3.2 微北洋使用了个推SDK，我们可能会将您的设备平台、设备厂商及品牌、设备型号及系统版本、设备识别码、设备序列号等设备信息、"
                    "应用列表信息、网络信息以及位置相关信息提供给每日互动股份有限公司，用于为您提供推送技术服务。"
                    "我们在向您推送消息时，我们可能会授权每日互动股份有限公司进行链路调节，相互促活被关闭的SDK推送进程，"
                    "保障您可以及时接收到我们向您推送的消息。详细内容请访问《个推用户隐私政策》(https://docs.getui.com/privacy)。\n"
                    "3.3 微北洋使用了高德地图SDK，通过采集用户的位置信息来方便用户提交健康防控信息。详情内容请访问《高德地图开放平台隐私权政策》(https://lbs.amap.com/pages/privacy)。\n"),
                BoldText("四、免责声明"),
                Text("微北洋用户明确了解并同意：\n"
                    "微北洋app为用户所提供的课程、GPA、自习室等信息，均来自于天津大学教育信息管理中心、教务网站。"
                    "我们尽可能保证为您提供最准确、及时、稳定的信息，一切准确信息以以上两个官方网站为准；"
                    "若有错缺，请用户自行比对注意，由此造成的损失天外天工作室不承担任何责任。\n"
                    "关于微北洋服务天外天工作室不提供"
                    "任何种类的明示或暗示担保或条件，你对微北洋服务的使用行为必须自行承担相应风险。\n"),
                BoldText("五、联系我们"),
                Text("微北洋用户社区1(QQ群)：738068756\n"
                    "微北洋用户社区2(QQ群)：738064793\n"
                    "微北洋用户社区3(QQ群)：337647539")
              ]),
            ),
          ),
          SizedBox(height: 13),
          Divider(height: 1, color: Color.fromRGBO(172, 174, 186, 1)),
          _detail(context),
        ],
      ),
    );
  }

  Widget _detail(BuildContext context) {
    if (check == null) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(), // 加个这个扩大点击事件范围
          padding: const EdgeInsets.all(16),
          child: Text('确定',
              style: FontManager.YaQiHei.copyWith(
                  color: Color.fromRGBO(98, 103, 123, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none)),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              check.value = false;
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(), // 加个这个扩大点击事件范围
              padding: const EdgeInsets.all(16),
              child: Text('拒绝',
                  style: FontManager.YaQiHei.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none)),
            ),
          ),
          GestureDetector(
            onTap: () {
              check.value = true;
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(), // 加个这个扩大点击事件范围
              padding: const EdgeInsets.all(16),
              child: Text('同意',
                  style: FontManager.YaQiHei.copyWith(
                      color: Color.fromRGBO(98, 103, 123, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none)),
            ),
          ),
        ],
      );
    }
  }
}

class BoldText extends StatelessWidget {
  final String text;

  BoldText(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontWeight: FontWeight.bold));
}