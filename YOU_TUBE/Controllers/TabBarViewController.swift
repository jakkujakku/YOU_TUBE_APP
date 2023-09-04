//
//  TabBarViewController.swift
//  YOU_TUBE
//
//  Created by (^ㅗ^)7 iMac on 2023/09/04.
//

import UIKit

final class TabBarViewController: UITabBarController {
    let paddingTop: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbarController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame = .init(
            x: tabBar.frame.origin.x,
            y: tabBar.frame.origin.y - paddingTop,
            width: tabBar.frame.width,
            height: tabBar.frame.height + paddingTop
        )
    }

    func configureTabbarController() {
        let thumbnailVC = ThumbnailController()
        let profileVC = ProfileController()

        thumbnailVC.title = "Main"
        profileVC.title = "Profile"

        thumbnailVC.tabBarItem.image = UIImage(systemName: "house")
        profileVC.tabBarItem.image = UIImage(systemName: "person")

        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground

        setViewControllers([thumbnailVC, profileVC], animated: false)
    }
}
