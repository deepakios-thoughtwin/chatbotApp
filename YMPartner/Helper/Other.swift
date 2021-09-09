//
//  Other.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 23/04/21.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

extension UIViewController {
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func showInfoAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Publisher {
    /// Puts success and failure streams in `Result`. In some publishers like `Future` both sink methods were required to get sucess and failure values
    /// to avoid that, this operator clubs both the streams in Result type so that you can get both success and failure as success wrapped in `Result`
    func clubIntoResult() -> AnyPublisher<Result<Output, Error>, Never> {
        self
            .map { .success($0) }
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
