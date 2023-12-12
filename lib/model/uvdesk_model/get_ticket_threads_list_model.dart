
import 'new_ticket_details_model.dart';

class ThreadsListModel {
  List<Ticket>? threads;
  Pagination? pagination;

  ThreadsListModel({
    required this.threads,
    this.pagination,
  });

  factory ThreadsListModel.fromJson(Map<String, dynamic> json) =>
      ThreadsListModel(
        threads:
            List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "tickets": List<dynamic>.from(threads!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? last;
  int? current;
  int? numItemsPerPage;
  int? first;
  int? pageCount;
  int? totalCount;
  int? pageRange;
  int? startPage;
  int? endPage;
  List<int>? pagesInRange;
  int? firstPageInRange;
  int? lastPageInRange;
  int? currentItemCount;
  int? firstItemNumber;
  int? lastItemNumber;
  String? url;

  Pagination({
    this.last,
    this.current,
    this.numItemsPerPage,
    this.first,
    this.pageCount,
    this.totalCount,
    this.pageRange,
    this.startPage,
    this.endPage,
    this.pagesInRange,
    this.firstPageInRange,
    this.lastPageInRange,
    this.currentItemCount,
    this.firstItemNumber,
    this.lastItemNumber,
    this.url,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        last: json["last"],
        current: json["current"],
        numItemsPerPage: json["numItemsPerPage"],
        first: json["first"],
        pageCount: json["pageCount"],
        totalCount: json["totalCount"],
        pageRange: json["pageRange"],
        startPage: json["startPage"],
        endPage: json["endPage"],
        pagesInRange: List<int>.from(json["pagesInRange"].map((x) => x)),
        firstPageInRange: json["firstPageInRange"],
        lastPageInRange: json["lastPageInRange"],
        currentItemCount: json["currentItemCount"],
        firstItemNumber: json["firstItemNumber"],
        lastItemNumber: json["lastItemNumber"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "last": last,
        "current": current,
        "numItemsPerPage": numItemsPerPage,
        "first": first,
        "pageCount": pageCount,
        "totalCount": totalCount,
        "pageRange": pageRange,
        "startPage": startPage,
        "endPage": endPage,
        "pagesInRange": List<dynamic>.from(pagesInRange!.map((x) => x)),
        "firstPageInRange": firstPageInRange,
        "lastPageInRange": lastPageInRange,
        "currentItemCount": currentItemCount,
        "firstItemNumber": firstItemNumber,
        "lastItemNumber": lastItemNumber,
        "url": url,
      };
}

class Thread {
  int? id;
  String? reply;
  String? source;
  String? threadType;
  List<String>? replyTo;
  List<String>? cc;
  List<String>? bcc;
  String? userType;
  CreatedAt? createdAt;
  String? formatedCreatedAt;
  String? messageId;
  User? user;
  List<dynamic>? attachments;
  bool? isLocked;
  String? fullname;
  String? bookmark;
  String? viewedAt;
  String? mailStatus;
  String? task;

  Thread({
    this.id,
    this.reply,
    this.source,
    this.threadType,
    this.replyTo,
    this.cc,
    this.bcc,
    this.userType,
    this.createdAt,
    this.formatedCreatedAt,
    this.messageId,
    this.user,
    this.attachments,
    this.isLocked,
    this.fullname,
    this.bookmark,
    this.viewedAt,
    this.mailStatus,
    this.task,
  });

  factory Thread.fromJson(Map<String, dynamic> json) => Thread(
        id: json["id"],
        reply: json["reply"],
        source: json["source"],
        threadType: json["threadType"],
        replyTo: (json["replyTo"].runtimeType == List) ? List.from(json["replyTo"]) : null,
        cc: (json["cc"].runtimeType == List) ? List.from(json["cc"]) : null,
        bcc: (json["bcc"].runtimeType == List) ? List.from(json["bcc"]) : null,
        userType: json["userType"],
        createdAt: CreatedAt.fromJson(json["createdAt"]),
        formatedCreatedAt: json["formatedCreatedAt"],
        messageId: json["messageId"],
        user: User.fromJson(json["user"]),
        attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
        isLocked: json["isLocked"],
        fullname: json["fullname"],
        bookmark: json["bookmark"],
        viewedAt: json["viewedAt"],
        mailStatus: json["mailStatus"],
        task: json["task"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reply": reply,
        "source": source,
        "threadType": threadType,
        "replyTo": replyTo,
        "cc": cc,
        "bcc": bcc,
        "userType": userType,
        "createdAt": createdAt?.toJson(),
        "formatedCreatedAt": formatedCreatedAt,
        "messageId": messageId,
        "user": user?.toJson(),
        "attachments": List<dynamic>.from(attachments!.map((x) => x)),
        "isLocked": isLocked,
        "fullname": fullname,
        "bookmark": bookmark,
        "viewedAt": viewedAt,
        "mailStatus": mailStatus,
        "task": task,
      };
}

class CreatedAt {
  Timezone? timezone;
  int? offset;
  int? timestamp;

  CreatedAt({
    this.timezone,
    this.offset,
    this.timestamp,
  });

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        timezone: Timezone.fromJson(json["timezone"]),
        offset: json["offset"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "timezone": timezone?.toJson(),
        "offset": offset,
        "timestamp": timestamp,
      };
}

class Timezone {
  String? name;
  Location? location;

  Timezone({
    this.name,
    this.location,
  });

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
        name: json["name"],
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "location": location?.toJson(),
      };
}

class Location {
  String? countryCode;
  String? latitude;
  String? longitude;
  String? comments;

  Location({
    this.countryCode,
    this.latitude,
    this.longitude,
    this.comments,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        countryCode: json["country_code"],
        latitude: json["latitude"].toString(),
        longitude: json["longitude"].toString(),
        comments: json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "latitude": latitude,
        "longitude": longitude,
        "comments": comments,
      };
}

class User {
  int? id;
  String? email;
  String? smallThumbnail;
  bool? isActive;
  bool? enabled;
  CurrentUserAgentInstance? currentUserInstance;
  CurrentUserAgentInstance? currentUserAgentInstance;
  String? currentUserCustomerInstance;
  String? role;
  Detail? detail;
  String? timezone;

  User({
    this.id,
    this.email,
    this.smallThumbnail,
    this.isActive,
    this.enabled,
    this.currentUserInstance,
    this.currentUserAgentInstance,
    this.currentUserCustomerInstance,
    this.role,
    this.detail,
    this.timezone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        smallThumbnail: json["smallThumbnail"],
        isActive: json["isActive"],
        enabled: json["enabled"],
        currentUserInstance: json["currentUserInstance"] == null
            ? null
            : CurrentUserAgentInstance.fromJson(json["currentUserInstance"]),
        currentUserAgentInstance: json["currentUserAgentInstance"] == null
            ? null
            : CurrentUserAgentInstance.fromJson(
                json["currentUserAgentInstance"]),
        currentUserCustomerInstance: json["currentUserCustomerInstance"],
        role: json["role"],
        detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "smallThumbnail": smallThumbnail,
        "isActive": isActive,
        "enabled": enabled,
        "currentUserInstance": currentUserInstance?.toJson(),
        "currentUserAgentInstance": currentUserAgentInstance?.toJson(),
        "currentUserCustomerInstance": currentUserCustomerInstance,
        "role": role,
        "detail": detail?.toJson(),
        "timezone": timezone,
      };
}

class CurrentUserAgentInstance {
  int? id;
  int? companyId;
  UserRole? userRole;
  String? firstName;
  String? lastName;
  String? name;
  CreatedAt? createdAt;
  bool? isActive;
  String? isStarred;
  int? user;
  String? signature;
  String? ticketView;
  bool? isVerified;
  String? source;
  List<dynamic>? authorisedClients;
  String? activityNotifications;
  String? assignedTeamIdReferences;
  String? assignedGroupIdReferences;
  bool? forceLogout;

  CurrentUserAgentInstance({
    this.id,
    this.companyId,
    this.userRole,
    this.firstName,
    this.lastName,
    this.name,
    this.createdAt,
    this.isActive,
    this.isStarred,
    this.user,
    this.signature,
    this.ticketView,
    this.isVerified,
    this.source,
    this.authorisedClients,
    this.activityNotifications,
    this.assignedTeamIdReferences,
    this.assignedGroupIdReferences,
    this.forceLogout,
  });

  factory CurrentUserAgentInstance.fromJson(Map<String, dynamic> json) =>
      CurrentUserAgentInstance(
        id: json["id"],
        companyId: json["companyId"],
        userRole: UserRole.fromJson(json["userRole"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        name: json["name"],
        createdAt: CreatedAt.fromJson(json["createdAt"]),
        isActive: json["isActive"],
        isStarred: json["isStarred"],
        user: json["user"],
        signature: json["signature"],
        ticketView: json["ticketView"].toString(),
        isVerified: json["isVerified"],
        source: json["source"],
        authorisedClients:
            List<dynamic>.from(json["authorisedClients"].map((x) => x)),
        activityNotifications: json["activityNotifications"],
        assignedTeamIdReferences: json["assignedTeamIdReferences"],
        assignedGroupIdReferences: json["assignedGroupIdReferences"],
        forceLogout: json["forceLogout"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "companyId": companyId,
        "userRole": userRole?.toJson(),
        "firstName": firstName,
        "lastName": lastName,
        "name": name,
        "createdAt": createdAt?.toJson(),
        "isActive": isActive,
        "isStarred": isStarred,
        "user": user,
        "signature": signature,
        "ticketView": ticketView,
        "isVerified": isVerified,
        "source": source,
        "authorisedClients":
            List<dynamic>.from(authorisedClients!.map((x) => x)),
        "activityNotifications": activityNotifications,
        "assignedTeamIdReferences": assignedTeamIdReferences,
        "assignedGroupIdReferences": assignedGroupIdReferences,
        "forceLogout": forceLogout,
      };
}

class UserRole {
  int? id;
  String? role;
  String? name;

  UserRole({
    this.id,
    this.role,
    this.name,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => UserRole(
        id: json["id"],
        role: json["role"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
      };
}

class Detail {
  CurrentUserAgentInstance? agent;

  Detail({
    this.agent,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        agent: CurrentUserAgentInstance.fromJson(json["agent"]),
      );

  Map<String, dynamic> toJson() => {
        "agent": agent?.toJson(),
      };
}
