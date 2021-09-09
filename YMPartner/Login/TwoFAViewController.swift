//
//  TwoFAViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 07/05/21.
//

import UIKit
import Combine
import YMSupport

class TwoFAViewController: UIViewController {
    private var storage = Set<AnyCancellable>()
    private var timerObserver: AnyCancellable?

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!

    var viewModel: TwoFAViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.setNavigationBarHidden(false, animated: false)
        self.resendButton.isEnabled = false
        emailLabel.text = viewModel.email
        inputTextField.textPublisher.assign(to: \.otp, on: viewModel).store(in: &storage)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        inputTextField.becomeFirstResponder()
    }

    @IBAction func resendOTPTapped(_ sender: UIButton) {
        //TODO: Call API
        startTimer()
    }

    @IBAction func verifyOTP(_ sender: Any) {
        guard let otp = inputTextField.text, otp.isNotEmpty else { return }
        view.endEditing(true)
        showSpinner()

        viewModel.verifyOTP()
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.hideSpinner()
                switch error {
                case .failure(let error):
                    self.showErrorAlert("\(error)")
                case .finished:
                    self.showBotList()
                }
            } receiveValue: { _ in }
            .store(in: &storage)
    }

    private func startTimer() {
        timerObserver = CountDownTimer(duration: 120)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.resendButton.isEnabled = true
                self.resendButton.setTitle("Resend OTP", for: .normal)
            } receiveValue: { [weak self] val in
                guard let self = self else { return }
                self.resendButton.isEnabled = false
                self.resendButton.titleLabel?.text = "Resend OTP in \(val)"
                self.resendButton.setTitle("Resend OTP in \(val)", for: .disabled)
            }
    }

    private func showBotList() {
        let botVC = BotListViewController.makeFromStoryboard()
        self.navigationController?.pushViewController(botVC, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension TwoFAViewController: StoryboardInitializable {
    static var storyboardName: String { "Login" }
}

class TwoFAViewModel {
    let email, twoFAToken: String
    var otp = ""

    init(email: String, twoFAToken: String) {
        self.email = email
        self.twoFAToken = twoFAToken
    }

    func verifyOTP() -> Future<Void, Error> {
        return Future() { promise in
            guard self.otp.isNotEmpty else {
                promise(.failure("OTP empty"))
                return
            }
//            YMCore.shared.verifyOTP(otp: self.otp, twoFAToken: self.twoFAToken) { response in
//                switch response {
//                case .error(let e):
//                    promise(.failure(e))
//                case .success:
//                    promise(.success(()))
//                case .twoFA(_): break // impossible case
//                }
//            }
        }
    }
}
