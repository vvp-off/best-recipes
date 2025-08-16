//
//  RecentRecipeCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 14.08.25.
//

import UIKit

class RecentRecipeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = .gray
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
extension RecentRecipeCollectionViewCell {
    func setupCell() {
        setupImageView()
        setupRecipeNameLabel()
        setupauthorLabel()
    }
    
    func setupImageView() {
        contentView.addSubview(recipeImageView)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 124),
            recipeImageView.heightAnchor.constraint(equalToConstant: 124)
        ])
    }
    
    func setupRecipeNameLabel() {
        contentView.addSubview(recipeNameLabel)
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.text = "Kelewele Ghanian Recipe"
        recipeNameLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            recipeNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupauthorLabel() {
        contentView.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.text = "By Zeelicious Foods"
        authorLabel.clipsToBounds = false
        authorLabel.baselineAdjustment = .alignCenters  
        authorLabel.lineBreakMode = .byTruncatingTail
        authorLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            authorLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
