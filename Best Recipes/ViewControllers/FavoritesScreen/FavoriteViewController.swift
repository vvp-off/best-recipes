//
//  FavoriteViewController.swift
//  Best Recipes
//
//  Created by artyom s on 14.08.2025.
//

import UIKit

struct FavoriteCellModel: Hashable {
    let id = UUID()
    var score = 0.0
    var isFavorite = false
    var duration = 0.0
    var image = UIImage(named: "foodplaceholder")!
    var title = "How to make a delicious pizza"
    var authorImage = UIImage(named: "authorimageplaceholder")!
    var author = "John Doe"
}

enum Section: Hashable {
    case main
}

final class FavoriteViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, FavoriteCellModel>!
    
    static func create() -> UIViewController {
        let viewController = FavoriteViewController()
        viewController.navigationItem.title = "Saved recipes"
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        initData()
        
    }
    
    
    private func configureCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(250)
            )
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(250)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16)
            return section
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseID)
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FavoriteCellModel>(collectionView: collectionView) { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
            cell.configure(with: model)
            return cell
        }
    }
    
    private func initData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavoriteCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems([
            FavoriteCellModel(score: 4.8, isFavorite: true, duration: 15),
            FavoriteCellModel(score: 4.5, isFavorite: false, duration: 25),
            FavoriteCellModel(score: 4.9, isFavorite: false, duration: 10)
        ])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
}




private final class FavoriteCell: UICollectionViewCell {
    static let reuseID = "FavoriteCell"
    
    private let mainImageView = UIImageView()
    private let titleText = UILabel()
    private let authorImageView = CircleImageView()
    private let authorLabel = UILabel()
    private let scoreLabel = ScoreLabel()
    private let durationLabel = TimeLabel()
    
    private let favoriteButton = CircleButton(type: .system)
    
    private var currentModel: FavoriteCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: FavoriteCellModel) {
        currentModel = model
        
        mainImageView.image = model.image
        titleText.text = model.title
        authorImageView.image = model.authorImage
        authorLabel.text = "By \(model.author)"
        scoreLabel.configure(ratingValue: 2)
        
        
        
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        if let formattedTime = formatter.string(from: model.duration) {
            durationLabel.configure(timeText: formattedTime)
        }
        
        
        
        let favImage = UIImage(named: model.isFavorite ? "TabBarItem2Red" : "TabBarItem2")
        favoriteButton.setImage(favImage, for: .normal)
        favoriteButton.tintColor = model.isFavorite ? .systemRed : .systemGray
        favoriteButton.backgroundColor = .white
        
    }
    
    private func configureUI() {
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.layer.cornerRadius = 10
        
        titleText.font = .boldSystemFont(ofSize: 16)
        titleText.numberOfLines = 2
        
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = 12
        
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .secondaryLabel
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        let authorStack = UIStackView(arrangedSubviews: [authorImageView, authorLabel])
        authorStack.axis = .horizontal
        authorStack.spacing = 6
        authorStack.alignment = .center
                
        let mainStack = UIStackView(arrangedSubviews: [mainImageView, authorStack, titleText])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        
        
        
        contentView.addSubview(mainStack)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(durationLabel)
        contentView.addSubview(scoreLabel)
        
        
        
        
        [durationLabel, scoreLabel, mainStack, favoriteButton, authorImageView, mainImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        mainStack.pinEdgesToView(contentView)
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 180),
            
            scoreLabel.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: 8),
            scoreLabel.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 8),
            
            
            
            favoriteButton.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            authorImageView.widthAnchor.constraint(equalToConstant: 32),
            authorImageView.heightAnchor.constraint(equalToConstant: 32),
            
            durationLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -8),
            durationLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -8)
        ])
    }
    
    @objc private func favoriteTapped() {
        guard var model = currentModel else { return }
        model.isFavorite.toggle()
        configure(with: model)
    }
}

