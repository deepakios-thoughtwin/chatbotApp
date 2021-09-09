//
//  PasswordTextField.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 22/04/21.
//

import UIKit

/// Inbuilt support for password visibilty
class PasswordTextField: UITextField {
    let eyeButton = UIButton()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isSecureTextEntry = true
        addEyeButton()
    }

    private func addEyeButton() {
        eyeButton.setImage(UIImage(named: "eye"), for: .normal)
        eyeButton.setImage(UIImage(named: "eye.slash"), for: .selected)
        eyeButton.setTitle("  ", for: .normal)
        eyeButton.setTitle("  ", for: .selected)
        eyeButton.sizeToFit()
        eyeButton.tintColor = .systemGray2
        rightView = eyeButton
        rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(toggleButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func toggleButtonTapped(_ sender: UIButton) {
        eyeButton.isSelected.toggle()
        isSecureTextEntry.toggle()
    }
}
