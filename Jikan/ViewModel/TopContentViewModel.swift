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
    
    var isAnime:Bool = true
    
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
        if UserDefaults.standard.object(forKey: "favoritesAnime") != nil {
            
            if isAnime  {
                do {
                    self.topViewModel.favoritesAnime.value = try userDefaults.getObject(forKey: "favoritesAnime", castTo: Set<Top>.self)
                } catch  {
                    print(error)
                }
                
                if (self.topViewModel.favoritesAnime.value.contains(top)) {
                    let backButton = navItem.rightBarButtonItem?.customView as! UIButton
                    backButton.isSelected = true
                    navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
                }
            } else if UserDefaults.standard.object(forKey: "favoritesManga") != nil {
                do {
                    self.topViewModel.favoritesManga.value = try userDefaults.getObject(forKey: "favoritesManga", castTo: Set<Top>.self)
                } catch  {
                    print(error)
                }
                
                if (self.topViewModel.favoritesManga.value.contains(top)) {
                    let backButton = navItem.rightBarButtonItem?.customView as! UIButton
                    backButton.isSelected = true
                    navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
                }
            }
            
        }
    }
    
    @objc func favoriteAction() {
        isFavorite = !isFavorite
        let backButton = navItem.rightBarButtonItem?.customView as! UIButton
        backButton.isSelected = isFavorite
        navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
        if isAnime {
            if isFavorite {
                self.topViewModel.favoritesAnime.value.insert(top)
            } else {
                self.topViewModel.favoritesManga.value.remove(top)
            }
            
            saveToFavorite()
            
        } else {
            
            if isFavorite {
                self.topViewModel.favoritesManga.value.insert(top)
            } else {
                self.topViewModel.favoritesManga.value.remove(top)
                
            }
            saveToFavorite()
        }
    }
    
    func saveToFavorite() {
        do {
            try UserDefaults.standard.setObject(isAnime ? self.topViewModel.favoritesAnime.value : self.topViewModel.favoritesManga.value, forKey: isAnime ? "favoritesAnime": "favoritesManga")
            UserDefaults.standard.synchronize()
        } catch  {
            print(error)
        }
    }
}
