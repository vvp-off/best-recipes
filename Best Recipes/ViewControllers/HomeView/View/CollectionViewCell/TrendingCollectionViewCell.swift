//
//  TrendingCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class TrandingCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let authorImageView = UIImageView()
    let authorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TrandingCollectionViewCell {
    func setupCell() {
        setupimageView()
        setupTitleLabel()
        setupauthorImageView()
        setupauthorLabel()
    }
    
    func setupimageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "How to sharwama at home"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func  setupauthorImageView() {
        contentView.addSubview(authorImageView)
        authorImageView.backgroundColor = .lightGray
        authorImageView.layer.cornerRadius = 16
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorImageView.widthAnchor.constraint(equalToConstant: 32),
            authorImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupauthorLabel() {
        contentView.addSubview(authorLabel)
        authorLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        authorLabel.textColor = .gray
        authorLabel.text = "By Zeelicious foods"
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            authorLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
}
