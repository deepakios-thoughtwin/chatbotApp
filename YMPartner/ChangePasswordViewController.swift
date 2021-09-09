//
//  ChangePasswordViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 22/04/21.
//

import UIKit
import Combine
import YMSupport

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTextField: PasswordTextField!
    @IBOutlet weak var newPasswordTextField: PasswordTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    private var storage = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Save button is enabled only when both input fields are non empty
        Publishers.CombineLatest(oldPasswordTextField.textPublisher, newPasswordTextField.textPublisher)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &storage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearPasswordInputField()
        saveButton.isEnabled = false
    }

    private func clearPasswordInputField() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
    }

    @IBAction func saveAction(_ sender: Any) {
        let (old, new) = (oldPasswordTextField.text!, newPasswordTextField.text!)
        showSpinner()
        self.view.endEditing(true) // to dismiss the keyboard
        
    

//        YMCore.shared.changePassword(from: old, to: new) { [weak self] result in
//            guard let self = self else { return }
//            self.hideSpinner()
//            switch result {
//            case .failure(let error):
//                self.showErrorAlert("\(error)")
//            case .success(_):
//                self.showInfoAlert("Password updated successfully")
//                self.clearPasswordInputField()
//            }
//        }
    }
}
