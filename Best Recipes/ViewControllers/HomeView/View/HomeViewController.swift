//
//  HomwViewController.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: HomePresenterProtocol
    
    // MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchField = BRSearchField()
    private let trendingCollectionTitle = BRCollectionTitle(title: "Trending now 🔥")
    private let popularCategoryCollectionTitle = BRCollectionTitle(title: "Popular category", showSeeAll: false)
    private let recentRecipeCollectionTitle = BRCollectionTitle(title: "Recent recipe")
    private let poopularCreatorsCollectionTitle = BRCollectionTitle(title: "Popular creators")
    
    lazy var trendingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 1
        return collection
    }()
    
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 2
        return collection
    }()
    
    lazy var popularCategoryCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 3
        return collection
    }()
    
    lazy var recentRecipeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 4
        return collection
    }()
    
    lazy var popularCreatorCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.tag = 5
        return collection
    }()
    
    // MARK: - Initializers
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationTitle()
        setupViews()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let titleLabel = UILabel()
        titleLabel.text = "Get amazing recipes for cooking"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
            
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: UIColor.black,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.firstLineHeadIndent = 16
                style.headIndent = 16
                style.headIndent = -16
                return style
            }()
        ]
    }
}

// MARK: - Layout
extension HomeViewController {
    func setupViews() {
        setupScrollView()
        setupContentView()
        setupSearchView()
        setupTrendingCollectionTitle()
        setupTrendingCollectionView()
        setupPopularCollectionTitle()
        setupCategoriesCollectionView()
        setupPopularCollectionView()
        setupRecentRecipeCollectionTitle()
        setupRecentRecipeCollectionView()
        setupPopularCreatorsCollectionTitle()
        setupPopularCreatorCollectionView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupSearchView() {
        contentView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupTrendingCollectionTitle() {
        contentView.addSubview(trendingCollectionTitle)
        trendingCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trendingCollectionTitle.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            trendingCollectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trendingCollectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            trendingCollectionTitle.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupTrendingCollectionView() {
        contentView.addSubview(trendingCollection)
        trendingCollection.translatesAutoresizingMaskIntoConstraints = false
        trendingCollection.delegate = self
        trendingCollection.dataSource = self
        trendingCollection.showsHorizontalScrollIndicator = false
        trendingCollection.register(TrandingCollectionViewCell.self, forCellWithReuseIdentifier: "TrandingViewCell")
    
        NSLayoutConstraint.activate([
            trendingCollection.topAnchor.constraint(equalTo: trendingCollectionTitle.bottomAnchor, constant: 10),
            trendingCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trendingCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trendingCollection.heightAnchor.constraint(equalToConstant: 240),
        ])
    }
    
    func setupPopularCollectionTitle() {
        contentView.addSubview(popularCategoryCollectionTitle)
        popularCategoryCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popularCategoryCollectionTitle.topAnchor.constraint(equalTo: trendingCollection.bottomAnchor, constant: 20),
            popularCategoryCollectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            popularCategoryCollectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            popularCategoryCollectionTitle.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupCategoriesCollectionView() {
        contentView.addSubview(categoriesCollectionView)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryViewCell")
    
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: popularCategoryCollectionTitle.bottomAnchor, constant: 10),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func setupPopularCollectionView() {
        contentView.addSubview(popularCategoryCollection)
        popularCategoryCollection.translatesAutoresizingMaskIntoConstraints = false
        popularCategoryCollection.delegate = self
        popularCategoryCollection.dataSource = self
        popularCategoryCollection.showsHorizontalScrollIndicator = false
        popularCategoryCollection.register(PopularCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "PopularViewCell")
    
        NSLayoutConstraint.activate([
            popularCategoryCollection.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor, constant: 10),
            popularCategoryCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popularCategoryCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            popularCategoryCollection.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
    
    func setupRecentRecipeCollectionTitle() {
        contentView.addSubview(recentRecipeCollectionTitle)
        recentRecipeCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentRecipeCollectionTitle.topAnchor.constraint(equalTo: popularCategoryCollection.bottomAnchor, constant: 20),
            recentRecipeCollectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentRecipeCollectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recentRecipeCollectionTitle.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupRecentRecipeCollectionView() {
        contentView.addSubview(recentRecipeCollection)
        recentRecipeCollection.translatesAutoresizingMaskIntoConstraints = false
        recentRecipeCollection.delegate = self
        recentRecipeCollection.dataSource = self
        recentRecipeCollection.showsHorizontalScrollIndicator = false
        recentRecipeCollection.register(RecentRecipeCollectionViewCell.self, forCellWithReuseIdentifier: "RecentViewCell")
    
        NSLayoutConstraint.activate([
            recentRecipeCollection.topAnchor.constraint(equalTo: recentRecipeCollectionTitle.bottomAnchor, constant: 10),
            recentRecipeCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recentRecipeCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recentRecipeCollection.heightAnchor.constraint(equalToConstant: 210),
        ])
    }
    
    func setupPopularCreatorsCollectionTitle() {
        contentView.addSubview(poopularCreatorsCollectionTitle)
        poopularCreatorsCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            poopularCreatorsCollectionTitle.topAnchor.constraint(equalTo: recentRecipeCollection.bottomAnchor, constant: 20),
            poopularCreatorsCollectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            poopularCreatorsCollectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            poopularCreatorsCollectionTitle.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupPopularCreatorCollectionView() {
        contentView.addSubview(popularCreatorCollection)
        popularCreatorCollection.translatesAutoresizingMaskIntoConstraints = false
        popularCreatorCollection.delegate = self
        popularCreatorCollection.dataSource = self
        popularCreatorCollection.showsHorizontalScrollIndicator = false
        popularCreatorCollection.register(PopularCreatorCollectionViewCell.self, forCellWithReuseIdentifier: "PopularCreatorViewCell")
    
        NSLayoutConstraint.activate([
            popularCreatorCollection.topAnchor.constraint(equalTo: poopularCreatorsCollectionTitle.bottomAnchor, constant: 10),
            popularCreatorCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            popularCreatorCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            popularCreatorCollection.heightAnchor.constraint(equalToConstant: 144),
            popularCreatorCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - CollectionView delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return 10
        case 2:
            return 10
        case 3:
            return 10
        case 4:
            return 10
        case 5:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrandingViewCell", for: indexPath)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath)
            return cell 
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularViewCell", for: indexPath)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentViewCell", for: indexPath)
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCreatorViewCell", for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: 240, height: 240)
        case 2:
            return CGSize(width: 83, height: 34)
        case 3:
            return CGSize(width: 150, height: 230)
        case 4:
            return CGSize(width: 124, height: 210)
        case 5:
            return CGSize(width: 110, height: 144)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
