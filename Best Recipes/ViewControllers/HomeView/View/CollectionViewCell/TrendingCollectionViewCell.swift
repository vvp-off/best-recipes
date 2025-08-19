//
//  TrendingCollectionViewCell.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class TrandingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorLabel = UILabel()
    private let addButton = CustomAddButton()
    private let popularCreators = ["Avatar", "Avatar1", "Avatar2", "Avatar3", "Avatar4", "Avatar5"]
    
    // MARK: - State
    private var onAddTap: (() -> Void)?
    private(set) var isSaved: Bool = false {
        didSet { addButton.toggle(with: isSaved) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        setupCell()
        addButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        authorImageView.image = nil
        authorLabel.text = nil
        onAddTap = nil
        isSaved = false
    }
    
    
    private func addButtonTapped() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.onAddTap?()
            self.isSaved.toggle()
        }
        addButton.addAction(action, for: .touchUpInside)
    }
    
    func configure(with recipe: RecipeInfo, onAddTap: @escaping () -> Void) {
        if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        titleLabel.text = recipe.title
        authorLabel.text = recipe.sourceName
        
        let nameIndex = abs(recipe.id.hashValue) % popularCreators.count
        let avatar = popularCreators[nameIndex]
        authorImageView.image = UIImage(named: avatar)
        self.onAddTap = onAddTap
    }
}

extension TrandingCollectionViewCell {
    func setupCell() {
        setupimageView()
        setupTitleLabel()
        setupauthorImageView()
        setupauthorLabel()
        setupBookmark()
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
        titleLabel.textColor = .black
        titleLabel.font = .poppinsBold(size: 16)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
            authorLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
    
    func setupBookmark() {
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
