//
//  TopListCoordinator.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit
import WebKit

class TopListCoordinator: Coordinator {

    // MARK: - Properties
    let rootViewController: UITabBarController
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    lazy var topViewModel: TopViewModel! = {
        let viewModel = TopViewModel()
           return viewModel
    }()
    
    lazy var favoriteViewModel: FavoriteViewModel! = {
        let tableView = UITableView()
        let viewdModel = FavoriteViewModel(viewModel: topViewModel, tableView: tableView)
           return viewdModel
    }()
    
    // MARK: - Coordinator
    init(rootViewController: UITabBarController) {
        self.rootViewController = rootViewController
    }
    
    override func start() {
        let top = createTopView()
        let favorite = createFavoriteView()
        self.rootViewController.setViewControllers([top, favorite], animated: false)
        
        if #available(iOS 13.0, *) {
            self.rootViewController.tabBar.items?[0].image = UIImage(systemName: "square")?.withRenderingMode(.alwaysOriginal)
            self.rootViewController.tabBar.items?[0].selectedImage = UIImage(systemName: "square.fill")?.withRenderingMode(.alwaysOriginal)
     
            self.rootViewController.tabBar.items?[1].image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
            self.rootViewController.tabBar.items?[1].selectedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func finish() {
        
    }
    
    func createTopView() -> UINavigationController {
        let topListVC = TopViewController.instantiate()
        topListVC.title = "Top"
        topListVC.coordinator = self
        topListVC.viewModel = topViewModel
        let nav = UINavigationController(rootViewController: topListVC)
        return nav
    }
    
    func createFavoriteView() -> UINavigationController {
        let favoriteVC = FavoriteViewController.instantiate()
        favoriteVC.viewModel = topViewModel
        favoriteVC.favoriteViewModel = favoriteViewModel
        favoriteVC.title = "Favorite"
        let nav = UINavigationController(rootViewController: favoriteVC)
        return nav
    }
}

extension TopListCoordinator {
    func goToDetailView(top: Top, item: Response, type: String) {
        let webView = WKWebView()
        let topDetailVC = TopContentViewController.instantiate()
        //topDetailVC.coordinator = self
        topDetailVC.item = item
        topDetailVC.top = top
      
        if let currentNavController = self.rootViewController.selectedViewController as? UINavigationController {
            
            let viewModel = TopContentViewModel(webView: webView, topViewModel: topViewModel)
            //viewModel.isAnime = section == 0 ? true : false
            viewModel.currentType = type
            topDetailVC.viewModel = viewModel
            
            currentNavController.pushViewController(topDetailVC, animated: true)
        }
    }
}
