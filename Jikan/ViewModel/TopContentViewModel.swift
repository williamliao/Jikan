//
//  TopContentViewModel.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit
import WebKit

class TopContentViewModel: NSObject {
    
    var webView: WKWebView!
    
    var navItem: UINavigationItem!
    
    var isFavorite: Bool = false
    
    var topViewModel: TopViewModel!
    
    var item: Response!
    var top: Top!
    
    init(webView: WKWebView, topViewModel: TopViewModel) {
        self.webView = webView
        self.topViewModel = topViewModel
        super.init()
    }

}

extension TopContentViewModel {
    
    func setupWebView() {
        
    }
    
    func configureConstraints(contentView:UIView) {
        
        contentView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: guide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
    
    func openURL(url: URL) {
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func createBarItem() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        backButton.setImage(UIImage(systemName: "heart"), for: .normal)
        backButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        backButton.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
    }
    
    func loadFavorite() {
        let userDefaults = UserDefaults.standard
        if UserDefaults.standard.object(forKey: "favorite") != nil {
            
            do {
                self.topViewModel.favorites.value = try userDefaults.getObject(forKey: "favorite", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
            
            if (self.topViewModel.favorites.value.contains(top)) {
                let backButton = navItem.rightBarButtonItem?.customView as! UIButton
                backButton.isSelected = true
                navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
            }
        }
    }
    
    @objc func favoriteAction() {
        isFavorite = !isFavorite
        let backButton = navItem.rightBarButtonItem?.customView as! UIButton
        backButton.isSelected = isFavorite
        navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if isFavorite {
            self.topViewModel.favorites.value.insert(top)
        } else {
            self.topViewModel.favorites.value.remove(top)
        }
        
        do {
            try UserDefaults.standard.setObject(self.topViewModel.favorites.value, forKey: "favorite")
            UserDefaults.standard.synchronize()
        } catch  {
            print(error)
        }
    }
}
