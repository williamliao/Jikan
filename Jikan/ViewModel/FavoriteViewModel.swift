//
//  FavoriteViewModel.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit

enum FavoriteSection: Int, CaseIterable {
  case anime
  case manga
}

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
        
        viewModel.favoritesAnime.bind { [weak self] (_) in
                    
            self?.tableView.reloadData()
        }
        
        viewModel.favoritesManga.bind { [weak self] (_) in
                    
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FavoriteSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.favoritesAnime.value.count : viewModel.favoritesManga.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForRowAt(tableView: tableView, indexPath: indexPath, identifier: TopTableViewCell.reuseIdentifier)
        cell.selectionStyle = .none
        return cell as! TopTableViewCell
    }
    
    private func cellForRowAt(tableView: UITableView, indexPath:IndexPath, identifier: String) -> UITableViewCell   {
        
      //  let topItem = viewModel.favorites.value.
        
        switch indexPath.section {
            case 0:
                let top = Array(viewModel.favoritesAnime.value)[indexPath.row]
                
                guard let cell = self.configureCell(tableView: tableView, top: top, indexPath: indexPath) else { return UITableViewCell() }
                return cell
                
            case 1:
                let top = Array(viewModel.favoritesManga.value)[indexPath.row]
                
                guard let cell = self.configureCell(tableView: tableView, top: top, indexPath: indexPath) else { return UITableViewCell() }
                return cell
        default:
            return TopTableViewCell()
        }
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = titleForHeaderInSection(titleForHeaderInSection: section)
        return title
    }
    
    
    private func titleForHeaderInSection(titleForHeaderInSection section: Int) -> String? {
        guard let sectionTitle = FavoriteSection(rawValue: section) else {
          return nil
        }
        
        switch sectionTitle {
         // 2
         case .anime:
            return "Anime"
         // 3
         case .manga:
            return "Manga"
         }
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
            
            
            if indexPath.section == FavoriteSection.anime.rawValue {
                let top = Array(self.viewModel.favoritesAnime.value)[indexPath.row]
                
                self.viewModel.favoritesAnime.value.remove(top)

                action.image = UIImage(systemName: "heart")
                action.image?.withTintColor(.systemGreen)
                action.backgroundColor = .systemOrange
                
                do {
                    try UserDefaults.standard.setObject(self.viewModel.favoritesAnime.value, forKey: "favoritesAnime")
                    UserDefaults.standard.synchronize()
                } catch  {
                    print(error)
                }
                
                completion(true)
            } else {
                let top = Array(self.viewModel.favoritesManga.value)[indexPath.row]
                
                self.viewModel.favoritesManga.value.remove(top)
                
                do {
                    try UserDefaults.standard.setObject(self.viewModel.favoritesManga.value, forKey: "favoritesManga")
                    UserDefaults.standard.synchronize()
                } catch  {
                    print(error)
                }
            }
        }
    }
}
