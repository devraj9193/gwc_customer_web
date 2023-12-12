// import 'package:flutter/material.dart';
//
// import '../../model/uvdesk_model/ticket_details_model.dart';
//
// class ExpandableThreadView extends StatefulWidget {
//   final String text;
//   final List<Attachments> attachmentList;
//
//   const ExpandableThreadView(
//       {key, required this.text, required this.attachmentList});
//   @override
//   State<StatefulWidget> createState() {
//     return ExpandableThreadViewState();
//   }
// }
//
// class ExpandableThreadViewState extends State<ExpandableThreadView> {
//   bool isExpanded = false;
//
//   void toggleExpansion() {
//     setState(() {
//       isExpanded = !isExpanded;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.text,
//           overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//           maxLines: isExpanded ? null : 1,
//         ),
//         isExpanded && widget.attachmentList.isNotEmpty
//             ? SizedBox(
//           height: 80,
//           child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: widget.attachmentList.length,
//               itemBuilder: (context, index) {
//                 if (widget.attachmentList[index].iconURL.isNotEmpty) {
//                   return Material(
//                     child: InkWell(
//                       child: Image.network(
//                         widget.attachmentList[index].iconURL,
//                         height: 60,
//                         width: 60,
//                       ),
//                       onTap: () {
//                         DownloadHelper().downloadPersonalData(widget.attachmentList[index].downloadURL,widget.attachmentList[index].name, "", context);
//                       },
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               }),
//         )
//             : Container()
//       ],
//     );
//   }
// }
