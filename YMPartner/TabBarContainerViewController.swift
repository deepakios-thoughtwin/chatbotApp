//
//  YMTabContainerViewController.swift
//  YMPartner
//
//  Created by Kauntey Suryawanshi on 12/04/21.
//

import UIKit
import YMSupport

class TabBarContainerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addSDKViews()
    }

    func addSDKViews() {
        let overviewVC = YMSupport.makeOverviewViewController()
        overviewVC.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(named: "overview"), selectedImage: UIImage(named: "overview.fill"))
        viewControllers?.insert(overviewVC, at: 0)

        let chatsVC = YMSupport.makeMyChatsViewController()
        chatsVC.tabBarItem = UITabBarItem(title: "My Chats", image: UIImage(named: "chat")!, selectedImage: UIImage(named: "chat.fill")!)
        viewControllers!.insert(chatsVC, at: 1)
        chatsVC.tabBarController?.selectedIndex = 1
    }
}
