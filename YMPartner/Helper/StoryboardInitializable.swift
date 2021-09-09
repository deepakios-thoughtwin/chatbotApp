//
//  StoryboardInitializable.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 23/04/21.
//

import UIKit

protocol StoryboardInitializable: UIViewController {
    static var storyboardName: String { get }

    /// If storyboarIdentifier is not defined then initial view controller is initialised
    static var storyboardIdentifier: String { get }
    static func makeFromStoryboard() -> Self
}

extension StoryboardInitializable {
    static var storyboardIdentifier: String { String(describing: self) }

    static func makeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
