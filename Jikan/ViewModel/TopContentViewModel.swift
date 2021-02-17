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
    
    var currentType:String = ""
    
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
        }
        
        if UserDefaults.standard.object(forKey: "favoritesManga") != nil {
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
        
        if UserDefaults.standard.object(forKey: "favoritesPeople") != nil {
            do {
                self.topViewModel.favoritesPeople.value = try userDefaults.getObject(forKey: "favoritesPeople", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
            
            if (self.topViewModel.favoritesPeople.value.contains(top)) {
                let backButton = navItem.rightBarButtonItem?.customView as! UIButton
                backButton.isSelected = true
                navItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
            }
        }
        
        if UserDefaults.standard.object(forKey: "favoritesCharaters") != nil {
            do {
                self.topViewModel.favoritesCharaters.value = try userDefaults.getObject(forKey: "favoritesCharaters", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
            
            if (self.topViewModel.favoritesCharaters.value.contains(top)) {
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
        
        if currentType == "anime" {
            if isFavorite {
                self.topViewModel.favoritesAnime.value.insert(top)
            } else {
                self.topViewModel.favoritesManga.value.remove(top)
            }
            
            saveToFavorite()
            
        } else if currentType == "manga" {
            
            if isFavorite {
                self.topViewModel.favoritesManga.value.insert(top)
            } else {
                self.topViewModel.favoritesManga.value.remove(top)
                
            }
            saveToFavorite()
        } else if currentType == "people" {
            
            if isFavorite {
                self.topViewModel.favoritesPeople.value.insert(top)
            } else {
                self.topViewModel.favoritesPeople.value.remove(top)
                
            }
            saveToFavorite()
        }
        else if currentType == "charaters" {
            
            if isFavorite {
                self.topViewModel.favoritesCharaters.value.insert(top)
            } else {
                self.topViewModel.favoritesCharaters.value.remove(top)
                
            }
            saveToFavorite()
        }
    }
    
    func saveToFavorite() {
        do {
            //try UserDefaults.standard.setObject(isAnime ? self.topViewModel.favoritesAnime.value : self.topViewModel.favoritesManga.value, forKey: isAnime ? "favoritesAnime": "favoritesManga")
            
            if currentType == "anime" {
                try UserDefaults.standard.setObject(self.topViewModel.favoritesAnime.value, forKey: "favoritesAnime")
            } else if currentType == "manga" {
                try UserDefaults.standard.setObject(self.topViewModel.favoritesManga.value, forKey: "favoritesManga")
            } else if currentType == "people" {
                try UserDefaults.standard.setObject(self.topViewModel.favoritesPeople.value, forKey: "favoritesPeople")
            } else if currentType == "charaters" {
                try UserDefaults.standard.setObject(self.topViewModel.favoritesCharaters.value, forKey: "favoritesCharaters")
            }
            
            UserDefaults.standard.synchronize()
        } catch  {
            print(error)
        }
    }
}
