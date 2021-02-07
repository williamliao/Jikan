//
//  TopContentViewController.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit
import WebKit

class TopContentViewController: UIViewController, Storyboarded {
    
   // var webView: WKWebView!
    
    var viewModel:TopContentViewModel!
    
   // var url: URL!
    
    var item : Response!
    var top: Top!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    func render() {
      //  webView = WKWebView()
      //  viewModel = TopContentViewModel(webView: webView, navItem: self.navigationItem)
        viewModel.configureConstraints(contentView: self.view)
        viewModel.navItem = self.navigationItem
        viewModel.top = top
        viewModel.item = item
        viewModel.createBarItem()
        
        guard let url = URL(string: top.url)  else {
            return
        }
        viewModel.openURL(url: url)
        viewModel.loadFavorite()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
