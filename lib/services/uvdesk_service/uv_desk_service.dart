import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../model/uvdesk_model/get_ticket_list_model.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';

class UvDeskService extends ChangeNotifier{
  final _dummy = [
    {
      "id": 4,
      "subject": "hey",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "04-08-2023 12:08pm",
      "totalThreads": "0",
      "agent": {
        "id": 3,
        "email": "amithk@fembuddy.com",
        "name": "Dr Amith",
        "firstName": "Dr",
        "lastName": "Amith",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": null,
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 3,
      "subject": "Fever",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": {
        "id": 2,
        "name": "Ani-AMITH",
        "description": "amith@fembuddy.com",
        "createdAt": {
          "date": "2023-08-02 16:14:08.000000",
          "timezone_type": 3,
          "timezone": "UTC"
        },
        "isActive": true,
        "userView": false
      },
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 15:18pm",
      "totalThreads": "11",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 2,
      "subject": "to",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:20am",
      "totalThreads": "4",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 1,
      "subject": "yo",
      "isCustomerView": false,
      "status": null,
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:16am",
      "totalThreads": "5",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 5,
      "subject": "hey",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "04-08-2023 12:08pm",
      "totalThreads": "0",
      "agent": {
        "id": 3,
        "email": "amithk@fembuddy.com",
        "name": "Dr Amith",
        "firstName": "Dr",
        "lastName": "Amith",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": null,
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 6,
      "subject": "Fever",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": {
        "id": 2,
        "name": "Ani-AMITH",
        "description": "amith@fembuddy.com",
        "createdAt": {
          "date": "2023-08-02 16:14:08.000000",
          "timezone_type": 3,
          "timezone": "UTC"
        },
        "isActive": true,
        "userView": false
      },
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 15:18pm",
      "totalThreads": "11",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 7,
      "subject": "to",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:20am",
      "totalThreads": "4",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 8,
      "subject": "yo",
      "isCustomerView": false,
      "status": null,
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:16am",
      "totalThreads": "5",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 9,
      "subject": "hey",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "04-08-2023 12:08pm",
      "totalThreads": "0",
      "agent": {
        "id": 3,
        "email": "amithk@fembuddy.com",
        "name": "Dr Amith",
        "firstName": "Dr",
        "lastName": "Amith",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": null,
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 10,
      "subject": "Fever",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": {
        "id": 2,
        "name": "Ani-AMITH",
        "description": "amith@fembuddy.com",
        "createdAt": {
          "date": "2023-08-02 16:14:08.000000",
          "timezone_type": 3,
          "timezone": "UTC"
        },
        "isActive": true,
        "userView": false
      },
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 15:18pm",
      "totalThreads": "11",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 11,
      "subject": "to",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:20am",
      "totalThreads": "4",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 12,
      "subject": "yo",
      "isCustomerView": false,
      "status": null,
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:16am",
      "totalThreads": "5",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 13,
      "subject": "hey",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "04-08-2023 12:08pm",
      "totalThreads": "0",
      "agent": {
        "id": 3,
        "email": "amithk@fembuddy.com",
        "name": "Dr Amith",
        "firstName": "Dr",
        "lastName": "Amith",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": null,
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 14,
      "subject": "Fever",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": {
        "id": 2,
        "name": "Ani-AMITH",
        "description": "amith@fembuddy.com",
        "createdAt": {
          "date": "2023-08-02 16:14:08.000000",
          "timezone_type": 3,
          "timezone": "UTC"
        },
        "isActive": true,
        "userView": false
      },
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 15:18pm",
      "totalThreads": "11",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 5,
        "email": "ankit123@gmail.com",
        "name": "Ankit K",
        "firstName": "Ankit",
        "lastName": "K",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 15,
      "subject": "to",
      "isCustomerView": false,
      "status": {
        "id": 1,
        "code": "open",
        "description": "Open",
        "colorCode": "#7E91F0",
        "sortOrder": 1
      },
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:20am",
      "totalThreads": "4",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    },
    {
      "id": 16,
      "subject": "yo",
      "isCustomerView": false,
      "status": null,
      "source": "api",
      "isStarred": false,
      "group": null,
      "type": {
        "id": 1,
        "code": "support",
        "description": "Support",
        "isActive": true
      },
      "priority": {
        "id": 1,
        "code": "low",
        "description": "Low",
        "colorCode": "#2DD051"
      },
      "formatedCreatedAt": "03-08-2023 10:16am",
      "totalThreads": "5",
      "agent": {
        "id": 2,
        "email": "dg@gmail.com",
        "name": "Ani H",
        "firstName": "Ani",
        "lastName": "H",
        "isEnabled": true,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-batman.png",
        "isActive": true,
        "isVerified": false,
        "designation": "Success",
        "contactNumber": null,
        "signature": null,
        "ticketAccessLevel": "2"
      },
      "customer": {
        "id": 4,
        "email": "amith@gmail.com",
        "name": "Amith G k",
        "firstName": "Amith",
        "lastName": "G k",
        "contactNumber": null,
        "profileImagePath": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png",
        "smallThumbnail": "https://localhost/bundles/uvdeskcoreframework/images/uv-avatar-ironman.png"
      }
    }
  ];

