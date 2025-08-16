//
//  CategoryViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 13.08.25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let labelColor = UIColor(red: 243/255.0, green: 178/255.0, blue: 178/255.0, alpha: 1.0)
        label.textColor = labelColor
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with title: String) {
       
    }
}

// MARK: - Layout
extension CategoryCollectionViewCell {
    func setupCell() {
        setupContainerView()
        setupTitleLabel()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 83),
            containerView.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
