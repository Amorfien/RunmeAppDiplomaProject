//
//  AppTabBarController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class AppTabBarController: UITabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.tabBar.unselectedItemTintColor = .systemGray3
        self.tabBar.backgroundColor = .systemBackground
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
