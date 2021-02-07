//
//  TopTableViewCell.swift
//  Jikan
//
//  Created by William Liao on 2021/2/7.
//  Copyright © 2021 William Liao. All rights reserved.
//

import UIKit
import Combine

class TopTableViewCell: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: TopTableViewCell.self)
    }
    
    var titleLabel: UILabel!
    var topImageView: UIImageView!
    var rankLabel: UILabel!
    var startLabel: UILabel!
    var endLabel: UILabel!
    var typeLabel: UILabel!
    
//    var viewModel: TopViewModel? {
//        didSet {
//            if let vm = viewModel {
//                vm.isLoading.bind { [weak self]  (_) in
//                    self?.isLoading(isLoading: vm.isLoading.value)
//                }
//            }
//        }
//    }
    
    private var cancellable: AnyCancellable?
    private var animator: UIViewPropertyAnimator?
    
    private var act = UIActivityIndicatorView(style: .large)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureConstraints()
    }
    
    private func configureView() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        rankLabel = UILabel()
        rankLabel.font = UIFont.systemFont(ofSize: 14)
        
        startLabel = UILabel()
        startLabel.font = UIFont.systemFont(ofSize: 14)
        
        endLabel = UILabel()
        endLabel.font = UIFont.systemFont(ofSize: 14)
        
        typeLabel = UILabel()
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        
        topImageView = UIImageView()
        
        //act.startAnimating()

        contentView.addSubview(titleLabel)
        contentView.addSubview(rankLabel)
        contentView.addSubview(topImageView)
        contentView.addSubview(startLabel)
        contentView.addSubview(endLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(act)
    }
    
    private func configureConstraints() {
        act.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            topImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            topImageView.widthAnchor.constraint(equalToConstant: 44),
            topImageView.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: topImageView.trailingAnchor, constant: 10),
            //titleLabel.trailingAnchor.constraint(equalTo: rankLabel.leadingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            
            startLabel.leadingAnchor.constraint(equalTo: topImageView.trailingAnchor, constant: 10),
            //startLabel.trailingAnchor.constraint(equalTo: rankLabel.leadingAnchor),
            startLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            startLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            endLabel.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor, constant: 10),
            endLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            endLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            rankLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rankLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            //rankLabel.widthAnchor.constraint(equalToConstant: 44),
            rankLabel.heightAnchor.constraint(equalToConstant: 16),
            
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeLabel.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 10),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            act.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            act.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureImage(with url: URL) {
        cancellable = loadImage(for: url).sink { [unowned self] image in self.showImage(image: image) }
    }
    
    private func showImage(image: UIImage?) {
        topImageView.alpha = 0.0
        topImageView.image = image
        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.topImageView.alpha = 1.0
        })
    }

    private func loadImage(for url: URL) -> AnyPublisher<UIImage?, Never> {
        return Just(url)
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            //let url = URL(string: urlString)!
            return ImageLoader.shared.loadImage(from: url)
        })
        .eraseToAnyPublisher()
    }
    
    func isLoading(isLoading: Bool) {
        if isLoading {
            act.startAnimating()
        } else {
            act.stopAnimating()
        }
        act.isHidden = !isLoading
    }
}

extension TopTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        topImageView.image = nil
        topImageView.alpha = 0.0
        animator?.stopAnimation(true)
        cancellable?.cancel()
    }
}
