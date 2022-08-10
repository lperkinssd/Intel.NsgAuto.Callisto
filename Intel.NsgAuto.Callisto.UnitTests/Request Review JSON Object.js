// JavaScript source code

requestReview =
{
    "IsCompleted": false,
    "RequestReviewSteps":
    [
        {
            "Status": 0,
            "StatusText": "open",
            "IsCurrentStage": true,
            "RequestReviewStage": {
                "Id": 2,
                "ParentId": 0,
                "RequestId": "00000000-0000-0000-0000-000000000000",
                "StageSequence": 10,
                "StageName": "Request Approval",
                "DisplayName": null,
                "IsNextInParallel": false
            },
            "RequestReviewGroupReviewers": [
                {
                    "RequestReviewGroup": {
                        "Id": 1,
                        "RequestId": "00000000-0000-0000-0000-000000000000",
                        "RequestReviewStageId": 2,
                        "GroupName": "Generator",
                        "DisplayName": null,
                        "ReviewStatus": 0,
                        "ReviewStatusText": "open",
                        "IsCheckListCompleted": false
                    },
                    "RequestReviewReviewers":
                    [
                        {
                            "Id": 46295,
                            "RequestReviewStageId": 2,
                            "RequestReviewGroupId": 1,
                            "wwid": "11914464",
                            "idsid": "jterraza",
                            "Employee": {
                                "WWID": "11914464",
                                "Idsid": "jterraza",
                                "Name": "Terrazas, Jose",
                                "FirstName": null,
                                "MiddleName": null,
                                "LastName": null,
                                "Email": "jose.terrazas@domain.com",
                                "Location": null,
                                "BadgeType": null,
                                "Manager": null,
                                "Roles": null
                            },
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "Comment": "",
                            "ReviewDate": "\/Date(-62135568000000)\/"
                        },
                        {
                            "Id": 46301,
                            "RequestReviewStageId": 2,
                            "RequestReviewGroupId": 1,
                            "wwid": "11330800",
                            "idsid": "jkurian",
                            "Employee": {
                                "WWID": "11330800",
                                "Idsid": "jkurian",
                                "Name": "Kurian, Jose",
                                "FirstName": null,
                                "MiddleName": null,
                                "LastName": null,
                                "Email": "jose.kurian@domain.com",
                                "Location": null,
                                "BadgeType": null,
                                "Manager": null,
                                "Roles": null
                            },
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "Comment": "",
                            "ReviewDate": "\/Date(-62135568000000)\/"
                        }
                    ]
                }
            ]
            , "ChildSteps": []
        },
        {
            "Status": 0,
            "StatusText": "open",
            "IsCurrentStage": false,
            "RequestReviewStage": {
                "Id": 4,
                "ParentId": 0,
                "RequestId": "00000000-0000-0000-0000-000000000000",
                "StageSequence": 40,
                "StageName": "MDP Approval",
                "DisplayName": null,
                "IsNextInParallel": false
            },
            "RequestReviewGroupReviewers": [],
            "ChildSteps":
            [
                {
                    "Status": 0,
                    "StatusText": "open",
                    "IsCurrentStage": false,
                    "RequestReviewStage": {
                        "Id": 5,
                        "ParentId": 4,
                        "RequestId": "00000000-0000-0000-0000-000000000000",
                        "StageSequence": 41,
                        "StageName": "Frame GEN Out Approval",
                        "DisplayName": null,
                        "IsNextInParallel": true
                    },
                    "RequestReviewGroupReviewers": [{
                        "RequestReviewGroup": {
                            "Id": 1,
                            "RequestId": "00000000-0000-0000-0000-000000000000",
                            "RequestReviewStageId": 5,
                            "GroupName": "Generator",
                            "DisplayName": null,
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "IsCheckListCompleted": false
                        },
                        "RequestReviewReviewers": [{
                            "Id": 46297,
                            "RequestReviewStageId": 5,
                            "RequestReviewGroupId": 1,
                            "wwid": "11914464",
                            "idsid": "jterraza",
                            "Employee": {
                                "WWID": "11914464",
                                "Idsid": "jterraza",
                                "Name": "Terrazas, Jose",
                                "FirstName": null,
                                "MiddleName": null,
                                "LastName": null,
                                "Email": "jose.terrazas@domain.com",
                                "Location": null,
                                "BadgeType": null,
                                "Manager": null,
                                "Roles": null
                            },
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "Comment": "",
                            "ReviewDate": "\/Date(-62135568000000)\/"
                        }]
                    }],
                    "ChildSteps": []
                },
                {
                    "Status": 0,
                    "StatusText": "open",
                    "IsCurrentStage": false,
                    "RequestReviewStage":
                    {
                        "Id": 7,
                        "ParentId": 4,
                        "RequestId": "00000000-0000-0000-0000-000000000000",
                        "StageSequence": 43,
                        "StageName": "Die GEN Out Approval",
                        "DisplayName": null,
                        "IsNextInParallel": true
                    },
                    "RequestReviewGroupReviewers":
                    [
                        {
                            "RequestReviewGroup":
                            {
                                "Id": 1,
                                "RequestId": "00000000-0000-0000-0000-000000000000",
                                "RequestReviewStageId": 7,
                                "GroupName": "Generator",
                                "DisplayName": null,
                                "ReviewStatus": 0,
                                "ReviewStatusText": "open",
                                "IsCheckListCompleted": false
                            },
                            "RequestReviewReviewers":
                            [
                                {
                                    "Id": 46298,
                                    "RequestReviewStageId": 7,
                                    "RequestReviewGroupId": 1,
                                    "wwid": "11914464",
                                    "idsid": "jterraza",
                                    "Employee":
                                    {
                                        "WWID": "11914464",
                                        "Idsid": "jterraza",
                                        "Name": "Terrazas, Jose",
                                        "FirstName": null,
                                        "MiddleName": null,
                                        "LastName": null,
                                        "Email": "jose.terrazas@domain.com",
                                        "Location": null,
                                        "BadgeType": null,
                                        "Manager": null,
                                        "Roles": null
                                    }, "ReviewStatus": 0,
                                    "ReviewStatusText": "open",
                                    "Comment": "",
                                    "ReviewDate": "\/Date(-62135568000000)\/"
                                }
                            ]
                        },
                        {
                            "RequestReviewGroup":
                            {
                                "Id": 3,
                                "RequestId": "00000000-0000-0000-0000-000000000000",
                                "RequestReviewStageId": 7,
                                "GroupName": "Litho",
                                "DisplayName": null,
                                "ReviewStatus": 0,
                                "ReviewStatusText": "open",
                                "IsCheckListCompleted": false
                            },
                            "RequestReviewReviewers":
                            [
                                {
                                    "Id": 46299,
                                    "RequestReviewStageId": 7,
                                    "RequestReviewGroupId": 3,
                                    "wwid": "11914464",
                                    "idsid": "jterraza",
                                    "Employee":
                                    {
                                        "WWID": "11914464",
                                        "Idsid": "jterraza",
                                        "Name": "Terrazas, Jose",
                                        "FirstName": null,
                                        "MiddleName": null,
                                        "LastName": null,
                                        "Email": "jose.terrazas@domain.com",
                                        "Location": null,
                                        "BadgeType": null,
                                        "Manager": null,
                                        "Roles": null
                                    },
                                    "ReviewStatus": 0,
                                    "ReviewStatusText": "open",
                                    "Comment": "",
                                    "ReviewDate": "\/Date(-62135568000000)\/"
                                }
                            ]
                        }
                    ]
                    ,
                    "ChildSteps": []
                }
            ]
        },
        {
            "Status": 0,
            "StatusText": "open",
            "IsCurrentStage": false,
            "RequestReviewStage":
            {
                "Id": 10,
                "ParentId": 0,
                "RequestId": "00000000-0000-0000-0000-000000000000",
                "StageSequence": 60,
                "StageName": "Write Release",
                "DisplayName": null,
                "IsNextInParallel": false
            },
            "RequestReviewGroupReviewers":
            [
                {
                    "RequestReviewGroup":
                    {
                        "Id": 1,
                        "RequestId": "00000000-0000-0000-0000-000000000000",
                        "RequestReviewStageId": 10,
                        "GroupName": "Generator",
                        "DisplayName": null,
                        "ReviewStatus": 0,
                        "ReviewStatusText": "open",
                        "IsCheckListCompleted": false
                    },
                    "RequestReviewReviewers":
                    [
                        {
                            "Id": 46296,
                            "RequestReviewStageId": 10,
                            "RequestReviewGroupId": 1,
                            "wwid": "11914464",
                            "idsid": "jterraza",
                            "Employee":
                            {
                                "WWID": "11914464",
                                "Idsid": "jterraza",
                                "Name": "Terrazas, Jose",
                                "FirstName": null,
                                "MiddleName": null,
                                "LastName": null,
                                "Email": "jose.terrazas@domain.com",
                                "Location": null,
                                "BadgeType": null,
                                "Manager": null,
                                "Roles": null
                            },
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "Comment": "",
                            "ReviewDate": "\/Date(-62135568000000)\/"
                        },
                        {
                            "Id": 46300,
                            "RequestReviewStageId": 10,
                            "RequestReviewGroupId": 1,
                            "wwid": "11330800",
                            "idsid": "jkurian",
                            "Employee":
                            {
                                "WWID": "11330800",
                                "Idsid": "jkurian",
                                "Name": "Kurian, Jose",
                                "FirstName": null,
                                "MiddleName": null,
                                "LastName": null,
                                "Email": "jose.kurian@domain.com",
                                "Location": null,
                                "BadgeType": null,
                                "Manager": null,
                                "Roles": null
                            },
                            "ReviewStatus": 0,
                            "ReviewStatusText": "open",
                            "Comment": "", "ReviewDate": "\/Date(-62135568000000)\/"
                        }
                    ]
                }
            ],
            "ChildSteps": []
        }
    ]
};
