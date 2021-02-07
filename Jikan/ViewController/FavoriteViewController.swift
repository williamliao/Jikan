//
//  FavoriteViewController.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, Storyboarded {
    
    var viewModel: TopViewModel!
   //  var favoriteTableView: UITableView!
    var favoriteViewModel: FavoriteViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        render()
    }
    
    func render() {
   
         favoriteViewModel.configureTableView(Add: view)
         favoriteViewModel.makeDateSourceForTableView()
       
        viewModel.error.bind { (error) in
            guard let error = error else {
                return
            }
            
            print("error = \(error.localizedDescription)")
        }
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
