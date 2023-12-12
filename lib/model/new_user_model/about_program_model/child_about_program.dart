import 'feedback_list_model.dart';
import 'feeds_model/feedsListModel.dart';
import 'testimonial_model.dart';

class ChildAboutProgramModel {
  ChildAboutProgramDetailsModel? aboutProgram;
  Testimonial? testimonial;
  List<FeedbackList>? feedbackList;
  List<FeedsListModel>? feedsList;
  List<String>? reviewsList;


  ChildAboutProgramModel({this.aboutProgram, this.testimonial, this.feedbackList, this.reviewsList});

  ChildAboutProgramModel.fromJson(Map<String, dynamic> json) {
    aboutProgram = ChildAboutProgramDetailsModel.fromJson(json['about_program']);
    testimonial = json['testimonial'] != null
        ? new Testimonial.fromJson(json['testimonial'])
        : null;
    if (json['feedback_list'] != null) {
      feedbackList = <FeedbackList>[];
      json['feedback_list'].forEach((v) {
        feedbackList!.add(new FeedbackList.fromJson(v));
      });
    }
    if (json['feed_list'] != null) {
      feedsList = <FeedsListModel>[];
      json['feed_list'].forEach((v) {
        feedsList!.add(new FeedsListModel.fromJson(v));
      });
    }
    print("review: ${json['reviews']}");
    if (json['reviews'] != null) {
      reviewsList = <String>[];
      json['reviews'].forEach((v) {
        reviewsList!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_program'] = this.aboutProgram;
    if (this.testimonial != null) {
      data['testimonial'] = this.testimonial!.toJson();
    }
    if (this.feedbackList != null) {
      data['feedback_list'] =
          this.feedbackList!.map((v) => v.toJson()).toList();
    }
    if (this.feedsList != null) {
      data['feed_list'] = this.feedsList!.map((v) => v.toJson()).toList();
    }
    if (this.reviewsList != null) {
      data['reviews'] = this.reviewsList!.map((v) => v).toList();
    }
    return data;
  }
}

class ChildAboutProgramDetailsModel{
  String? aboutPdf;
  String? aboutProgramVideo;
  ChildAboutProgramDetailsModel({this.aboutPdf, this.aboutProgramVideo});

  ChildAboutProgramDetailsModel.fromJson(Map json){
    aboutPdf = json['pdf_link'] ?? '';
    aboutProgramVideo = json['aboutprogram_video'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pdf_link'] = this.aboutPdf;
    data['aboutprogram_video']= this.aboutProgramVideo;
    return data;
  }
}
