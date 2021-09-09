//
//  OrangeButton.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 14/04/21.
//

import UIKit

class OrangeButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = UIColor(red: 250 / 255, green: 101 / 255, blue: 5 / 255, alpha: 1)
        layer.cornerRadius = 10
    }
}
