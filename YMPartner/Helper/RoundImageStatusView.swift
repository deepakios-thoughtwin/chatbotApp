//
//  RoundImageView.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 12/04/21.
//

import UIKit

class RoundImageView: UIImageView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        layer.cornerRadius = self.bounds.width / 2
        layer.masksToBounds = true
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = bounds.width / 2.0
    }
}

class RoundImageStatusView: UIView {
    var status = AvailabilityStatus.available {
        didSet {
            statusIndicatorView.backgroundColor = status.color
        }
    }

    let imageView = UIImageView(image: #imageLiteral(resourceName: "SELF"))
    let statusIndicatorView = UIView()
    private let statusIndicatorSize: CGFloat = 14

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        imageView.layer.cornerRadius = self.bounds.width / 2
        imageView.layer.masksToBounds = true
        self.addSubview(imageView) { $0.equalViews() }
        imageView.contentMode = .scaleAspectFill
        statusIndicatorView.backgroundColor = .red
        statusIndicatorView.layer.cornerRadius = statusIndicatorSize / 2
        addSubview(statusIndicatorView) { $0.right(-3).bottom(-3).size(statusIndicatorSize) }
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = bounds.width / 2.0
    }
}
