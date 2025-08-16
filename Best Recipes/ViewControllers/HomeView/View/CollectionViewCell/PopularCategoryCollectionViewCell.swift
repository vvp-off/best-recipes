//
//  PopularCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 13.08.25.
//

import UIKit

class PopularCategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 55
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    private let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let timeStackView = UIStackView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//     MARK: - Configuration
    func configure() {}
}

// MARK: - Layout
extension PopularCategoryCollectionViewCell {
    func setupCell() {
        setupBacgroundView()
        setupImageView()
        setupTitleLabel()
        setupTimeStackView()
    }
    
    func setupBacgroundView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 55),
            containerView.widthAnchor.constraint(equalToConstant: 150),
            containerView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    func setupImageView() {
        contentView.addSubview(recipeImageView)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 110),
            recipeImageView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Chicken and Vegetable wrap"
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:recipeImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupTimeStackView() {
        let timeStackView = UIStackView(arrangedSubviews: [timeLabel, timeTitleLabel])
        containerView.addSubview(timeStackView)
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "Time"
        timeTitleLabel.text = "5 Mins"
        timeStackView.spacing = 5
        timeStackView.alignment = .leading
        timeStackView.distribution = .fill
        timeStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            timeStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            timeStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.heightAnchor.constraint(equalToConstant: 10),
            timeTitleLabel.heightAnchor.constraint(equalToConstant: 10),
            timeStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}






