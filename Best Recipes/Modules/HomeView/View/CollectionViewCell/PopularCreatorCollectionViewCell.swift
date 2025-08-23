//
//  PopularCreatorsCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 14.08.25.
//

import UIKit

class PopularCreatorCollectionViewCell: UICollectionViewCell {
    
    private let popularCreators = ["Avatar", "Avatar1", "Avatar2", "Avatar3", "Avatar4", "Avatar5"]
    private let popularName = ["Ify’s Kitchen", "Kathryn Murphy", "Jerome Bell", "Anna May", "Emily Carter", "Claire Bennett"]
    
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
        label.font = .poppinsBold(size: 12)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        creatorImageView.image = nil
    }
    
    // MARK: - Configuration
    func configure(with recipe: RecipeInfo) {
        let nameIndex = abs(recipe.id.hashValue) % popularName.count
        let name = popularName[nameIndex]
        let avatar = popularCreators[nameIndex]
        creatorNameLabel.text = name
        creatorImageView.image = UIImage(named: avatar)
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
            creatorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

