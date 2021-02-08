//
//  AppCoordinator.swift
//  HelloCoordinator
//
//  Created by William on 2018/12/25.
//  Copyright © 2018 William. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    // MARK: - Properties
    let window: UIWindow?
    var tabController: UITabBarController
    lazy var rootViewController: UITabBarController = {
        return UITabBarController()
    }()

    // MARK: - Coordinator
    init(tabController: UITabBarController, window: UIWindow?) {
        self.tabController = tabController
        self.window = window
    }
    
    override func start() {
        let coordinator = TopListCoordinator(rootViewController: tabController)
        coordinator.start()
    }
    
    override func finish() {
        
    }
}
