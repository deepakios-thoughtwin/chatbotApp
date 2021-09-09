//
//  URLRequestBuilder.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 28/06/21.
//

import Foundation

enum URLRequestBuilder {
    enum HTTPMethod: String { case get, post }

    static let baseURL = URL(string: "https://app.yellow.ai/api/")!

    static func makeURLRequest(path: String, method: HTTPMethod, accessToken: String? = nil, httpBody: [String: Any]? = nil, queryItems: [String: String]? = nil) throws -> URLRequest {

        var compo = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        compo.queryItems = queryItems?.map { URLQueryItem(name: $0.key, value: $0.value) }

        var request = URLRequest(url: compo.url!)

        request.httpMethod = method.rawValue.capitalized
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if let token = accessToken {
            request.setValue(token, forHTTPHeaderField: "x-auth-token")
        }

        if let body = httpBody {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        return request
    }
}

//MARK: - Login
extension URLRequestBuilder {
    static func login(userName: String, encryptedPassword: String) throws -> URLRequest {
        let body = ["username": userName, "password": encryptedPassword, "type": "account", "referrer": "mobileApp"]
        return try makeURLRequest(path: "sso/v2login", method: .post, httpBody: body)
    }

    static func sendOTP(userName: String, twoFAToken: String) throws -> URLRequest {
        let body = ["username": userName, "token": twoFAToken]
        return try makeURLRequest(path: "sso/generateTwoFactorToken", method: .post, httpBody: body)
    }

    static func verifyOTP(otp: String, userName: String, twoFAToken: String) throws  -> URLRequest {
        let body = ["payload": ["otp": otp, "username": userName, "token": twoFAToken, "referrer": "web"]]
        return try makeURLRequest(path: "sso/verifyTwoFactorToken", method: .post, httpBody: body)
    }

    static func changePassword(userName: String, encryptedOld old: String, encryptedNew new: String, accessToken: String) throws  -> URLRequest {
        let body = ["new_password": new, "old_password": old, "username": userName, "type": "account", "referrer": "mobileApp"]
        return try makeURLRequest(path: "sso/changePass", method: .post, accessToken: accessToken, httpBody: body)
    }
}
