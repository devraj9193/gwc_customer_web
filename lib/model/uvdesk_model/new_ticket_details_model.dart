import 'get_ticket_list_model.dart';

class NewTicketDetailsModel {
  Ticket? ticket;
  int? totalCustomerTickets;
  List<SupportGroups>? supportGroups;
  // List<Null>? supportTeams;
  List<TicketStatuses>? ticketStatuses;
  List<TicketPriorities>? ticketPriorities;
  List<TicketTypes>? ticketTypes;

  NewTicketDetailsModel(
      {this.ticket,
        this.totalCustomerTickets,
        this.supportGroups,
        // this.supportTeams,
        this.ticketStatuses,
        this.ticketPriorities,
        this.ticketTypes});

  NewTicketDetailsModel.fromJson(Map<String, dynamic> json) {
    ticket =
    json['ticket'] != null ? new Ticket.fromJson(json['ticket']) : null;
    totalCustomerTickets = json['totalCustomerTickets'];
    if (json['supportGroups'] != null) {
      supportGroups = <SupportGroups>[];
      json['supportGroups'].forEach((v) {
        supportGroups!.add(new SupportGroups.fromJson(v));
      });
    }
    // if (json['supportTeams'] != null) {
    //   supportTeams = <Null>[];
    //   json['supportTeams'].forEach((v) {
    //     supportTeams!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['ticketStatuses'] != null) {
      ticketStatuses = <TicketStatuses>[];
      json['ticketStatuses'].forEach((v) {
        ticketStatuses!.add(new TicketStatuses.fromJson(v));
      });
    }
    if (json['ticketPriorities'] != null) {
      ticketPriorities = <TicketPriorities>[];
      json['ticketPriorities'].forEach((v) {
        ticketPriorities!.add(new TicketPriorities.fromJson(v));
      });
    }
    if (json['ticketTypes'] != null) {
      ticketTypes = <TicketTypes>[];
      json['ticketTypes'].forEach((v) {
        ticketTypes!.add(new TicketTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.toJson();
    }
    data['totalCustomerTickets'] = this.totalCustomerTickets;
    if (this.supportGroups != null) {
      data['supportGroups'] =
          this.supportGroups!.map((v) => v.toJson()).toList();
    }
    // if (this.supportTeams != null) {
    //   data['supportTeams'] = this.supportTeams!.map((v) => v.toJson()).toList();
    // }
    if (this.ticketStatuses != null) {
      data['ticketStatuses'] =
          this.ticketStatuses!.map((v) => v.toJson()).toList();
    }
    if (this.ticketPriorities != null) {
      data['ticketPriorities'] =
          this.ticketPriorities!.map((v) => v.toJson()).toList();
    }
    if (this.ticketTypes != null) {
      data['ticketTypes'] = this.ticketTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketPriorities {
  int? id;
  String? code;
  String? colorCode;
  String? description;

  TicketPriorities({this.id, this.code, this.colorCode, this.description});

  TicketPriorities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    colorCode = json['colorCode'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['colorCode'] = this.colorCode;
    data['description'] = this.description;
    return data;
  }
}

class SupportGroups {
  int? id;
  String? name;

  SupportGroups({this.id, this.name});

  SupportGroups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}


class Ticket {
  int? id;
  String? source;
  int? priority;
  int? status;
  String? subject;
  bool? isNew;
  bool? isReplied;
  bool? isReplyEnabled;
  bool? isStarred;
  bool? isTrashed;
  bool? isAgentViewed;
  bool? isCustomerViewed;
  String? createdAt;
  String? updatedAt;
  Group? group;
  Team? team;
  List<Threads>? threads;
  Agent? agent;
  Agent? customer;
  int? totalThreads;

  Ticket(
      {this.id,
        this.source,
        this.priority,
        this.status,
        this.subject,
        this.isNew,
        this.isReplied,
        this.isReplyEnabled,
        this.isStarred,
        this.isTrashed,
        this.isAgentViewed,
        this.isCustomerViewed,
        this.createdAt,
        this.updatedAt,
        this.group,
        this.team,
        this.threads,
        this.agent,
        this.customer,
        this.totalThreads});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
    priority = json['priority'];
    status = json['status'];
    subject = json['subject'];
    isNew = json['isNew'];
    isReplied = json['isReplied'];
    isReplyEnabled = json['isReplyEnabled'];
    isStarred = json['isStarred'];
    isTrashed = json['isTrashed'];
    isAgentViewed = json['isAgentViewed'];
    isCustomerViewed = json['isCustomerViewed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
    team = json['team'];
    if (json['threads'] != null) {
      threads = <Threads>[];
      json['threads'].forEach((v) {
        threads!.add(new Threads.fromJson(v));
      });
    }
    agent = json['agent'] != null ? new Agent.fromJson(json['agent']) : null;
    customer =
    json['customer'] != null ? new Agent.fromJson(json['customer']) : null;
    totalThreads = json['totalThreads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source'] = this.source;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['subject'] = this.subject;
    data['isNew'] = this.isNew;
    data['isReplied'] = this.isReplied;
    data['isReplyEnabled'] = this.isReplyEnabled;
    data['isStarred'] = this.isStarred;
    data['isTrashed'] = this.isTrashed;
    data['isAgentViewed'] = this.isAgentViewed;
    data['isCustomerViewed'] = this.isCustomerViewed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.group != null) {
      data['group'] = this.group!.toJson();
    }
    data['team'] = this.team;
    if (this.threads != null) {
      data['threads'] = this.threads!.map((v) => v.toJson()).toList();
    }
    if (this.agent != null) {
      data['agent'] = this.agent!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    data['totalThreads'] = this.totalThreads;
    return data;
  }
}

class Group {
  int? id;
  String? name;

  Group({this.id, this.name});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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

  Attachments(
      {this.id,
        this.name,
        this.path,
        this.relativePath,
        this.iconURL,
        this.downloadURL});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    relativePath = json['relativePath'];
    iconURL = json['iconURL'];
    downloadURL = json['downloadURL'];
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

class User {
  int? id;
  String? name;
  String? email;
  String? thumbnail;

  User({this.id, this.name, this.email, this.thumbnail});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

class Agent {
  int? id;
  String? email;
  String? name;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? thumbnail;

  Agent(
      {this.id,
        this.email,
        this.name,
        this.firstName,
        this.lastName,
        this.contactNumber,
        this.thumbnail});

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['contactNumber'] = this.contactNumber;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

class TicketStatuses {
  int? id;
  String? code;
  String? colorCode;
  String? description;

  TicketStatuses({this.id, this.code, this.colorCode, this.description});

  TicketStatuses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    colorCode = json['colorCode'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['colorCode'] = this.colorCode;
    data['description'] = this.description;
    return data;
  }
}

class TicketTypes {
  int? id;
  String? code;
  bool? isActive;
  String? description;

  TicketTypes({this.id, this.code, this.isActive, this.description});

  TicketTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    isActive = json['isActive'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['isActive'] = this.isActive;
    data['description'] = this.description;
    return data;
  }
}


class Threads {
  int? id;
  String? source;
  String? threadType;
  String? createdBy;
  List<String>? cc;
  List<String>? bcc;
  bool? isLocked;
  bool? isBookmarked;
  String? message;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<Attachments>? attachments;

  Threads(
      {this.id,
        this.source,
        this.threadType,
        this.createdBy,
        this.cc,
        this.bcc,
        this.isLocked,
        this.isBookmarked,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.attachments});

  Threads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
    threadType = json['threadType'];
    createdBy = json['createdBy'];
    cc = json['cc'];
    bcc = json['bcc'];
    isLocked = json['isLocked'];
    isBookmarked = json['isBookmarked'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['source'] = this.source;
    data['threadType'] = this.threadType;
    data['createdBy'] = this.createdBy;
    data['cc'] = this.cc;
    data['bcc'] = this.bcc;
    data['isLocked'] = this.isLocked;
    data['isBookmarked'] = this.isBookmarked;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
