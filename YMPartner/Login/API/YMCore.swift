//
//  YMLogin.swift
//  YMSupport
//
//  Created by Kauntey Suryawanshi on 15/04/21.
//

import Foundation
import CommonCrypto
import Combine

public enum LoginResponseType {
    case success, error(String), twoFA(token: String)
}

public class YMCore {
    public static var shared: YMCore = YMCore()

    private var storage = Set<AnyCancellable>()

    public var isLoggednIn: Bool { YMData.accessToken != nil }

    private var encryptor = Encryption(key: "wAT8E63Q/bKRkmpfkSH2Gg==")

    public var botId: String? {
        get { YMData.botId }
        set { YMData.botId = newValue }
    }

    public func logout() {
        YMData.botId = nil
        YMData.accessToken = nil
        YMData.username = nil
    }
    
    public func login(username: String, password: String, completion: @escaping (LoginResponseType) -> Void) {
        guard let encryptedPassword = try? encryptor.encrypt(password) else {
            return
        }

        YMData.login(username: username, encryptedPassword: encryptedPassword)
            .clubIntoResult()
            .sink { result in
                switch result {
                case .failure(let error): completion(.error(error.localizedDescription ))
                case .success(let response):
                    if let token = response.twoFactorToken, let userName = response.username {
                        YMData.username = userName
                        completion(.twoFA(token: token))
                    } else if let error = response.error {
                        completion(.error(error))
                    } else if response.success == false {
                        completion(.error(response.message ?? "Error occurred while login"))
                    } else if let accessToken = response.accessToken, let userName = response.username {
                        YMData.accessToken = accessToken
                        YMData.username = userName
                        YMData.loginResponse = response
                        completion(.success)
                        return
                    } else {
                        completion(.error("Error occurred while login"))
                    }
                }
            }
            .store(in: &storage)
    }

    public func verifyOTP(otp: String, twoFAToken: String, completion: @escaping (LoginResponseType) -> Void) {
        YMData.verifyOTP(otp: otp, twoFAToken: twoFAToken)
            .clubIntoResult()
            .sink { result in
                switch result {
                case .failure(let error): completion(.error(error.localizedDescription ))
                case .success(let response):
                    if let token = response.twoFactorToken {
                        completion(.twoFA(token: token))
                    } else if let error = response.error {
                        completion(.error(error))
                    } else if response.success == false {
                        completion(.error(response.message ?? "Error occurred while verifying OTP"))
                    } else if let accessToken = response.accessToken, let userName = response.username {
                        YMData.accessToken = accessToken
                        YMData.username = userName
                        YMData.loginResponse = response
                        completion(.success)
                        return
                    } else {
                        completion(.error("Error occurred while verifying OTP"))
                    }
                }
            }
            .store(in: &storage)
    }

    public func changePassword(from old: String, to new: String, completion: @escaping (Result<Void?,Error>) -> Void) {
        //        guard let encryptedOldPassword = try? encryptor.encrypt(old),
        //              let encryptedNewPassword = try? encryptor.encrypt(new)
        //        else {
        //            completion(.failure("Encryption failed"))
        //            return
        //        }
        //
        //        guard let authToken = authToken, let username = username else {
        //            completion(.failure("User info not present"))
        //            return
        //        }
        //        let req = URLRequestBuilder.changePassword(userName: username, encryptedOld: encryptedOldPassword, encryptedNew: encryptedNewPassword, authToken: authToken)
        //
        //        URLSession.shared
        //            .dataTaskPublisher(for: req)
        //            .map { $0.data }
        //            .receive(on: DispatchQueue.main)
        //            .sink(receiveCompletion: { _ in }) { data in
        //                let responseJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        //                completion(.success(nil))
        //            }.store(in: &storage)
    }
}
