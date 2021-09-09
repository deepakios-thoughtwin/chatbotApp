//
//  Defaults.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 22/04/21.
//

import Foundation
extension UserDefaults {
    func registerDefaults() {
//        register(defaults: ["translucent": false, "floatingWindow": true, "defaultNoteColor": "random"])
    }

    @objc var selectedBotName: String? {
        get { string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    @objc var accessToken: String? {
        get { string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    @objc var username: String? {
        get { string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    @objc var selectedBotId: String? {
        get { string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}
