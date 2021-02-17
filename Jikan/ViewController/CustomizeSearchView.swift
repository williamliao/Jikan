//
//  CustomizeSearchView.swift
//  CustomizeSearchController
//
//  Created by 雲端開發部-廖彥勛 on 2021/2/9.
//

import UIKit

class CustomizeSearchView: UIView {
    
    let titleArray = SearchItem.ScopeSubTypeAnimeSection.allCases.map({ $0.rawValue })
    
    var hasSubtype = true
    
    var topViewModel:TopViewModel!
    
    init(viewModel: TopViewModel) {
        super.init(frame: CGRect.zero)
        self.topViewModel = viewModel
        createView()
        createTypeButtonView()
        
        //createSubTypeButtonView()
        //let titleArray = SearchItem.ScopeSubTypeAnimeSection.allCases.map({ $0.rawValue })
        stackedGrid(rows: 4, columns: 2, rootView: self, titleArray: titleArray)
        addConstraints()
    }
    
    lazy var searchViewModel: TopSearchViewModel = TopSearchViewModel(viewModel: self.topViewModel)
   
    var currentType = "anime"
    var currentSubType = "airing"
    
    var typeIndex = 0
 
  /*  init() {
        super.init(frame: CGRect.zero)
        createView()
        createTypeButtonView()
        
        //createSubTypeButtonView()
        //let titleArray = SearchItem.ScopeSubTypeAnimeSection.allCases.map({ $0.rawValue })
        stackedGrid(rows: 4, columns: 2, rootView: self, titleArray: titleArray)
        addConstraints()
        
    }*/
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
        createTypeButtonView()
       // searchViewModel = TopSearchViewModel(viewModel: topViewModel)
       // createSubTypeButtonView()
        stackedGrid(rows: 4, columns: 2, rootView: self, titleArray: titleArray)
        addConstraints()
        
    }
    
    var searchBar: UISearchBar!
  
    var typeIndicatorView: UIView!
    
    var typeContentView: UIStackView!
    var subTypeContentView: UIStackView!
    var subTypeHorizontalContentView: UIStackView!
 
    fileprivate var typeLeadingConstraint: NSLayoutConstraint!
    
    fileprivate var subTypeLeadingConstraint: NSLayoutConstraint!
    fileprivate var subTypeTopConstraint: NSLayoutConstraint!
    
    var subTypeButtons = [UIButton]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //typeIndicatorView.layer.cornerRadius = 3
    }
    
    func createView() {
        searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.delegate = self
        searchBar.placeholder = "Type to search...."
        searchBar.showsCancelButton = true

        self.addSubview(searchBar)
        
        subTypeContentView = UIStackView()
        subTypeContentView.axis = .vertical
        subTypeContentView.alignment = .fill
        subTypeContentView.distribution = .fillEqually
        subTypeContentView.spacing = 5.0
        
        self.addSubview(subTypeContentView)
        
        
    }
    
    func createTypeButtonView() {
        typeContentView = UIStackView()
        typeContentView.axis  = .horizontal
        typeContentView.distribution  = .fillEqually
        typeContentView.alignment = .center
        
        let titleArray = SearchItem.ScopeTypeSection.allCases.map({ $0.rawValue })
        
        for x in 0...SearchItem.ScopeTypeSection.allCases.count-1 {
            let button = UIButton()
            button.tag = x
            button.setTitle(titleArray[x], for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .lightGray
            button.addTarget(self, action: #selector(pressedType(sender:)), for: .touchUpInside)
            typeContentView.addArrangedSubview(button)
        }
        
       self.addSubview(typeContentView)
        
        typeIndicatorView = UIView()
        typeIndicatorView.backgroundColor = .white
        typeIndicatorView.alpha = 0.5
        typeIndicatorView.layer.cornerRadius = 0.5
        self.addSubview(typeIndicatorView)
    }
  
    func stackedGrid(rows: Int, columns: Int, rootView: UIView, titleArray: [String]){
        let mySpacing: CGFloat = 5.0

       // let titleArray = SearchItem.ScopeSubTypeAnimeSection.allCases.map({ $0.rawValue })
        
//        subTypeContentView = UIStackView()
//        subTypeContentView.axis = .vertical
//        subTypeContentView.alignment = .fill
//        subTypeContentView.distribution = .fillEqually
//        subTypeContentView.spacing = mySpacing
        
        subTypeButtons.removeAll()

        for row in 0 ..< rows {
            subTypeHorizontalContentView = UIStackView()
            subTypeHorizontalContentView.axis = .horizontal
            subTypeHorizontalContentView.alignment = .fill
            subTypeHorizontalContentView.distribution = .fillEqually
            subTypeHorizontalContentView.spacing = mySpacing

            for col in 0 ..< columns {
                let button = UIButton()
                button.tag = row * columns + col
                
               // print("tag == \(row * columns + col)")
                
                button.backgroundColor = .orange
                button.setTitle("\(titleArray[row * columns + col])", for: .normal)
                button.addTarget(self, action: #selector(pressedSubType(button:)), for: .touchUpInside)
                button.setTitleColor(.blue, for: .selected)
                button.setTitleColor(.white, for: .normal)
                
                if button.tag == 0 {
                    button.isSelected = true
                }
                
                subTypeButtons.append(button)
                subTypeHorizontalContentView.addArrangedSubview(button)
            }
            
            subTypeContentView.addArrangedSubview(subTypeHorizontalContentView)
        }
        
        

       // print(subTypeHorizontalContentView.subviews)
        

//        subTypeIndicatorView = UIView()
//        subTypeIndicatorView.backgroundColor = .white
//        subTypeIndicatorView.alpha = 0.5
//        subTypeIndicatorView.layer.cornerRadius = 0.5
//        self.addSubview(subTypeIndicatorView)
    }
    
    func addConstraints() {
        typeContentView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        typeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        subTypeContentView.translatesAutoresizingMaskIntoConstraints = false
        //subTypeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: self.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            typeContentView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            typeContentView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            typeContentView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            typeContentView.heightAnchor.constraint(equalToConstant: 44),
            
            typeIndicatorView.topAnchor.constraint(equalTo: typeContentView.arrangedSubviews[0].topAnchor, constant: 4),
            typeIndicatorView.widthAnchor.constraint(equalTo: typeContentView.arrangedSubviews[0].widthAnchor, multiplier: 0.9),
            typeIndicatorView.bottomAnchor.constraint(equalTo: typeContentView.arrangedSubviews[0].bottomAnchor, constant: -4),
            
            subTypeContentView.topAnchor.constraint(equalTo: typeContentView.bottomAnchor, constant: 0),
            subTypeContentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            subTypeContentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            subTypeContentView.heightAnchor.constraint(equalToConstant: 176),
            
            
//            subTypeIndicatorView.widthAnchor.constraint(equalTo: subTypeContentView.arrangedSubviews[0].widthAnchor, multiplier: 0.475),
//            subTypeIndicatorView.heightAnchor.constraint(equalToConstant: 32),

        ])
        
        typeLeadingConstraint = typeIndicatorView.leadingAnchor.constraint(equalTo: typeContentView.arrangedSubviews[0].leadingAnchor, constant: 4)
        typeLeadingConstraint.isActive = true
        
//        subTypeLeadingConstraint = subTypeIndicatorView.leadingAnchor.constraint(equalTo: subTypeContentView.arrangedSubviews[0].leadingAnchor, constant: 4)
//        subTypeLeadingConstraint.isActive = true
//
//        subTypeTopConstraint = subTypeIndicatorView.topAnchor.constraint(equalTo: subTypeContentView.arrangedSubviews[0].topAnchor, constant: 4)
        
      //  subTypeTopConstraint.isActive = true
    }
    
    @objc func pressedType(sender: UIButton!) {
        
        let move = typeContentView.arrangedSubviews[sender.tag].frame.origin.x + 4
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.typeLeadingConstraint.constant = move
            self?.setNeedsLayout()
            self?.layoutIfNeeded()
        }
        
        typeIndex = sender.tag
        
        switch sender.tag {
        case 0:
           
            hasSubtype = true
            let titleArray = SearchItem.ScopeSubTypeAnimeSection.allCases.map({ $0.rawValue })
            subTypeContentView.safelyRemoveArrangedSubviews()
            subTypeHorizontalContentView.safelyRemoveArrangedSubviews()
            stackedGrid(rows: 4, columns: 2, rootView: self, titleArray: titleArray)
            currentSubType = "airing"
        case 1:
           
            hasSubtype = true
            let titleArray = SearchItem.ScopeSubTypeMangaSection.allCases.map({ $0.rawValue })
            subTypeContentView.safelyRemoveArrangedSubviews()
            subTypeHorizontalContentView.safelyRemoveArrangedSubviews()
            stackedGrid(rows: 4, columns: 2, rootView: self, titleArray: titleArray)
            currentSubType = "manga"
            
        case 2:
         
            hasSubtype = false
            subTypeContentView.safelyRemoveArrangedSubviews()
            subTypeHorizontalContentView.safelyRemoveArrangedSubviews()
            
        case 3:
           
            hasSubtype = false
            subTypeContentView.safelyRemoveArrangedSubviews()
            subTypeHorizontalContentView.safelyRemoveArrangedSubviews()
            
        default:
            break
        }
       
        changeSubTypeHeight()
        
        currentType = SearchItem.ScopeTypeSection.allCases[sender.tag].rawValue
        
        if (currentType == "people") {
            topViewModel.fetchDataWithoutType(type: currentType, subType: "")
        } else if (currentType == "characters") {
            topViewModel.fetchDataWithoutType(type: currentType, subType: "")
        } else {
            topViewModel.fetchDataByType(type: currentType, subType: currentSubType)
        }
        
        
    }
    
    @objc func pressedSubType(button: UIButton) {
    
        let _ = subTypeButtons.map({$0.isSelected = false})
        button.isSelected = true
        
        currentType = SearchItem.ScopeTypeSection.allCases[typeIndex].rawValue
        
        if (currentType == "anime") {
            currentSubType = SearchItem.ScopeSubTypeAnimeSection.allCases[button.tag].rawValue
        } else if (currentType == "manga") {
            currentSubType = SearchItem.ScopeSubTypeMangaSection.allCases[button.tag].rawValue
        } else {
            currentSubType = ""
        }
        
        topViewModel.fetchDataByType(type: currentType, subType: currentSubType)
    }
    
    func changeSubTypeHeight() {
        if hasSubtype {
            topViewModel.typeViewHeightConstraint.constant = 270
            topViewModel.topTableViewConstraint.constant = 270
        } else {
            topViewModel.typeViewHeightConstraint.constant = 88
            topViewModel.topTableViewConstraint.constant = 88
        }
    }
}

extension CustomizeSearchView :UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text.isEmptyOrWhitespace() {
            return
        }
        
        guard let searchText = searchBar.text else {
            return
        }
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
       
        self.searchViewModel.searchFor(text: strippedString, type: currentType, subType: currentSubType)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeSearchView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            closeSearchView()
        } else {
            if searchBar.text.isEmptyOrWhitespace() {
                return
            }
            
            guard let searchText = searchBar.text else {
                return
            }
            
            // Strip out all the leading and trailing spaces.
            let whitespaceCharacterSet = CharacterSet.whitespaces
            let strippedString =
                searchText.trimmingCharacters(in: whitespaceCharacterSet)
           
            self.searchViewModel.searchFor(text: strippedString, type: currentType, subType: currentSubType)
        }
    }
    
    func closeSearchView() {
        self.searchViewModel.didCloseSearchFunction()
        endEditing(true)
    }
}
