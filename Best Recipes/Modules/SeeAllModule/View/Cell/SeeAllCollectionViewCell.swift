//
//  SeeAllCollectionViewCell.swift
//  Best Recipes
//
//  Created by Иван Семенов on 14.08.2025.
//

import UIKit
import Kingfisher

final class SeeAllCollectionViewCell: UICollectionViewCell {
    // MARK: - Private properties
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var ratingLabel: UILabel = {
        $0.text = "5,0"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var titleRecipe: UILabel = {
        $0.numberOfLines = 2
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
        $0.text = "How to make yam & vegetable sauce at home"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var infoRecipe: UILabel = {
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.text = "9 Ingredients | 25 min"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var ratingImage: UIImageView = {
        let smallFont = UIFont.systemFont(ofSize: 12)
        let configuration = UIImage.SymbolConfiguration(font: smallFont)
        let image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 10
        blurView.clipsToBounds = true
        view.addSubview(blurView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    ///bookmark
    let addButton = CustomAddButton()
    
    // MARK: - State
    private var onAddTap: (() -> Void)?
    private(set) var isSaved: Bool = false {
        didSet { addButton.toggle(with: isSaved) }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addButtonTapped()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        ratingLabel.text = nil
        titleRecipe.text = nil
        infoRecipe.text = nil
        onAddTap = nil
        isSaved = false
    }
    
    //MARK: Private
    private func addButtonTapped() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.onAddTap?()
            self.isSaved.toggle()
        }
        addButton.addAction(action, for: .touchUpInside)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true
        
        ///Subview hierarchy
        contentView.addSubview(imageView)
        contentView.addSubview(ratingView)
        ratingView.addSubview(ratingImage)
        ratingView.addSubview(ratingLabel)
        contentView.addSubview(infoRecipe)
        contentView.addSubview(titleRecipe)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            ratingView.widthAnchor.constraint(greaterThanOrEqualToConstant: 58),
            ratingView.heightAnchor.constraint(equalToConstant: 27),
            
            ratingImage.widthAnchor.constraint(equalToConstant: 14),
            ratingImage.heightAnchor.constraint(equalToConstant: 14),
            ratingImage.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor, constant: 0),
            ratingImage.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 8),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor, constant: 0),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingImage.trailingAnchor, constant: 6),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -8),
            
            infoRecipe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            infoRecipe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            infoRecipe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            titleRecipe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleRecipe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            titleRecipe.bottomAnchor.constraint(equalTo: infoRecipe.topAnchor, constant: -8),
            
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    //MARK: Public
    func configureCell(recipe: RecipeProtocol, onAddTap: @escaping () -> Void) {
        let image = recipe.image ?? ""
        let title = recipe.title
        
        titleRecipe.text = title
        ratingLabel.text = recipe.rating
        
        let minutes = recipe.readyInMinutes ?? 0
        let ingCount = recipe.extendedIngredients?.count ?? 0
        infoRecipe.text = "\(ingCount) Ingredients | \(minutes) min"
        
        if let url = URL(string: image) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
        self.onAddTap = onAddTap
    }
}
