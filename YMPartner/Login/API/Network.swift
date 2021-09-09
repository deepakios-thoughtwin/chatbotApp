//
//  YMData.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 28/06/21.
//

import Foundation
import Combine

struct Network {
    private static let decoder = YMJSONDecoder()
    private static var storage = Set<AnyCancellable>()

//    @UserDefault(key: "YMAuthToken")
//    static var accessToken: String?
//
//    @UserDefault(key: "YMUsername")
//    static var username: String?
//
//    @UserDefault(key: "YMBotId")
//    static var botId: String?
//
//    static var loginResponse: LoginResponseModel?
}

extension Network {
    static func login(username: String, encryptedPassword: String) -> Future<LoginResponseModel, Error> {
        do {
            let req = try URLRequestBuilder.login(userName: username, encryptedPassword: encryptedPassword)
            return Future() { promise in
                URLSession.shared
                    .dataTaskPublisher(for: req)
                    .map(\.data)
                    .map { a in
//                        let gr = try! JSONSerialization.jsonObject(with: a, options: [])
                        return a
                    }
                    .decode(type: LoginResponseModel.self, decoder: decoder)
                    .sink(receiveCompletion: { _ in}) { response in
                        promise(.success(response))
                    }
                    .store(in: &storage)
            }
        } catch {
            return Future() { $0(.failure(error)) }
        }
    }

    /// Pass the encrypted old and new password
    static func changePassword(username: String, accessToken: String, old: String, new: String) -> Future<Bool, Error> {
        do {
            let req = try URLRequestBuilder.changePassword(userName: username, encryptedOld: old, encryptedNew: new, accessToken: accessToken)
            return Future() { promise in
                URLSession.shared
                    .dataTaskPublisher(for: req)
                    .map(\.data)
                    .decode(type: LoginResponseModel.self, decoder: decoder)
                    .sink(receiveCompletion: { _ in}) { response in
                        promise(.success(true))
                    }
                    .store(in: &storage)
            }
        } catch {
            return Future() { $0(.failure(error)) }
        }
    }

//    static func reSendOTP(twoFAToken: String) -> Future<GenericResponseModel<[String: String]>, Error> {
//        precondition(username != nil)
//        do {
//            let req = try URLRequestBuilder.sendOTP(userName: username!, twoFAToken: twoFAToken)
//            return fetchGenericResponse(req: req)
//        } catch {
//            return Future() { $0(.failure(error)) }
//        }
//    }

    static func verifyOTP(username: String, otp: String, twoFAToken: String) -> Future<LoginResponseModel, Error> {
        let req = try! URLRequestBuilder.verifyOTP(otp: otp, userName: username, twoFAToken: twoFAToken)
        return Future() { promise in
            URLSession.shared
                .dataTaskPublisher(for: req)
                .map { $0.data }
                .decode(type: LoginResponseModel.self, decoder: decoder)
                .sink(receiveCompletion: {_ in}) { response in
                    promise(.success(response))
                }
                .store(in: &storage)
        }
    }
}
