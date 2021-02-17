//
//  TopViewModel.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit
import Combine

enum Section: Int, CaseIterable {
  case top
}

class TopViewModel: NSObject {
    
    let service = ServiceHelper(withBaseURL: "https://api.jikan.moe/v3")
    
    fileprivate let imageLoader = ImageLoader()
    
    var respone: Observable<Response?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    var error: Observable<Error?> = Observable(nil)
    var favoritesAnime:  Observable<Set<Top>> = Observable(Set<Top>())
    var favoritesManga:  Observable<Set<Top>> = Observable(Set<Top>())
    
    var favoritesPeople:  Observable<Set<Top>> = Observable(Set<Top>())
    var favoritesCharaters:  Observable<Set<Top>> = Observable(Set<Top>())
    
    var filterRespone: Observable<[Top]> = Observable([])
    
    var isSearching: Observable<Bool> = Observable(false)
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var coordinator :TopListCoordinator?
    
    var currentPage = 1
    
    let items = ["Anime", "Manga"]
    lazy var segmentedControl = UISegmentedControl(items: items)
    lazy var customizeSearchView = CustomizeSearchView(viewModel: self)
    weak var topTableView: UITableView!
    
    var typeViewHeightConstraint: NSLayoutConstraint!
    var topTableViewConstraint: NSLayoutConstraint!
    
