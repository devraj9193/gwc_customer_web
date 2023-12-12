import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer_web/screens/uvdesk/ticket_chat_screens/theme.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../../model/error_model.dart';
import '../../../model/uvdesk_model/new_ticket_details_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../../services/uvdesk_service/uv_desk_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import 'data.dart';

class TicketChatScreen extends StatefulWidget {
  final String userName;
  final String thumbNail;
  final String ticketId;
  final String subject;
  final String email;

  /// ticketStatus is to show/hide textfield and reopen ticket option
  final int ticketStatus;

  const TicketChatScreen(
      {Key? key,
      required this.userName,
      required this.thumbNail,
      required this.ticketId,
      required this.subject,
      required this.email,
      required this.ticketStatus})
      : super(key: key);

  @override
  State<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends State<TicketChatScreen> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  bool showProgress = false;
  bool isLoading = false;

  List<Threads>? messageList;

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  final String imageBaseUrl = "https://support.gutandhealth.com/public";

  @override
  void initState() {
    super.initState();
    getThreadsList();
  }

  getThreadsList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result =
        await _uvDeskService.getTicketDetailsByIdService(widget.ticketId);
    print("result: $result");

    if (result.runtimeType == NewTicketDetailsModel) {
      print("Threads List");
      NewTicketDetailsModel model = result as NewTicketDetailsModel;
      messageList = model.ticket!.threads;
      getData(messageList);
      print("threads List : $messageList");
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  callProgressStateOnBuild(bool value) {
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {
        showProgress = value;
      });
    });
  }

  getData(List<Threads>? chat) {
    messageList = chat;
    print("chat : $messageList");
  }

  final _chatController = ChatController(
    initialMessageList: Datas.messageList,
    scrollController: ScrollController(),
    chatUsers: [
      ChatUser(
        id: '2',
        name: 'Simform',
        profilePhoto: Datas.profileImage,
      ),
      ChatUser(
        id: '3',
        name: 'Jhon',
        profilePhoto: Datas.profileImage,
      ),
      ChatUser(
        id: '4',
        name: 'Mike',
        profilePhoto: Datas.profileImage,
      ),
      ChatUser(
        id: '5',
        name: 'Rich',
        profilePhoto: Datas.profileImage,
      ),
    ],
  );

  void _showHideTypingIndicator() {
    _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        currentUser: ChatUser(
          id: '1',
          name: widget.userName,
          profilePhoto: widget.thumbNail,
        ),
        chatController: _chatController,
        onSendTap: sendReply,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
        ),
        chatViewState: ChatViewState.hasMessages,
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.outgoingChatBubbleColor,
          ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          elevation: theme.elevation,
          backGroundColor: theme.appBarColor,
          profilePicture: widget.thumbNail,
          backArrowColor: theme.backArrowColor,
          chatTitle: widget.userName,
          chatTitleTextStyle: TextStyle(
            fontSize: headingFont,
            fontFamily: kFontBold,
          ),
          leading: GestureDetector(
            onTap: () async {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: const Icon(
                Icons.arrow_back_ios,
                color: gsecondaryColor,
              ),
            ),
          ),
          userStatus: widget.ticketId,
          userStatusTextStyle: TextStyle(
            fontSize: subHeadingFont,
            fontFamily: kFontMedium,
          ),
          actions: [
            IconButton(
              onPressed: _onThemeIconTap,
              icon: Icon(
                isDarkTheme
                    ? Icons.brightness_4_outlined
                    : Icons.dark_mode_outlined,
                color: theme.themeIconColor,
              ),
            ),
            // IconButton(
            //   tooltip: 'Toggle TypingIndicator',
            //   onPressed: _showHideTypingIndicator,
            //   icon: Icon(
            //     Icons.keyboard,
            //     color: theme.themeIconColor,
            //   ),
            // ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            onMessageTyping: (status) {
              /// Do with status
              debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 1),
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
          micIconColor: theme.replyMicIconColor,
          voiceRecordingConfiguration: VoiceRecordingConfiguration(
            backgroundColor: theme.waveformBackgroundColor,
            recorderIconColor: theme.recordIconColor,
            waveStyle: WaveStyle(
              showMiddleLine: false,
              waveColor: theme.waveColor ?? Colors.white,
              extendWaveform: true,
            ),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
            senderNameTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
            reactedUserCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionCountTextStyle:
                TextStyle(color: theme.inComingChatBubbleTextColor),
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: theme.backgroundColor,
              reactedUserTextStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
              ),
              reactionWidgetDecoration: BoxDecoration(
                color: theme.inComingChatBubbleColor,
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        profileCircleConfig: const ProfileCircleConfiguration(
          profileImageUrl: Datas.profileImage,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          backgroundColor: theme.repliedMessageColor,
          verticalBarColor: theme.verticalBarColor,
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
          replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
      ),
    );
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void sendReply(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    setState(() {
      isLoading = true;
    });
    print("---------Send reply---------");

    Map m = {
      'message': message,
      'threadType': ThreadType.reply.name,
      'actAsType': ActAsType.customer.name,
      'actAsEmail': widget.email,
      'status_id': (TicketStatusType.answered.index + 1).toString()
    };

    final result = await _uvDeskService
        .sendReplyService(widget.ticketId, m, attachments: []);

    if (result.runtimeType != ErrorModel) {
      // SentReplyModel model = result as SentReplyModel;
      setState(() {
        isLoading = false;
      });
      // GwcApi().showSnackBar(context, model.message!, isError: true);
      // commentController.clear();
      // fileFormatList.clear();
      getThreadsList();
    } else {
      setState(() {
        isLoading = false;
      });
      ErrorModel response = result as ErrorModel;
      AppConfig().showSnackbar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final id = int.parse(Datas.messageList.last.id) + 1;
    _chatController.addMessage(
      Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: "1",
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  void _onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}
