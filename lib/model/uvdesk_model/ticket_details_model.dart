import 'get_ticket_list_model.dart';

class TicketdetailsModel {
  Ticket? ticket;
  Labels? labels;
  // List<Null>? todo;
  UserDetails? userDetails;
  CreateThread? createThread;
  String? ticketTotalThreads;
  // List<Null>? ticketTasks;
  List<Status>? status;
  List<Group>? group;
  List<Priority>? priority;
  List<Type>? type;

  TicketdetailsModel({this.ticket, this.labels,
    // this.todo,
    this.userDetails, this.createThread, this.ticketTotalThreads,
    // this.ticketTasks,
    this.status, this.group, this.priority, this.type});

  TicketdetailsModel.fromJson(Map<String, dynamic> json) {
    ticket = json['ticket'] != null ? new Ticket.fromJson(json['ticket']) : null;
    labels = json['labels'] != null ? new Labels.fromJson(json['labels']) : null;
    // if (json['todo'] != null) {
    //   todo = <Null>[];
    //   json['todo'].forEach((v) { todo!.add(new Null.fromJson(v)); });
    // }
    userDetails = json['userDetails'] != null ? new UserDetails.fromJson(json['userDetails']) : null;
    createThread = json['createThread'] != null ? new CreateThread.fromJson(json['createThread']) : null;
    ticketTotalThreads = json['ticketTotalThreads'];
    // if (json['ticketTasks'] != null) {
    //   ticketTasks = <Null>[];
    //   json['ticketTasks'].forEach((v) { ticketTasks!.add(new Null.fromJson(v)); });
    // }
    if (json['status'] != null) {
      status = <Status>[];
      json['status'].forEach((v) { status!.add(new Status.fromJson(v)); });
    }
    if (json['group'] != null) {
      group = <Group>[];
      json['group'].forEach((v) { group!.add(new Group.fromJson(v)); });
    }
    if (json['priority'] != null) {
      priority = <Priority>[];
      json['priority'].forEach((v) { priority!.add(new Priority.fromJson(v)); });
    }
    if (json['type'] != null) {
      type = <Type>[];
      json['type'].forEach((v) { type!.add(new Type.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.toJson();
    }
    if (this.labels != null) {
      data['labels'] = this.labels!.toJson();
    }
    // if (this.todo != null) {
    //   data['todo'] = this.todo!.map((v) => v.toJson()).toList();
    // }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    if (this.createThread != null) {
      data['createThread'] = this.createThread!.toJson();
    }
    data['ticketTotalThreads'] = this.ticketTotalThreads;
    // if (this.ticketTasks != null) {
    //   data['ticketTasks'] = this.ticketTasks!.map((v) => v.toJson()).toList();
    // }
    if (this.status != null) {
      data['status'] = this.status!.map((v) => v.toJson()).toList();
    }
    if (this.group != null) {
      data['group'] = this.group!.map((v) => v.toJson()).toList();
    }
    if (this.priority != null) {
      data['priority'] = this.priority!.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['type'] = this.type!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ticket {
  int? id;
  String? subject;
  String? source;
  String? formatedCreatedAt;
  // List<Null>? relatedPrestashopTicket;
  Status? status;
  Type? type;
  Priority? priority;
  CurrentUserInstance? agent;
  Customer? customer;
  String? isStarred;
  String? mailbox;
  List<String>? tags;
  Group? group;
  int? rating;
  // List<Null>? collaborators;
  String? referenceIds;
  bool? isAgentView;
  String? isCustomerView;
  // List<Null>? customFieldValues;
  String? uniqueReplyTo;
  bool? isTrashed;
  // List<Null>? ticketLabels;
  // List<Null>? ratings;
  bool? isNew;
  String? subgroup;
  String? agentLastRepliedAt;
  num? incrementId;
  String? socialChannel;
  bool? isSourceDeleted;
  String? ipAddress;
  bool? isReplied;
  String? customerLastRepliedAt;
  int? resolveSlaLevel;
  int? responseSlaLevel;
  String? country;
  String? project;
  String? formattedCreatedAt;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;

  Ticket({this.id, this.subject, this.source, this.formatedCreatedAt,
    // this.relatedPrestashopTicket,
    this.status, this.type, this.priority, this.agent, this.customer, this.isStarred, this.mailbox, this.tags, this.group, this.rating,
    // this.collaborators,
    this.referenceIds, this.isAgentView,
    this.isCustomerView,
    // this.customFieldValues,
    this.uniqueReplyTo, this.isTrashed,
    // this.ticketLabels, this.ratings,
    this.isNew, this.subgroup, this.agentLastRepliedAt, this.incrementId, this.socialChannel, this.isSourceDeleted, this.ipAddress, this.isReplied, this.customerLastRepliedAt, this.resolveSlaLevel, this.responseSlaLevel, this.country, this.project, this.formattedCreatedAt, this.createdAt, this.updatedAt});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    source = json['source'];
    formatedCreatedAt = json['formatedCreatedAt'];
    // if (json['relatedPrestashopTicket'] != null) {
    //   relatedPrestashopTicket = <Null>[];
    //   json['relatedPrestashopTicket'].forEach((v) { relatedPrestashopTicket!.add(new Null.fromJson(v)); });
    // }
    status = json['status'] != null ? new Status.fromJson(json['status']) : null;
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    priority = json['priority'] != null ? new Priority.fromJson(json['priority']) : null;
    agent = json['agent'] != null ? new CurrentUserInstance.fromJson(json['agent']) : null;
    customer = json['customer'] != null ? new Customer.fromJson(json['customer']) : null;
    isStarred = json['isStarred'].toString();
    mailbox = json['mailbox'].toString();
    if (json['tags'] != null) {
      tags = <String>[];
      json['tags'].forEach((v) { tags!.add(v); });
    }
    if(json['group'].runtimeType == Map) group =  Group.fromJson(json['group']);
    rating = json['rating'];
    // if (json['collaborators'] != null) {
    //   collaborators = <Null>[];
    //   json['collaborators'].forEach((v) { collaborators!.add(new Null.fromJson(v)); });
    // }
    referenceIds = json['referenceIds'];
    isAgentView = json['isAgentView'];
    isCustomerView = json['isCustomerView'];
    // if (json['customFieldValues'] != null) {
    //   customFieldValues = <Null>[];
    //   json['customFieldValues'].forEach((v) { customFieldValues!.add(new Null.fromJson(v)); });
    // }
    uniqueReplyTo = json['uniqueReplyTo'];
    isTrashed = json['isTrashed'];
    // if (json['ticketLabels'] != null) {
    //   ticketLabels = <Null>[];
    //   json['ticketLabels'].forEach((v) { ticketLabels!.add(new Null.fromJson(v)); });
    // }
    // if (json['ratings'] != null) {
    //   ratings = <Null>[];
    //   json['ratings'].forEach((v) { ratings!.add(new Null.fromJson(v)); });
    // }
    isNew = json['isNew'];
    subgroup = json['subgroup'];
    agentLastRepliedAt = json['agentLastRepliedAt'];
    incrementId = json['incrementId'];
    socialChannel = json['socialChannel'];
    isSourceDeleted = json['isSourceDeleted'];
    ipAddress = json['ipAddress'].toString();
    isReplied = json['isReplied'];
    customerLastRepliedAt = json['customerLastRepliedAt'];
    resolveSlaLevel = json['resolveSlaLevel'];
    responseSlaLevel = json['responseSlaLevel'];
    country = json['country'];
    project = json['project'].toString();
    formattedCreatedAt = json['formattedCreatedAt'];
    createdAt = json['createdAt'] != null ? new CreatedAt.fromJson(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? new CreatedAt.fromJson(json['updatedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['source'] = this.source;
    data['formatedCreatedAt'] = this.formatedCreatedAt;
    // if (this.relatedPrestashopTicket != null) {
    //   data['relatedPrestashopTicket'] = this.relatedPrestashopTicket!.map((v) => v.toJson()).toList();
    // }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    if (this.priority != null) {
      data['priority'] = this.priority!.toJson();
    }
    if (this.agent != null) {
      data['agent'] = this.agent!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['isStarred'] = this.isStarred;
    data['mailbox'] = this.mailbox;
    // if (this.tags != null) {
    //   data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    // }
    data['group'] = this.group;
    data['rating'] = this.rating;
    // if (this.collaborators != null) {
    //   data['collaborators'] = this.collaborators!.map((v) => v.toJson()).toList();
    // }
    data['referenceIds'] = this.referenceIds;
    data['isAgentView'] = this.isAgentView;
    data['isCustomerView'] = this.isCustomerView;
    // if (this.customFieldValues != null) {
    //   data['customFieldValues'] = this.customFieldValues!.map((v) => v.toJson()).toList();
    // }
    data['uniqueReplyTo'] = this.uniqueReplyTo;
    data['isTrashed'] = this.isTrashed;
    // if (this.ticketLabels != null) {
    //   data['ticketLabels'] = this.ticketLabels!.map((v) => v.toJson()).toList();
    // }
    // if (this.ratings != null) {
    //   data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
    // }
    data['isNew'] = this.isNew;
    data['subgroup'] = this.subgroup;
    data['agentLastRepliedAt'] = this.agentLastRepliedAt;
    data['incrementId'] = this.incrementId;
    data['socialChannel'] = this.socialChannel;
    data['isSourceDeleted'] = this.isSourceDeleted;
    data['ipAddress'] = this.ipAddress;
    data['isReplied'] = this.isReplied;
    data['customerLastRepliedAt'] = this.customerLastRepliedAt;
    data['resolveSlaLevel'] = this.resolveSlaLevel;
    data['responseSlaLevel'] = this.responseSlaLevel;
    data['country'] = this.country;
    data['project'] = this.project;
    data['formattedCreatedAt'] = this.formattedCreatedAt;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? description;
  String? color;
  int? sortOrder;

  Status({this.id, this.name, this.description, this.color, this.sortOrder});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = this.color;
    data['sortOrder'] = this.sortOrder;
    return data;
  }
}

class Type {
  int? id;
  String? name;
  String? description;
  bool? isActive;

  Type({this.id, this.name, this.description, this.isActive});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Priority {
  int? id;
  String? name;
  String? description;
  String? color;

  Priority({this.id, this.name, this.description, this.color});

  Priority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = this.color;
    return data;
  }
}

class CurrentUserInstance {
  int? id;
  int? companyId;
  UserRole? userRole;
  String? firstName;
  String? lastName;
  String? name;
  bool? isActive;
  String? isStarred;
  int? user;
  String? signature;
  List<Null>? userSavedFilters;
  // Null? defaultFiltering;
  // Null? managerGroup;
  // List<Null>? subGroup;
  // List<Null>? managerSubGroup;
  List<String>? agentPrivilege;
  int? ticketView;
  bool? isVerified;
  String? source;
  List<Null>? authorisedClients;
  String? assignedTeamIdReferences;
  String? assignedGroupIdReferences;
  bool? forceLogout;

  CurrentUserInstance({this.id, this.companyId, this.userRole, this.firstName, this.lastName, this.name, this.isActive, this.isStarred, this.user, this.signature, this.userSavedFilters,
    // this.defaultFiltering, this.managerGroup, this.subGroup, this.managerSubGroup,
    this.agentPrivilege, this.ticketView, this.isVerified, this.source, this.authorisedClients, this.assignedTeamIdReferences, this.assignedGroupIdReferences, this.forceLogout});

  CurrentUserInstance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    userRole = json['userRole'] != null ? new UserRole.fromJson(json['userRole']) : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    isActive = json['isActive'];
    isStarred = json['isStarred'];
    user = json['user'];
    signature = json['signature'];
    // if (json['userSavedFilters'] != null) {
    //   userSavedFilters = <Null>[];
    //   json['userSavedFilters'].forEach((v) { userSavedFilters!.add(new Null.fromJson(v)); });
    // }
    // defaultFiltering = json['defaultFiltering'];
    // managerGroup = json['managerGroup'];
    // if (json['subGroup'] != null) {
    //   subGroup = <Null>[];
    //   json['subGroup'].forEach((v) { subGroup!.add(new Null.fromJson(v)); });
    // }
    // if (json['managerSubGroup'] != null) {
    //   managerSubGroup = <Null>[];
    //   json['managerSubGroup'].forEach((v) { managerSubGroup!.add(new Null.fromJson(v)); });
    // }
    agentPrivilege = json['agentPrivilege'].cast<String>();
    ticketView = json['ticketView'];
    isVerified = json['isVerified'];
    source = json['source'];
    // if (json['authorisedClients'] != null) {
    //   authorisedClients = <Null>[];
    //   json['authorisedClients'].forEach((v) { authorisedClients!.add(new Null.fromJson(v)); });
    // }
    assignedTeamIdReferences = json['assignedTeamIdReferences'];
    assignedGroupIdReferences = json['assignedGroupIdReferences'];
    forceLogout = json['forceLogout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyId'] = this.companyId;
    if (this.userRole != null) {
      data['userRole'] = this.userRole!.toJson();
    }
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['isStarred'] = this.isStarred;
    data['user'] = this.user;
    data['signature'] = this.signature;
    // if (this.userSavedFilters != null) {
    //   data['userSavedFilters'] = this.userSavedFilters!.map((v) => v.toJson()).toList();
    // }
    // data['defaultFiltering'] = this.defaultFiltering;
    // data['managerGroup'] = this.managerGroup;
    // if (this.subGroup != null) {
    //   data['subGroup'] = this.subGroup!.map((v) => v.toJson()).toList();
    // }
    // if (this.managerSubGroup != null) {
    //   data['managerSubGroup'] = this.managerSubGroup!.map((v) => v.toJson()).toList();
    // }
    data['agentPrivilege'] = this.agentPrivilege;
    data['ticketView'] = this.ticketView;
    data['isVerified'] = this.isVerified;
    data['source'] = this.source;
    // if (this.authorisedClients != null) {
    //   data['authorisedClients'] = this.authorisedClients!.map((v) => v.toJson()).toList();
    // }
    data['assignedTeamIdReferences'] = this.assignedTeamIdReferences;
    data['assignedGroupIdReferences'] = this.assignedGroupIdReferences;
    data['forceLogout'] = this.forceLogout;
    return data;
  }
}

class UserRole {
  int? id;
  String? role;
  String? name;

  UserRole({this.id, this.role, this.name});

  UserRole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    return data;
  }
}

class Detail {
  CurrentUserInstance? agent;

  Detail({this.agent});

  Detail.fromJson(Map<String, dynamic> json) {
    agent = json['agent'] != null ? new CurrentUserInstance.fromJson(json['agent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.agent != null) {
      data['agent'] = this.agent!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? email;
  String? profileImage;
  String? smallThumbnail;
  String? isActive;
  String? enabled;
  String? currentUserInstance;
  String? currentUserAgentInstance;
  String? currentUserCustomerInstance;
  String? role;
  String? passwordLegal;
  bool? passwordObvious;
  Detail? detail;
  String? timezone;
  // List<Null>? managerGroup;
  // Null? teamleadSubGroup;
  // Null? userSubGroup;
  String? updatedPassword;
  String? updatedEmail;

  Customer({this.id, this.email, this.profileImage, this.smallThumbnail, this.isActive, this.enabled, this.currentUserInstance, this.currentUserAgentInstance, this.currentUserCustomerInstance, this.role, this.passwordLegal, this.passwordObvious, this.detail, this.timezone,
    // this.managerGroup, this.teamleadSubGroup, this.userSubGroup,
    this.updatedPassword, this.updatedEmail});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    profileImage = json['profileImage'].toString();
    smallThumbnail = json['smallThumbnail'].toString();
    isActive = json['isActive'].toString();
    enabled = json['enabled'].toString();
    currentUserInstance = json['currentUserInstance'].toString();
    currentUserAgentInstance = json['currentUserAgentInstance'].toString();
    currentUserCustomerInstance = json['currentUserCustomerInstance'].toString();
    role = json['role'].toString();
    passwordLegal = json['passwordLegal'].toString();
    passwordObvious = json['passwordObvious'];
    detail = json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    timezone = json['timezone'];
    // if (json['managerGroup'] != null) {
    //   managerGroup = <Null>[];
    //   json['managerGroup'].forEach((v) { managerGroup!.add(new Null.fromJson(v)); });
    // }
    // teamleadSubGroup = json['teamleadSubGroup'];
    // userSubGroup = json['userSubGroup'];
    updatedPassword = json['updatedPassword'].toString();
    updatedEmail = json['updatedEmail'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;
    data['smallThumbnail'] = this.smallThumbnail;
    data['isActive'] = this.isActive;
    data['enabled'] = this.enabled;
    data['currentUserInstance'] = this.currentUserInstance;
    data['currentUserAgentInstance'] = this.currentUserAgentInstance;
    data['currentUserCustomerInstance'] = this.currentUserCustomerInstance;
    data['role'] = this.role;
    data['passwordLegal'] = this.passwordLegal;
    data['passwordObvious'] = this.passwordObvious;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    data['timezone'] = this.timezone;
    // if (this.managerGroup != null) {
    //   data['managerGroup'] = this.managerGroup!.map((v) => v.toJson()).toList();
    // }
    // data['teamleadSubGroup'] = this.teamleadSubGroup;
    // data['userSubGroup'] = this.userSubGroup;
    data['updatedPassword'] = this.updatedPassword;
    data['updatedEmail'] = this.updatedEmail;
    return data;
  }
}

class CreatedAt {
  String? date;
  int? timezoneType;
  String? timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['timezone_type'] = this.timezoneType;
    data['timezone'] = this.timezone;
    return data;
  }
}

class Labels {
  Predefind? predefind;
  // List<Null>? custom;

  Labels({this.predefind,
    // this.custom
  });

  Labels.fromJson(Map<String, dynamic> json) {
    predefind = json['predefind'] != null ? new Predefind.fromJson(json['predefind']) : null;
    // if (json['custom'] != null) {
    //   custom = <Null>[];
    //   json['custom'].forEach((v) { custom!.add(new Null.fromJson(v)); });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.predefind != null) {
      data['predefind'] = this.predefind!.toJson();
    }
    // if (this.custom != null) {
    //   data['custom'] = this.custom!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class UserDetails {
  int? user;
  String? name;
  Null? pic;
  bool? role;

  UserDetails({this.user, this.name, this.pic, this.role});

  UserDetails.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    name = json['name'];
    pic = json['pic'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['name'] = this.name;
    data['pic'] = this.pic;
    data['role'] = this.role;
    return data;
  }
}

class CreateThread {
  int? id;
  String? reply;
  String? fullname;
  String? source;
  String? threadType;
  String? replyTo;
  List<String>? cc;
  List<String>? bcc;
  String? userType;
  CreatedAt? createdAt;
  String? viewedAt;
  String? messageId;
  String? mailStatus;
  bool? isLocked;
  String? bookmark;
  List<ThreadAttachmentModel>? attachments;
  User? user;
  String? formatedCreatedAt;
  int? timestamp;

  CreateThread({this.id, this.reply, this.fullname, this.source, this.threadType, this.replyTo, this.cc, this.bcc, this.userType, this.createdAt, this.viewedAt, this.messageId, this.mailStatus, this.isLocked, this.bookmark, this.attachments, this.user, this.formatedCreatedAt, this.timestamp});

  CreateThread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reply = json['reply'];
    fullname = json['fullname'];
    source = json['source'];
    threadType = json['threadType'];
    replyTo = json['replyTo'];
    cc = (json['cc'].runtimeType == List) ? json['cc'] : null;
    bcc = (json['bcc'].runtimeType == List) ? json['bcc'] : null;
    userType = json['userType'];
    createdAt = json['createdAt'] != null ? new CreatedAt.fromJson(json['createdAt']) : null;
    viewedAt = json['viewedAt'];
    messageId = json['messageId'];
    mailStatus = json['mailStatus'];
    isLocked = json['isLocked'];
    bookmark = json['bookmark'];
    if (json['attachments'] != null) {
      attachments = <ThreadAttachmentModel>[];
      json['attachments'].forEach((v) { attachments!.add(ThreadAttachmentModel.fromJson(v)); });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    formatedCreatedAt = json['formatedCreatedAt'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reply'] = this.reply;
    data['fullname'] = this.fullname;
    data['source'] = this.source;
    data['threadType'] = this.threadType;
    data['replyTo'] = this.replyTo;
    data['cc'] = this.cc;
    data['bcc'] = this.bcc;
    data['userType'] = this.userType;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    data['viewedAt'] = this.viewedAt;
    data['messageId'] = this.messageId;
    data['mailStatus'] = this.mailStatus;
    data['isLocked'] = this.isLocked;
    data['bookmark'] = this.bookmark;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['formatedCreatedAt'] = this.formatedCreatedAt;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class ThreadAttachmentModel {
  int? id;
  String? name;
  String? path;
  String? contentType;
  int? size;
  String? fileSystem;
  String? attachmentThumb;
  String? attachmentOrginal;

  ThreadAttachmentModel(
      {this.id,
        this.name,
        this.path,
        this.contentType,
        this.size,
        this.fileSystem,
        this.attachmentThumb,
        this.attachmentOrginal});

  ThreadAttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    contentType = json['contentType'];
    size = json['size'];
    fileSystem = json['fileSystem'];
    attachmentThumb = json['attachmentThumb'];
    attachmentOrginal = json['attachmentOrginal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['path'] = this.path;
    data['contentType'] = this.contentType;
    data['size'] = this.size;
    data['fileSystem'] = this.fileSystem;
    data['attachmentThumb'] = this.attachmentThumb;
    data['attachmentOrginal'] = this.attachmentOrginal;
    return data;
  }
}

class User {
  int? id;
  String? email;
  String? name;
  String? firstName;
  Null? profileImage;
  Null? smallThumbnail;

  User({this.id, this.email, this.name, this.firstName, this.profileImage, this.smallThumbnail});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    firstName = json['firstName'];
    profileImage = json['profileImage'];
    smallThumbnail = json['smallThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['profileImage'] = this.profileImage;
    data['smallThumbnail'] = this.smallThumbnail;
    return data;
  }
}


class Attachments {
  int? id;
  String? name;
  String? path;
  String? relativePath;
  String? iconURL;
  String? downloadURL;

  Attachments({
    this.id,
    this.name,
    this.path,
    this.relativePath,
    this.iconURL,
    this.downloadURL,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int? ?? 0;
    name = json['name'] as String? ?? '';
    path = json['path'] as String? ?? '';
    relativePath = json['relativePath'] as String? ?? '';
    iconURL = json['iconURL'] as String? ?? '';
    downloadURL = json['downloadURL'] as String? ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['path'] = this.path;
    data['relativePath'] = this.relativePath;
    data['iconURL'] = this.iconURL;
    data['downloadURL'] = this.downloadURL;
    return data;
  }

}
