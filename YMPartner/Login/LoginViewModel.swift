//
//  LoginViewModel.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 29/06/21.
//

import Foundation
import Combine
import YMSupport

class LoginViewModel {
    enum ResponseType {
        case error(Error)
        case twoFA(token: String)
        case success
    }

    var email = "", password = ""

    private var encryptor = Encryption(key: "wAT8E63Q/bKRkmpfkSH2Gg==")
    private var storage = Set<AnyCancellable>()

    var loginResponse = PassthroughSubject<ResponseType, Never>()

    func login() {
        precondition(email.isNotEmpty && password.isNotEmpty)
        do {
            let encryptedPassword = try self.encryptor.encrypt(self.password)
            Network.login(username: self.email, encryptedPassword: encryptedPassword)
                .clubIntoResult()
                .sink { result in
                    switch result {
                    case .failure(let error):
                        self.loginResponse.send(.error(error))
                    case .success(let response):
                        if let token = response.twoFactorToken, let userName = response.username {
                            defaults.username = userName
                            self.loginResponse.send(.twoFA(token: token))
                        } else if let error = response.error {
                            self.loginResponse.send(.error(error))
                        } else if response.success == false {
                            self.loginResponse.send(.error("Error occurred while login"))
                        } else if let accessToken = response.accessToken, let userName = response.username {
                            defaults.username = userName
                            defaults.accessToken = accessToken

                            YMSupport.username = userName
                            YMSupport.accessToken = accessToken

                            self.loginResponse.send(.success)
                        } else {
                            self.loginResponse.send(.error("Error occurred while login."))
                        }
                    }
                }
                .store(in: &storage)
        } catch {

        }
    }
}
