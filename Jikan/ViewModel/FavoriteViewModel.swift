//
//  FavoriteViewModel.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit

class FavoriteViewModel: NSObject {
    
    var coordinator :TopListCoordinator?
    
    var viewModel: TopViewModel!
    
    var tableView: UITableView!
    
    init(viewModel: TopViewModel, tableView:UITableView ) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
    }
}

// MARK:- UITableViewDelegate methods
extension FavoriteViewModel: UITableViewDataSource {
    
    func configureTableView(Add to: UIView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        to.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: to.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: to.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: to.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: to.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func makeDateSourceForTableView() {
        
        tableView.register(TopTableViewCell.self,
            forCellReuseIdentifier: TopTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.favorites.bind { [weak self] (_) in
                    
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForRowAt(tableView: tableView, indexPath: indexPath, identifier: TopTableViewCell.reuseIdentifier)
        cell.selectionStyle = .none
        return cell as! TopTableViewCell
    }
    
    private func cellForRowAt(tableView: UITableView, indexPath:IndexPath, identifier: String) -> UITableViewCell   {
        
      //  let topItem = viewModel.favorites.value.
        
        let top = Array(viewModel.favorites.value)[indexPath.row]
        
        guard let cell = self.configureCell(tableView: tableView, top: top, indexPath: indexPath) else { return UITableViewCell() }
        return cell
    }
   
    private func configureCell(tableView: UITableView, top: Top, indexPath: IndexPath) -> UITableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.reuseIdentifier, for: indexPath) as? TopTableViewCell
        
        cell?.titleLabel.text = top.title
        let rank = top.rank
        cell?.rankLabel.text = "\(rank)"
        cell?.typeLabel.text = top.type
        
        if let start = top.start_date, let end = top.end_date  {
            cell?.startLabel.text = "start \(start)"
            cell?.endLabel.text = "start \(end)"
        }
        
        DispatchQueue.global(qos:.userInteractive).async {
        
            guard let url = URL(string: top.image_url)  else {
                return
            }
            
            DispatchQueue.main.async {
                cell?.configureImage(with: url)
            }
        }
        
        return cell
        
    }
}

extension FavoriteViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            return UISwipeActionsConfiguration(actions: [
                makeUnFavoriteContextualAction(forRowAt: indexPath)
            ])
    }

    private func makeUnFavoriteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "unFavorite") { (action, swipeButtonView, completion) in
            
            let top = Array(self.viewModel.favorites.value)[indexPath.row]
            
            self.viewModel.favorites.value.remove(top)

            action.image = UIImage(systemName: "heart")
            action.image?.withTintColor(.systemGreen)
            action.backgroundColor = .systemOrange
            completion(true)
            
        }
    }
}
