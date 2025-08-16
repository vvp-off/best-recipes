//
//  PopularCreatorsCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 14.08.25.
//

import UIKit

class PopularCreatorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let creatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 55
        return iv
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
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
    func configure() {
       
    }
}

// MARK: - Layout
extension PopularCreatorCollectionViewCell {
    func setupCell() {
        setupImageView()
        setupCreatorLabel() 
    }
    
    func setupImageView() {
        contentView.addSubview(creatorImageView)
        creatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            creatorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            creatorImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            creatorImageView.widthAnchor.constraint(equalToConstant: 110),
            creatorImageView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func setupCreatorLabel() {
        contentView.addSubview(creatorNameLabel)
        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.text = "Kathryn Murphy"
        creatorNameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            creatorNameLabel.topAnchor.constraint(equalTo: creatorImageView.bottomAnchor, constant: 16),
            creatorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            creatorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            creatorNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

