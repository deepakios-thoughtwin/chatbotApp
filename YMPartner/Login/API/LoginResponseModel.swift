//
//  LoginResponseModel.swift
//  YMSupport
//
//  Created by Kauntey Suryawanshi on 22/04/21.
//

import Foundation

public struct GenericResponseModel<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T
}

enum UserRole: String, Codable {
    case superAdmin = "ROLE_BOT_SUPER_ADMIN"
    case agent = "ROLE_BOT_AGENT"
    case admin = "ROLE_BOT_ADMIN"
    case echoAdmin = "ROLE_BOT_ECHO_ADMIN" // Support-Admin
    case developer = "ROLE_BOT_DEVELOPER"
}

struct LoginResponseModel: Codable {
    struct User: Codable {
        struct Role: Codable {
            let role: UserRole?
            let owner: String?
        }

        let username: String // "priyankyellowmessengercom",
        let name: String // "Priyank Upadhyay",
        let id: Int
        //        let proPic: String // null,
        let email: String // "priyank@yellowmessenger.com",
        //        let xmppPassword: String // null,
        let roles: [Role]
    }
    let accessToken: String?
    let user: User?
    let username: String?

    // Login error only one key
    let error: String?

    //2FA success
    let twoFactorToken: String?

    //2FA error response
    let success: Bool?
    let message: String?
}

extension LoginResponseModel {
    func roleForBot(botId: String) -> UserRole? {
        user?.roles.first { botId == $0.owner }?.role
    }
}

/*
{
    "access_token": "2e157b02ed26e91958ea6a9c02a69cadf2b5606f1e8f0b2d9caadd6fa1abf99b",
    "user": {
        "username": "priyankyellowmessengercom",
        "name": "Priyank Upadhyay",
        "id": 79689,
        "proPic": null,
        "email": "priyank@yellowmessenger.com",
        "xmppPassword": null,
        "roles": [
            {
                "role": "ROLE_BOT_ADMIN",
                "owner": "x1560419794579"
            },
            {
                "role": "ROLE_BOT_ADMIN",
                "owner": "x1562641985697"
            },
            {
                "role": "ROLE_BOT_AGENT",
                "owner": "x1553936559750"
            },
            {
                "role": "ROLE_BOT_AGENT",
                "owner": "x1570766838219"
            },
            {
                "role": "ROLE_BOT_ECHO_ADMIN",
                "owner": "x1553936559750"
            },
            {
                "role": "ROLE_BOT_ECHO_ADMIN",
                "owner": "x1564465548131"
            }
        ]
    },
    "username": "priyankyellowmessengercom"
}
*/


/*
{
  "username" : "kaunteyayellowmessengercom",
  "twoFactorToken" : "37486ed81803c45725994cd537b48f454a70f00066206f93ba366897186b7b96"
}
*/
