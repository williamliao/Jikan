//
//  TopViewController.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, Storyboarded {
    
    var topTableView: UITableView!
    var viewModel: TopViewModel!
    
    var coordinator :TopListCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    func render() {
        topTableView = UITableView()
        //viewModel = TopViewModel()
      
        viewModel.configureTableView(tableView: topTableView, Add: view)
        viewModel.makeDateSourceForTableView(tableView: topTableView)
        viewModel.coordinator = coordinator
        
        viewModel.respone.bind { [weak self] (_) in
            self?.topTableView.reloadData()
        }
        
        viewModel.error.bind { (error) in
            guard let error = error else {
                return
            }
            
            print("error = \(error.localizedDescription)")
        }
        
        viewModel.createSegmentView(view: view)
        viewModel.fetchTopListAnime()
        viewModel.loadFavorieData()
        
        topTableView.register(TopTableViewCell.self,
            forCellReuseIdentifier: TopTableViewCell.reuseIdentifier
        )
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
