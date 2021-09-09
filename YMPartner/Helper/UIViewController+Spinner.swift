//
//  SpinnerView.swift
//  YMSupport
//
//  Created by Kauntey Suryawanshi on 21/05/21.
//

import Foundation
import UIKit

/*
 Lets you easily put spinner in any UIViewController with just one line of code.

 Call `showSpinner()` in any view controller and it will show spinner in the center of the screen

 Call `hideSpinner()` in any view controller and it will hide the spinner
 */
extension UIViewController {
    private class ActivitySpinner: UIActivityIndicatorView {}

    /// Show spinner in center of the screen. Call `hideSpinner()` to hide
    func showSpinner() {
        guard
            let frontWindow = UIApplication.shared.windows.first(where: \.isKeyWindow),
            frontWindow.subviews.contains(where: {$0 is ActivitySpinner}) == false
        else { return }

        let activityIndicator = ActivitySpinner(style: .large)
        activityIndicator.center = frontWindow.center
        frontWindow.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    /// Hides spinner that was introduced by `showSpinner()`
    func hideSpinner() {
        UIApplication.shared.windows.first(where: \.isKeyWindow)?
            .subviews
            .first { $0 is ActivitySpinner }?
            .removeFromSuperview()
    }
}