  late final UvDeskRepo? uvDeskRepo;

  int perPage = 10;
  int start = 0;
  late int end = perPage;

  bool hasMore = false;

  List<Tickets> _allTickets = [];
  List<Tickets> get allTickets => _allTickets;

  List<Tickets> _fetchedTickets = [];
  List<Tickets> get fetchedTickets => _fetchedTickets;

  StreamController _stream = StreamController.broadcast();
  StreamController get stream => _stream;

  setAllTickets(List<Tickets> tickets){
    print("setAllTickets: ${tickets}");
    // _dummy.forEach((element) {
    //   _allTickets.add(Tickets.fromJson(element));
    // });
    _allTickets.addAll(tickets);
    getLoadedTickets();
  }

  clearFetchedTickets(){
    start = 0;
    _fetchedTickets.clear();
  }

  clearAllTickets(){
    start = 0;
    _allTickets.clear();
    _fetchedTickets.clear();
  }

  getLoadedTickets(){
    print("getLoadedTickets");
    print("_fetchedTickets.length: ${_fetchedTickets.length}");
    print("_allTickets.length: ${_allTickets.length}");
    print(_fetchedTickets.length != _allTickets.length);

    if(_fetchedTickets.length != _allTickets.length){
      if(start+perPage >= _allTickets.length){
        _fetchedTickets.addAll(_allTickets.getRange(start, _allTickets.length));
        start = start + (_allTickets.length-start);
      }
      else{
        _fetchedTickets.addAll(_allTickets.getRange(start, perPage));
        start = start + perPage;
      }
      hasMore = true;
    }
    else{
      hasMore = false;
    }
    if(_allTickets.length < perPage){
      hasMore = false;
    }
   Future.delayed(Duration.zero).whenComplete(() {
     notifyListeners();
   });
  }

  onScroll(int start, int end){
    _fetchedTickets.addAll(_allTickets.getRange(start, end));
    Future.delayed(Duration.zero).whenComplete(() {
      notifyListeners();
    });
  }


  UvDeskService({this.uvDeskRepo});

  Future getTicketListService(String email, int index) async{
    return await uvDeskRepo!.getTicketListRepo(email, index);
  }

  Future getTicketDetailsByIdService(String id) async{
    return await uvDeskRepo!.getTicketDetailsByIdRepo(id);
  }

  Future createTicketService(Map data, {List<File>? attachments}) async{
    return await uvDeskRepo!.createTicketRepo(data, attachments: attachments);
  }

  Future getTicketsByCustomerIdService(String customerId, String statusId) async{
    return await uvDeskRepo!.getTicketsByCustomerIdRepo(customerId, statusId);
  }

  Future sendReplyService(String ticketId, Map data, {List<PlatformFile>? attachments}) async{
    return await uvDeskRepo!.sendReplyRepo(ticketId, data, attachments: attachments);
  }

  Future reOpenTicketService(String ticketId) async{
    return await uvDeskRepo!.reOpenTicketRepo(ticketId);
  }




}

///  1|2|3|4|5|6 for open,pending,answered,resolved,closed,spam
enum TicketStatusType {
  open,pending,answered,resolved,closed,spam
}

enum ThreadType{
  reply,forward,note
}

/// when we need to pass from customer than need to pass customer and also need to pass ActAsEmail
enum ActAsType{
  customer,agent
}