    func createSegmentView(view : UIView) {
        segmentedControl.frame = CGRect.zero
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
            switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                fetchTopListAnime()
                break // Anime
            case 1:
                fetchTopListManga()
                break // Manga
            default:
                break
            }
        }

    func fetchTopListAnime() {
        
        self.isLoading.value = true
        
        self.service.getFeed(fromRoute: Routes.airing, parameters: nil) { [weak self] (result) in
            
            self?.isLoading.value = false
            
            switch result {
                case .success(let feedResult):
                
                self?.respone.value = feedResult

                case .failure(let error):
                    self?.setError(error)
            }
        }
    }
    
    func fetchTopListManga() {
        
        self.isLoading.value = true
        
        self.service.getFeed(fromRoute: Routes.manga, parameters: nil) { [weak self] (result) in
            
            self?.isLoading.value = false
            
            switch result {
                case .success(let feedResult):
                
                self?.respone.value = feedResult

                case .failure(let error):
                    self?.setError(error)
            }
        }
    }
    
    func fetchDataByType(type: String, subType: String) {
        self.isLoading.value = true
        
        self.service.getFeedWithType(type: type, subType: subType, page: "1", parameters: nil) { [weak self] (result) in
            
            self?.isLoading.value = false
            
            switch result {
                case .success(let feedResult):
                
                self?.respone.value = feedResult

                case .failure(let error):
                    self?.setError(error)
            }
        }
    }
    
    func fetchDataWithoutType(type: String, subType: String) {
        self.isLoading.value = true
        
        self.service.getFeedWithoutType(type: type, subType: subType, page: "1", parameters: nil) { [weak self] (result) in
            
            self?.isLoading.value = false
            
            switch result {
                case .success(let feedResult):
                
                self?.respone.value = feedResult

                case .failure(let error):
                    self?.setError(error)
            }
        }
    }
    
    func loadMoreData() {
        
        //self?.isLoading.value = true
        
        if customizeSearchView.currentType == "people" || customizeSearchView.currentType == "charaters" {
            self.service.nextPageWithoutType(type: customizeSearchView.currentType, subType: "", page: "\(currentPage)", parameters: nil) { [weak self] (result) in
                self?.isLoading.value = false
                
                switch result {
                    case .success(let feedResult):
                      
                        guard var new = self?.respone.value  else {
                            return
                        }
                        
                        new.request_hash = feedResult.request_hash
                        new.request_cached = feedResult.request_cached
                        new.request_cache_expiry = feedResult.request_cache_expiry
                        new.top.append(contentsOf: feedResult.top)
                        
                    
                    self?.respone.value = new

                    case .failure(let error):
                        self?.setError(error)
                }
            }
        } else {
            self.service.nextPage(type: customizeSearchView.currentType, subType: customizeSearchView.currentSubType, page: "\(currentPage)", parameters: nil) { [weak self] (result) in
                self?.isLoading.value = false
                
                switch result {
                    case .success(let feedResult):
                      
                        guard var new = self?.respone.value  else {
                            return
                        }
                        
                        new.request_hash = feedResult.request_hash
                        new.request_cached = feedResult.request_cached
                        new.request_cache_expiry = feedResult.request_cache_expiry
                        new.top.append(contentsOf: feedResult.top)
                        
                    
                    self?.respone.value = new

                    case .failure(let error):
                        self?.setError(error)
                }
            }
        }
       
        
    }
    
    func checkCacheExpiry(respone: Response) -> Bool {
        
        if saveDateAlreadyExist(kUsernameKey: "SaveDate") {
           
            // convert Int to TimeInterval (typealias for Double)
            let timeInterval = TimeInterval(respone.request_cache_expiry)

            // create NSDate from Double (NSTimeInterval)
            let expireDate = Date(timeIntervalSince1970: timeInterval)
            
            let calendar = Calendar.current
            return calendar.isDateInToday(expireDate)
            
        } else {
            saveDate()
            
            return false
        }
    }
    
    func saveDate() {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        UserDefaults.standard.set(timeInterval, forKey: "SaveDate")
        UserDefaults.standard.synchronize()
    }
    
    func saveRespone(respone: Response) {
        UserDefaults.standard.set(respone, forKey: "Respone")
        UserDefaults.standard.synchronize()
    }
    
    func saveDateAlreadyExist(kUsernameKey: String) -> Bool {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
    func setError(_ error: Error) {
        self.errorMessage = Observable(error.localizedDescription)
        self.error = Observable(error)
    }
    
    func loadFavorieData() {
        let userDefaults = UserDefaults.standard
        if UserDefaults.standard.object(forKey: "favoritesAnime") != nil {
            
            do {
                self.favoritesAnime.value = try userDefaults.getObject(forKey: "favoritesAnime", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
        }
        
        if UserDefaults.standard.object(forKey: "favoritesManga") != nil {
            
            do {
                self.favoritesManga.value = try userDefaults.getObject(forKey: "favoritesManga", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
        }
        
        if UserDefaults.standard.object(forKey: "favoritesPeople") != nil {
            
            do {
                self.favoritesPeople.value = try userDefaults.getObject(forKey: "favoritesPeople", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
        }
        
        if UserDefaults.standard.object(forKey: "favoritesCharaters") != nil {
            
            do {
                self.favoritesCharaters.value = try userDefaults.getObject(forKey: "favoritesCharaters", castTo: Set<Top>.self)
            } catch  {
                print(error)
            }
        }
    }
}

// MARK:- UITableViewDelegate methods
extension TopViewModel: UITableViewDataSource {
    
    func configureTableView(tableView: UITableView, Add to: UIView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        to.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: to.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: to.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: to.safeAreaLayoutGuide.bottomAnchor),
        ])
        //topTableViewConstraint.constant = 270
        topTableViewConstraint = tableView.topAnchor.constraint(equalTo: to.safeAreaLayoutGuide.topAnchor, constant: 270)
        topTableViewConstraint.isActive = true
        
        customizeSearchView = CustomizeSearchView(viewModel: self)
        customizeSearchView.translatesAutoresizingMaskIntoConstraints = false
        //customizeSearchView.isHidden = true
    
        to.addSubview(customizeSearchView)
        
        let guide = to.safeAreaLayoutGuide
       
        NSLayoutConstraint.activate([
            customizeSearchView.topAnchor.constraint(equalTo: guide.topAnchor),
            customizeSearchView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            customizeSearchView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
        
        typeViewHeightConstraint = customizeSearchView.heightAnchor.constraint(equalToConstant: 270)
        typeViewHeightConstraint.isActive = true
    }
    
    func makeDateSourceForTableView(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellForRowAt(tableView: tableView, indexPath: indexPath, identifier: TopTableViewCell.reuseIdentifier)
        cell.selectionStyle = .none
        return cell as! TopTableViewCell
    }
    
    private func cellForRowAt(tableView: UITableView, indexPath:IndexPath, identifier: String) -> UITableViewCell   {
        
        guard let topItem = respone.value else { return UITableViewCell() }
        
        guard let cell = self.configureCell(tableView: tableView, items: topItem, indexPath: indexPath) else { return UITableViewCell() }
        
         return cell
    }
    
    private func numberOfItems(numberOfRowsInSection section: Int) -> Int {
        return self.isSearching.value ? filterRespone.value.count : respone.value?.top.count ?? 0
    }
    
    private func configureCell(tableView: UITableView, items: Response, indexPath: IndexPath) -> UITableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopTableViewCell.reuseIdentifier, for: indexPath) as? TopTableViewCell
        
        let top = self.isSearching.value ? filterRespone.value[indexPath.row] : items.top[indexPath.row]
        
        cell?.titleLabel.text = top.title
        let rank = top.rank
        cell?.rankLabel.text = "\(rank)"
        cell?.typeLabel.text = top.type
        
        if let start = top.start_date, let end = top.end_date  {
            cell?.startLabel.text = "start \(start)"
            cell?.endLabel.text = "end \(end)"
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
    
    func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }
}

extension TopViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let top = self.respone.value?.top else {
            return
        }
        
        let lastElement = top.count - 1
        if !isLoading.value && indexPath.row == lastElement {
           // indicator.startAnimating()
            isLoading.value = true
            currentPage =  currentPage + 1
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            
            loadMoreData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let topItems = respone.value else { return }
        
        let topItem = self.isSearching.value ? filterRespone.value[indexPath.row] : topItems.top[indexPath.row]
        
        //let topItem = topItems.top[indexPath.row]
        
        coordinator?.goToDetailView(top: topItem, item: topItems, type: customizeSearchView.currentType)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let notFavoriteAction = UIContextualAction(style: .normal, title: "unFavorite") { (action, view, completionHandler) in
                
            let item = self.respone.value
            
            if self.customizeSearchView.currentType == "anime" {
                if let top = item?.top[indexPath.row] {
                    self.favoritesAnime.value.remove(top)
                }
            } else if self.customizeSearchView.currentType == "manga" {
                if let top = item?.top[indexPath.row] {
                    self.favoritesManga.value.remove(top)
                }
            } else if self.customizeSearchView.currentType == "people" {
                if let top = item?.top[indexPath.row] {
                    self.favoritesPeople.value.remove(top)
                }
            } else {
                if let top = item?.top[indexPath.row] {
                    self.favoritesCharaters.value.remove(top)
                }
            }

            self.saveToFavorite()

            completionHandler(false)
        }
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completionHandler) in
                
            let item = self.respone.value
            
                if self.customizeSearchView.currentType == "anime" {
                    if let top = item?.top[indexPath.row] {
                        self.favoritesAnime.value.insert(top)
                    }
                } else if self.customizeSearchView.currentType == "manga" {
                    if let top = item?.top[indexPath.row] {
                        self.favoritesManga.value.insert(top)
                    }
                } else if self.customizeSearchView.currentType == "people" {
                    if let top = item?.top[indexPath.row] {
                        self.favoritesPeople.value.insert(top)
                    }
                } else {
                    if let top = item?.top[indexPath.row] {
                        self.favoritesCharaters.value.insert(top)
                    }
                }
  
            }

            notFavoriteAction.backgroundColor = .red
            favoriteAction.backgroundColor = .gray

            return UISwipeActionsConfiguration(actions: [notFavoriteAction, favoriteAction])
       }
    
    func saveToFavorite() {
        do {
            //try UserDefaults.standard.setObject(self.segmentedControl.selectedSegmentIndex == 0 ? self.favoritesAnime.value : self.favoritesManga.value, forKey: self.segmentedControl.selectedSegmentIndex == 0 ? "favoritesAnime": "favoritesManga")
            
            if self.customizeSearchView.currentType == "anime" {
                
                try UserDefaults.standard.setObject(self.favoritesAnime.value, forKey: "favoritesAnime")
                
            } else if self.customizeSearchView.currentType == "manga" {
                
                try UserDefaults.standard.setObject(self.favoritesManga.value, forKey: "favoritesManga")
                
            } else if self.customizeSearchView.currentType == "people" {
                
                try UserDefaults.standard.setObject(self.favoritesPeople.value, forKey: "favoritesPeople")
                
            } else {
                try UserDefaults.standard.setObject(self.favoritesCharaters.value, forKey: "favoritesCharaters")
            }
            
            UserDefaults.standard.synchronize()
        } catch  {
            print(error)
        }
    }
}

extension TopViewModel {
    func createSearchViewController(navItem: UINavigationItem) {
        let searchController = SearchViewController(viewModel: self)
        
        if #available(iOS 11.0, *) {
            
            navItem.searchController = searchController
            searchController.hidesNavigationBarDuringPresentation = false
        } else {
            //candyTableView.tableHeaderView = searchController.searchBar
        }
        
        //candyTableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    func createBarItem(navItem: UINavigationItem, rootView: UIView) {
        let search = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        search.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        //backButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        search.addTarget(self, action: #selector(showSearchView), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: search)
        
        
    }
    
    @objc func showSearchView() {
        customizeSearchView.isHidden = !customizeSearchView.isHidden
        
      
    }
}
