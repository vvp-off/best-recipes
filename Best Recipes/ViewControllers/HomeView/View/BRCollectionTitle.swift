//
//  BRCollectionTitle.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import UIKit

class BRCollectionTitle: UIView {
    
    // MARK: - UI Elements
    let titleLabel = UILabel()
    let seeAllButton = UIButton()
    let arrowImageView = UIImageView()
    var onSeeAll: (() -> Void)?

    // MARK: - Initializers
    init(title: String, showSeeAll: Bool = true) {
        super.init(frame: .zero)
        setupViews()
        configure(title: title, showSeeAll: showSeeAll)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(title: String, showSeeAll: Bool = true) {
        titleLabel.text = title
        seeAllButton.isHidden = !showSeeAll
    }
}

private extension BRCollectionTitle {
    func setupViews() {
        setUpView()
        setUpTitle()
        setupSeeAll()
    }
    
    func setUpView() {
        self.backgroundColor = .clear
    }
    
    func setUpTitle() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .poppinsBold(size: 20)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setupSeeAll() {
        addSubview(seeAllButton)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.titleLabel?.font = .poppinsBold(size: 14)
        seeAllButton.setTitleColor(.red, for: .normal)
        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.setImage(UIImage(named: "arrow 1"), for: .normal)
        seeAllButton.semanticContentAttribute = .forceRightToLeft
        let spacing: CGFloat = 5
        seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
        seeAllButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
        
        seeAllButton.addAction(UIAction(handler: { [weak self] _ in
            self?.onSeeAll?()
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
